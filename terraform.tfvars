account_id  = "753386176131"
build_user  = "C5401446"

business = {
  name      = "sms"
  formatted = "SMS"
  friendly  = "Shared Management Services"
}

customer = {
  name = "build-sms"
}

include_customer_label = true
environment           = "training"

organization = {
  name      = "sap"
  formatted = "SAP"
  friendly  = "SAP"
}

label_order = [
  "security_boundary",
  "business"
]

owner       = "deadri.lingo@sap.com"
partition   = "aws"
region      = "us-east-2"
root_module = "training-module"

security_boundary = {
  name      = "dev"
  formatted = "Dev"
  friendly  = "Development"
}

# Existing networking variables
network_name    = "my-vpc"
subnet_name     = "my-subnet"
cidr            = "10.0.0.0/24"
gateway_ip      = "10.0.0.1"
dns_nameservers = ["8.8.8.8", "8.8.4.4"]
