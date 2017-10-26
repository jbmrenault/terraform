terraform {
  backend "s3" {
    bucket = "jbm-tfstate"
    key    = "webapp1/terraform.tfstate"
    region = "eu-west-1"
  }
}
