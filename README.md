# terraform-castai-omni-edge-location-oci

Terraform module for creating CAST AI edge locations on Oracle Cloud Infrastructure (OCI).

## Usage

> **Warning**
> This module expects the cluster to be onboarded to CAST AI with OMNI enabled.

### Basic Example

> **Note:** The OCI provider must be configured with your region and credentials before using this module.

```hcl
module "castai_oci_edge_location" {
  source  = "castai/omni-edge-location-oci/castai"
  version = "~> 1.0"

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
| <a name="requirement_castai"></a> [castai](#requirement\_castai) | >= 8.1.1 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_castai"></a> [castai](#provider\_castai) | >= 8.1.1 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_oci"></a> [oci](#provider\_oci) | >= 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [castai_edge_location.this](https://registry.terraform.io/providers/castai/castai/latest/docs/resources/edge_location) | resource |
| [null_resource.validate_region](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [oci_core_default_route_table.main](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_default_route_table) | resource |
| [oci_core_internet_gateway.main](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_security_list.main](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
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
| <a name="input_description"></a> [description](#input\_description) | Description of the edge location | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the edge location. If not provided, will be auto-generated | `string` | `null` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | CAST AI organization ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | OCI region (must match OCI provider configuration) | `string` | n/a | yes |
| <a name="input_security_list_source_cidr"></a> [security\_list\_source\_cidr](#input\_security\_list\_source\_cidr) | Source CIDR for security list ingress rules | `string` | `"0.0.0.0/0"` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | CIDR block for the subnet | `string` | `"10.0.0.0/24"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Freeform tags to apply to OCI resources | `map(string)` | `{}` | no |
| <a name="input_tenancy_id"></a> [tenancy\_id](#input\_tenancy\_id) | OCI tenancy OCID. Should match the OCI provider configuration. | `string` | n/a | yes |
| <a name="input_vcn_cidr"></a> [vcn\_cidr](#input\_vcn\_cidr) | CIDR block for the VCN | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_edge_location_id"></a> [edge\_location\_id](#output\_edge\_location\_id) | CAST AI edge location ID |
| <a name="output_edge_location_name"></a> [edge\_location\_name](#output\_edge\_location\_name) | CAST AI edge location name |
| <a name="output_oci_resources"></a> [oci\_resources](#output\_oci\_resources) | OCI resources created for the edge location |
<!-- END_TF_DOCS -->

## License

MIT