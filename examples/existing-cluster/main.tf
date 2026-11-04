module "castai_oci_edge_location" {
  source = "../.."

  providers = {
    oci      = oci
    oci.home = oci.home
  }

  cluster_id      = var.cluster_id
  organization_id = var.organization_id

  # OCI region (validated against the OCI provider's configured region) and the
  # tenancy/compartment that will own the edge location resources.
  region         = var.region
  tenancy_id     = var.tenancy_id
  compartment_id = var.compartment_id

  name          = var.name
  description   = var.description
  control_plane = var.control_plane
  liqo          = var.liqo
}
