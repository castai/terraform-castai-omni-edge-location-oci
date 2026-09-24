# =============================================================================
# Existing cluster
# =============================================================================
# This example assumes the cluster already exists and is onboarded to CAST AI
# with Omni installed. Only the CAST AI cluster ID and organization ID are
# required - both can be found in the CAST AI console
# (Clusters -> <your cluster> for the cluster ID, Settings -> Organization
# for the organization ID).

# =============================================================================
# Create edge locations
# =============================================================================

# SSH key is injected into edge instances via cloud-init user data.
# castai_edge_configuration has no native SSH key field, but OCI images run
# cloud-init, so a #cloud-config payload with ssh_authorized_keys adds the
# key to the default user (opc on Oracle Linux images).
locals {
  user_data = <<-EOT
    #cloud-config
    ssh_authorized_keys:
      - ${var.ssh_public_key}
  EOT
}

module "castai_oci_edge_location" {
  source = "castai/omni-edge-location-oci/castai"

  providers = {
    oci      = oci
    oci.home = oci.home
  }

  cluster_id      = var.castai_cluster_id
  organization_id = var.castai_organization_id

  region         = var.oci_region
  tenancy_id     = var.oci_tenancy_id
  compartment_id = var.oci_compartment_id

  default_edge_configuration_name = "omni-oci"

  edge_configurations = {
    omni-oci = {
      name             = "omni-oci"
      user_data_base64 = base64encode(local.user_data)
    }
  }

  addons = [
    {
      name = "nvidia-gpu-operator"
    }
  ]
}
