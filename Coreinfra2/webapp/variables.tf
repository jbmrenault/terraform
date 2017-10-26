variable "region" {
  type = "string"

  default = "eu-west-1"
}

variable "keyname" {
  type    = "string"
  default = "JBM"
}

data "terraform_remote_state" "rs_vpc" {
  backend = "s3"

  config {
    bucket = "jbm-tfstate"
    key    = "vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}
