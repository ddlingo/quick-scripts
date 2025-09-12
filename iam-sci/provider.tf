provider "openstack" {
  cloud  = var.os_cloud_name   # Example: "sci-dev" (must match your clouds.yaml entry)
  region = var.os_region_name  # Example: "eu-de-1"
}
