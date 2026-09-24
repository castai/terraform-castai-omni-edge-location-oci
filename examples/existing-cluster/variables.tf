variable "castai_api_token" {
  type      = string
  sensitive = true
}

variable "castai_api_url" {
  type    = string
  default = "https://api.cast.ai"
}

variable "castai_cluster_id" {
  type        = string
  description = "CAST AI cluster ID of the existing, already onboarded cluster. Found in the CAST AI console."
}

variable "castai_organization_id" {
  type        = string
  description = "CAST AI organization ID. Found in the CAST AI console under Settings -> Organization."
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key added to edge instances via cloud-init (ssh_authorized_keys)."
}

variable "oci_tenancy_id" {
  type = string
}

variable "oci_compartment_id" {
  type = string
}

variable "oci_region" {
  type        = string
  description = "OCI region where the Omni edge location is created."
}

variable "oci_home_region" {
  type        = string
  description = "OCI home region for IAM resources."
}
