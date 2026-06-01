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

variable "edge_configurations" {
  description = <<-EOT
    Map of OCI edge configurations to create for this edge location.

    Each configuration supports the following attributes:
    - name (string, required): Name of the edge configuration.
    - image_id (string, optional): OCI image OCID or display name for edge instances (e.g., "Oracle-Linux-9" or "ocid1.image.oc1..xxxxxxxxx").
    - boot_disk_size_gib (number, optional): Boot disk size in GiB.
    - user_data_base64 (string, optional): Base64 encoded user data to run on the edge as part of bootstrap. The payload must start with either `#cloud-config` (cloud-init YAML) or `#!` (shell script with a shebang).
    - tags (map(string), optional): Tags to apply to edge instances created with this configuration.
    - cri (map(string), optional): Container runtime interface configuration. Defaults to `{}`.

    Example:
    edge_configurations = {
      "default" = {
        image_id = "Oracle-Linux-9"
        tags = {
          environment = "production"
        }
      }
      "gpu" = {
        image_id           = "ocid1.image.oc1.iad.example"
        boot_disk_size_gib = 200
        tags = {
          workload = "gpu"
        }
      }
    }
  EOT
  type = map(object({
    name               = string
    image_id           = optional(string)
    boot_disk_size_gib = optional(number)
    user_data_base64   = optional(string)
    cri                = optional(map(string), {})
    tags               = optional(map(string), {})
  }))
  default = {}
}

variable "default_edge_configuration_name" {
  type        = string
  description = "Name of the default edge configuration"
  default     = ""
}
