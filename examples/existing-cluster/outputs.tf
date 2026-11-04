output "edge_location_id" {
  description = "CAST AI edge location ID"
  value       = module.castai_oci_edge_location.edge_location_id
}

output "edge_location_name" {
  description = "CAST AI edge location name"
  value       = module.castai_oci_edge_location.edge_location_name
}

output "oci_resources" {
  description = "OCI resources created for the edge location"
  value       = module.castai_oci_edge_location.oci_resources
}
