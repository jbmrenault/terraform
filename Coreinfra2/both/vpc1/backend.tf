terraform {
  backend "s3" {
    bucket = "jbm-tfstate"
    key    = "vpc1/terraform.tfstate"
    region = "eu-west-1"
  }
}
