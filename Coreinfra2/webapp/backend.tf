terraform {
  backend "s3" {
    bucket = "jbm-tfstate"
    key    = "webapp/terraform.tfstate"
    region = "eu-west-1"
  }
}
