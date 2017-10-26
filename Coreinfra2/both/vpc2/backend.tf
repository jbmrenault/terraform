terraform {
  backend "s3" {
    bucket = "jbm-tfstate"
    key    = "vpc2/terraform.tfstate"
    region = "eu-west-1"
  }
}
