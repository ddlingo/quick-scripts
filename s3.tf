terraform {
  backend "s3" {
    bucket                      = "sms-c12345"
    key                         = "layer-00.tfstate"
    region                      = "eu-de-1"
    encrypt                     = false
    skip_region_validation      = true
    skip_credentials_validation = true
    endpoint                    = "https://s3.eu-de-1.vexxhost.net"
    force_path_style            = true
    profile                     = "sci-monsoon3"
  }
}
