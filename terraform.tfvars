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
environment            = "training"
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
