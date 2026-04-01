variable "castai_api_token" {
  type      = string
  sensitive = true
}

variable "castai_api_url" {
  type    = string
  default = "https://api.cast.ai"
}

variable "gke_cluster_name" {
  type = string
}

variable "gke_cluster_region" {
  type = string
}

variable "google_project_id" {
  type = string
}

variable "oci_tenancy_id" {
  type = string
}

variable "oci_compartment_id" {
  type = string
}

variable "oci_region" {
  type = string
  description = "OCI region where the Omni edge location is created."
}

variable "oci_home_region" {
  type        = string
  description = "OCI home region for IAM resources."
}
