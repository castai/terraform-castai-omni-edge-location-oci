terraform {
  required_version = ">= 1.9.0"

  required_providers {
    castai = {
      source  = "castai/castai"
      version = ">= 9.6.3"
    }
    oci = {
      source  = "oracle/oci"
      version = ">= 4.0"
    }
  }
}

provider "oci" {
  region = var.region
}

provider "oci" {
  alias  = "home"
  region = var.oci_home_region
}

provider "castai" {
  api_token = var.castai_api_token
  api_url   = var.castai_api_url
}
