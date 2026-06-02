# terraform-castai-omni-edge-location-oci

Terraform module for creating CAST AI edge locations on Oracle Cloud Infrastructure (OCI).

## Breaking changes in v2

v2 is not backwards compatible with v1. Upgrading requires destroying the v1 edge location and creating a new one with v2.

Both versions can run simultaneously. During migration, create counterpart v2 edge locations first, then remove v1 once they are no longer in use.

**Note:**
- creating new **v1 edge locations will no longer be supported.**

### Running v1 and v2 simultaneously

Pin existing edge locations to v1 while creating new ones with v2:

```hcl
# Keep existing edge location on v1
module "castai_oci_edge_location_existing" {
  source  = "castai/omni-edge-location-oci/castai"
  version = "~> 1.0"

  cluster_id      = var.cluster_id
  organization_id = var.organization_id

  region     = "us-ashburn-1"
  tenancy_id = var.oci_tenancy_id
  compartment_id = var.oci_compartment_id
}

# New edge location on v2
module "castai_oci_edge_location_new" {
  source = "castai/omni-edge-location-oci/castai"
  version = "~> 2.0"

  providers = {
    oci      = oci
    oci.home = oci.home
  }

  region     = "us-ashburn-1"
  tenancy_id = var.oci_tenancy_id
  compartment_id = var.oci_compartment_id
}
```

## Usage

> **Warning**
> This module expects the cluster to be onboarded to CAST AI with OMNI enabled.

### Basic Example

This module requires two OCI provider configurations:
  - `oci` for the target region (the region where the Omni edge location is created).
  - `oci.home` for the home region (as IAM resources need to be created in the IAM home region).

```hcl
provider "oci" {
  region = "us-ashburn-1" # the region where the Omni edge location is created
}

provider "oci" {
  alias  = "home"
  region = "eu-paris-1" # set to your tenancy's home region
}

module "castai_oci_edge_location" {
  source  = "castai/omni-edge-location-oci/castai"
  version = "~> 2.0"

  providers = {
    oci      = oci
    oci.home = oci.home
  }

  cluster_id      = var.cluster_id
  organization_id = var.organization_id
  region          = "us-ashburn-1"
  tenancy_id      = var.tenancy_ocid

  tags = {
    ManagedBy = "terraform"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_castai"></a> [castai](#requirement\_castai) | >= 8.39.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [castai_edge_configuration.this](https://registry.terraform.io/providers/castai/castai/latest/docs/resources/edge_configuration) | resource |
| [castai_edge_configuration_default.this](https://registry.terraform.io/providers/castai/castai/latest/docs/resources/edge_configuration_default) | resource |
| [castai_edge_location.this](https://registry.terraform.io/providers/castai/castai/latest/docs/resources/edge_location) | resource |
| [null_resource.validate_region](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [oci_core_nat_gateway.main](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_nat_gateway) | resource |
| [oci_core_network_security_group.main](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group_security_rule.egress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.ingress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_route_table.nat](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_subnet.main](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.main](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn) | resource |
| [oci_identity_api_key.castai](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_api_key) | resource |
| [oci_identity_group.castai](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_group) | resource |
| [oci_identity_policy.castai](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_user.castai](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_user) | resource |
| [oci_identity_user_group_membership.castai](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_user_group_membership) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [tls_private_key.castai_api_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [oci_identity_availability_domains.ads](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | CAST AI cluster ID | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCI compartment OCID where resources will be created. If not provided, uses tenancy root compartment | `string` | `null` | no |
| <a name="input_control_plane"></a> [control\_plane](#input\_control\_plane) | Edge location control plane configuration.<br/>- ha (bool): enable high availability mode for the Edge location control plane (default: true) | <pre>object({<br/>    ha = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_default_edge_configuration_name"></a> [default\_edge\_configuration\_name](#input\_default\_edge\_configuration\_name) | Name of the default edge configuration | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the edge location | `string` | `null` | no |
| <a name="input_edge_configurations"></a> [edge\_configurations](#input\_edge\_configurations) | Map of OCI edge configurations to create for this edge location.<br/><br/>Each configuration supports the following attributes:<br/>- name (string, required): Name of the edge configuration.<br/>- image\_id (string, optional): OCI image OCID or display name for edge instances (e.g., "Oracle-Linux-9" or "ocid1.image.oc1..xxxxxxxxx").<br/>- boot\_disk\_size\_gib (number, optional): Boot disk size in GiB.<br/>- user\_data\_base64 (string, optional): Base64 encoded user data to run on the edge as part of bootstrap. The payload must start with either `#cloud-config` (cloud-init YAML) or `#!` (shell script with a shebang).<br/>- tags (map(string), optional): Tags to apply to edge instances created with this configuration.<br/>- cri (map(string), optional): Container runtime interface configuration. Defaults to `{}`.<br/><br/>Example:<br/>edge\_configurations = {<br/>  "default" = {<br/>    image\_id = "Oracle-Linux-9"<br/>    tags = {<br/>      environment = "production"<br/>    }<br/>  }<br/>  "gpu" = {<br/>    image\_id           = "ocid1.image.oc1.iad.example"<br/>    boot\_disk\_size\_gib = 200<br/>    tags = {<br/>      workload = "gpu"<br/>    }<br/>  }<br/>} | <pre>map(object({<br/>    name               = string<br/>    image_id           = optional(string)<br/>    boot_disk_size_gib = optional(number)<br/>    user_data_base64   = optional(string)<br/>    cri                = optional(map(string), {})<br/>    tags               = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the edge location. If not provided, will be auto-generated | `string` | `null` | no |
| <a name="input_networking"></a> [networking](#input\_networking) | Edge cluster networking configuration.<br/>- tunneled\_cidrs (list(string)): list of destination CIDR blocks whose traffic should be routed through the main cluster instead of directly from the edge cluster. | <pre>object({<br/>    tunneled_cidrs = optional(list(string))<br/>  })</pre> | `null` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | CAST AI organization ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | OCI region (must match OCI provider configuration) | `string` | n/a | yes |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | CIDR block for the subnet | `string` | `"10.0.0.0/24"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Freeform tags to apply to OCI resources | `map(string)` | `{}` | no |
| <a name="input_tenancy_id"></a> [tenancy\_id](#input\_tenancy\_id) | OCI tenancy OCID. Should match the OCI provider configuration. | `string` | n/a | yes |
| <a name="input_vcn_cidr"></a> [vcn\_cidr](#input\_vcn\_cidr) | CIDR block for the VCN | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_edge_configuration_ids"></a> [edge\_configuration\_ids](#output\_edge\_configuration\_ids) | Map of edge configuration IDs by configuration key |
| <a name="output_edge_location_id"></a> [edge\_location\_id](#output\_edge\_location\_id) | CAST AI edge location ID |
| <a name="output_edge_location_name"></a> [edge\_location\_name](#output\_edge\_location\_name) | CAST AI edge location name |
| <a name="output_oci_resources"></a> [oci\_resources](#output\_oci\_resources) | OCI resources created for the edge location |
<!-- END_TF_DOCS -->

## License

MIT