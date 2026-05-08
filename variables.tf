variable "name" {
  type        = string
  description = "Name for the edge location. If not provided, will be auto-generated"
  default     = null
}

variable "cluster_id" {
  type        = string
  description = "CAST AI cluster ID"
}

variable "organization_id" {
  type        = string
  description = "CAST AI organization ID"
}

variable "description" {
  type        = string
  description = "Description of the edge location"
  default     = null
}

variable "region" {
  description = "OCI region (must match OCI provider configuration)"
  type        = string
}

variable "tenancy_id" {
  description = "OCI tenancy OCID. Should match the OCI provider configuration."
  type        = string
}

variable "compartment_id" {
  description = "OCI compartment OCID where resources will be created. If not provided, uses tenancy root compartment"
  type        = string
  default     = null
}

variable "vcn_cidr" {
  description = "CIDR block for the VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "tags" {
  description = "Freeform tags to apply to OCI resources"
  type        = map(string)
  default     = {}
}

variable "control_plane" {
  description = <<-EOT
    Edge location control plane configuration.
    - ha (bool): enable high availability mode for the Edge location control plane (default: true)
  EOT
  type = object({
    ha = optional(bool, true)
  })
  default = {}
}

variable "networking" {
  description = <<-EOT
    Edge cluster networking configuration.
    - tunneled_cidrs (list(string)): list of destination CIDR blocks whose traffic should be routed through the main cluster instead of directly from the edge cluster.
  EOT
  type = object({
    tunneled_cidrs = optional(list(string))
  })
  default = null
}
