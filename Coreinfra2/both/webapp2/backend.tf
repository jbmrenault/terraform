terraform {
  backend "s3" {
    bucket = "jbm-tfstate"
    key    = "webapp2/terraform.tfstate"
    region = "eu-west-1"
  }
}
