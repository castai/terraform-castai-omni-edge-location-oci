# OCI Edge Location for CAST AI

# Generate random suffix for edge location name
resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  # Generate name if not provided (with random suffix)
  generated_name = var.name != null ? var.name : "oci-${var.region}-${random_id.suffix.hex}"

  # Sanitize name for OCI resource naming
  sanitized_name = lower(replace(local.generated_name, "/[^a-zA-Z0-9-]/", "-"))

  # Full resource name with prefix
  resource_name = "castai-omni-${local.sanitized_name}"

  # Unique policy name per edge location
  policy_name = "castai-edge-location-${local.sanitized_name}"

  # Get tenancy OCID from variable (should match OCI provider configuration)
  tenancy_id = var.tenancy_id

  # Use provided compartment_id or fall back to tenancy root compartment
  compartment_id = var.compartment_id != null ? var.compartment_id : var.tenancy_id
}

# Data source to get availability domains for the region configured in OCI provider
data "oci_identity_availability_domains" "ads" {
  compartment_id = local.compartment_id
}

# Validation: Ensure the input region matches the OCI provider's configured region
resource "null_resource" "validate_region" {
  lifecycle {
    precondition {
      condition     = length(data.oci_identity_availability_domains.ads.availability_domains) > 0
      error_message = "No availability domains found. Ensure the OCI provider is configured with a valid region for the compartment."
    }

    precondition {
      condition = anytrue([
        for ad in data.oci_identity_availability_domains.ads.availability_domains :
        length(regexall("(?i)${replace(var.region, "/^[a-z]+-([a-z]+)-\\d+$/", "$1")}", ad.name)) > 0
      ])
      error_message = "The input region '${var.region}' does not match the OCI provider's configured region. Available domains: ${join(", ", [for ad in data.oci_identity_availability_domains.ads.availability_domains : ad.name])}. Ensure the OCI provider region matches the input region parameter."
    }
  }
}

# =============================================================================
# VCN and Networking
# =============================================================================

# Virtual Cloud Network
resource "oci_core_vcn" "main" {
  compartment_id = local.compartment_id
  display_name   = local.resource_name
  cidr_blocks    = [var.vcn_cidr]

  freeform_tags = var.tags
}

# Internet Gateway
resource "oci_core_internet_gateway" "main" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = local.resource_name
  enabled        = true

  freeform_tags = var.tags
}

# Default Route Table - update with internet gateway route
resource "oci_core_default_route_table" "main" {
  manage_default_resource_id = oci_core_vcn.main.default_route_table_id
  display_name               = local.resource_name

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.main.id
  }

  freeform_tags = var.tags
}

# Security List
resource "oci_core_security_list" "main" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = local.resource_name

  # Egress rule - allow all outbound
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }

  # Ingress rule - TCP 443
  ingress_security_rules {
    source    = var.security_list_source_cidr
    protocol  = "6" # TCP
    stateless = false

    tcp_options {
      min = 443
      max = 443
    }
  }

  # Ingress rule - TCP 6443
  ingress_security_rules {
    source    = var.security_list_source_cidr
    protocol  = "6" # TCP
    stateless = false

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # Ingress rule - UDP 51840
  ingress_security_rules {
    source    = var.security_list_source_cidr
    protocol  = "17" # UDP
    stateless = false

    udp_options {
      min = 51840
      max = 51840
    }
  }

  freeform_tags = var.tags
}

# Regional Subnet
resource "oci_core_subnet" "main" {
  compartment_id    = local.compartment_id
  vcn_id            = oci_core_vcn.main.id
  cidr_block        = var.subnet_cidr
  display_name      = local.resource_name
  route_table_id    = oci_core_vcn.main.default_route_table_id
  security_list_ids = [oci_core_security_list.main.id]

  freeform_tags = var.tags
}

# =============================================================================
# IAM User, Group, and Policy
# =============================================================================

# IAM User for CAST AI
resource "oci_identity_user" "castai" {
  compartment_id = local.tenancy_id
  name           = local.resource_name
  description    = "CAST AI user for edge location ${local.generated_name}"

  freeform_tags = var.tags
}

# IAM Group for CAST AI
resource "oci_identity_group" "castai" {
  compartment_id = local.tenancy_id
  name           = local.resource_name
  description    = "Cast AI group for edge location ${local.generated_name}"

  freeform_tags = merge(
    var.tags,
    {
      "cast-omni:edge-location-name" = local.generated_name
    }
  )
}

# Add user to group
resource "oci_identity_user_group_membership" "castai" {
  user_id  = oci_identity_user.castai.id
  group_id = oci_identity_group.castai.id
}

# IAM Policy (unique per edge location)
# This policy grants the CAST AI group permissions to manage compute and network resources
resource "oci_identity_policy" "castai" {
  compartment_id = local.tenancy_id
  name           = local.policy_name
  description    = "Cast AI policy for edge location ${local.generated_name} in compartment ${local.compartment_id}"
  version_date   = "2025-10-20"

  statements = [
    # Instance management - full access to instance family
    "Allow group id ${oci_identity_group.castai.id} to manage instance-family in compartment id ${local.compartment_id}",

    # Volume management - full access to volume family
    "Allow group id ${oci_identity_group.castai.id} to manage volume-family in compartment id ${local.compartment_id}",

    # Virtual network usage and read
    "Allow group id ${oci_identity_group.castai.id} to use virtual-network-family in compartment id ${local.compartment_id}",
    "Allow group id ${oci_identity_group.castai.id} to read virtual-network-family in compartment id ${local.compartment_id}",

    # Identity read permissions (users, groups)
    "Allow group id ${oci_identity_group.castai.id} to read users in tenancy",
    "Allow group id ${oci_identity_group.castai.id} to read groups in tenancy",

    # Compartment read permissions
    "Allow group id ${oci_identity_group.castai.id} to read compartments in tenancy"
  ]

  freeform_tags = var.tags
}

# =============================================================================
# API Key for User Authentication
# =============================================================================

# Generate API key pair for the user
resource "tls_private_key" "castai_api_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Upload public key to OCI user
resource "oci_identity_api_key" "castai" {
  user_id   = oci_identity_user.castai.id
  key_value = tls_private_key.castai_api_key.public_key_pem

  depends_on = [
    oci_identity_user_group_membership.castai,
    oci_identity_policy.castai
  ]
}

# =============================================================================
# CAST AI Edge Location
# =============================================================================

resource "castai_edge_location" "this" {
  name            = local.generated_name
  region          = var.region
  cluster_id      = var.cluster_id
  organization_id = var.organization_id
  description     = var.description != null ? var.description : "OCI edge location onboarded by Terraform"
  zones = [
    for ad in data.oci_identity_availability_domains.ads.availability_domains : {
      id   = regex("-(\\d+)$", ad.name)[0]
      name = ad.name
    }
  ]

  # OCI cloud provider configuration
  oci = {
    tenancy_id            = local.tenancy_id
    compartment_id        = local.compartment_id
    user_id_wo            = oci_identity_user.castai.id
    fingerprint_wo        = oci_identity_api_key.castai.fingerprint
    private_key_base64_wo = base64encode(tls_private_key.castai_api_key.private_key_pem)
    vcn_id                = oci_core_vcn.main.id
    subnet_id             = oci_core_subnet.main.id
  }
}
