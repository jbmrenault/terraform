terraform {
  backend "s3" {
    bucket = "jbm-tfstate"
    key    = "vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}
