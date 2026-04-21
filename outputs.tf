output "edge_location_id" {
  description = "CAST AI edge location ID"
  value       = castai_edge_location.this.id
}

output "edge_location_name" {
  description = "CAST AI edge location name"
  value       = castai_edge_location.this.name
}

output "oci_resources" {
  description = "OCI resources created for the edge location"
  value = {
    tenancy_id        = local.tenancy_id
    compartment_id    = local.compartment_id
    vcn_id            = oci_core_vcn.main.id
    subnet_id         = oci_core_subnet.main.id
    nat_gateway_id    = oci_core_nat_gateway.main.id
    security_group_id = oci_core_network_security_group.main.id
  }
}
