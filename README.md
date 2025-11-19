# terraform-castai-omni-edge-location

Terraform module for creating CAST AI edge locations across multiple cloud providers (AWS, GCP, OCI).

## Usage

> **Warning**
> This module expects the cluster to be onboarded to CAST AI with OMNI enabled.

### AWS Edge Location



```hcl
module "castai_aws_edge_location" {
  source = "github.com/castai/terraform-castai-omni-edge-location"

  cluster_id      = var.cluster_id
  organization_id = var.organization_id

  aws = {
    region = "us-east-1"
  }

  tags = {
    ManagedBy = "terraform"
  }
}
```

### GCP Edge Location

> **Note:** The GCP provider must be configured with the target project before using this module.

```hcl
provider "google" {
  project = "my-gcp-project"
  region  = "europe-west4"
}

module "castai_gcp_edge_location" {
  source = "github.com/castai/terraform-castai-omni-edge-location"

  cluster_id      = var.cluster_id
  organization_id = var.organization_id

  gcp = {
    region = "europe-west4"
  }

  tags = {
    ManagedBy = "terraform"
  }
}
```

### OCI Edge Location

```hcl
module "castai_oci_edge_location" {
  source = "github.com/castai/terraform-castai-omni-edge-location"

  cluster_id      = var.cluster_id
  organization_id = var.organization_id

  oci = {
    region     = "us-ashburn-1"
    tenancy_id = var.oci_tenancy_id
  }

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
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_castai"></a> [castai](#provider\_castai) | 8.1.1 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_resources"></a> [aws\_resources](#module\_aws\_resources) | ./modules/aws | n/a |
| <a name="module_gcp_resources"></a> [gcp\_resources](#module\_gcp\_resources) | ./modules/gcp | n/a |
| <a name="module_oci_resources"></a> [oci\_resources](#module\_oci\_resources) | ./modules/oci | n/a |

## Resources

| Name | Type |
|------|------|
| [castai_edge_location.this](https://registry.terraform.io/providers/castai/castai/latest/docs/resources/edge_location) | resource |
| [null_resource.validate_cloud_provider](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws"></a> [aws](#input\_aws) | AWS cloud configuration. Only one of aws, gcp, or oci should be provided. All cloud resources will be created by the module. | <pre>object({<br/>    region = string # AWS region (must match AWS provider config)<br/>  })</pre> | `null` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | CAST AI cluster ID | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the edge location. If not provided, will be auto-generated based on cloud provider | `string` | `null` | no |
| <a name="input_gcp"></a> [gcp](#input\_gcp) | GCP cloud configuration. Only one of aws, gcp, or oci should be provided. All cloud resources will be created by the module. | <pre>object({<br/>    region = string<br/>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the edge location. If not provided, will be auto-generated | `string` | `null` | no |
| <a name="input_oci"></a> [oci](#input\_oci) | OCI cloud configuration. Only one of aws, gcp, or oci should be provided. All cloud resources will be created by the module. | <pre>object({<br/>    region         = string           # OCI region (must match OCI provider config)<br/>    tenancy_id     = string           # OCI tenancy OCID (must match OCI provider config)<br/>    compartment_id = optional(string) # Optional: OCI compartment OCID. If not provided, uses tenancy root compartment<br/>  })</pre> | `null` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | CAST AI organization ID | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_resources"></a> [aws\_resources](#output\_aws\_resources) | AWS resources created (if applicable) |
| <a name="output_cloud_provider"></a> [cloud\_provider](#output\_cloud\_provider) | Cloud provider used (aws, gcp, or oci) |
| <a name="output_edge_location_id"></a> [edge\_location\_id](#output\_edge\_location\_id) | ID of the created edge location |
| <a name="output_edge_location_name"></a> [edge\_location\_name](#output\_edge\_location\_name) | Name of the created edge location |
| <a name="output_gcp_resources"></a> [gcp\_resources](#output\_gcp\_resources) | GCP resources created (if applicable) |
| <a name="output_oci_resources"></a> [oci\_resources](#output\_oci\_resources) | OCI resources created (if applicable) |
| <a name="output_region"></a> [region](#output\_region) | Region of the edge location |
<!-- END_TF_DOCS -->

## License

MIT