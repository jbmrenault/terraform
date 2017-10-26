variable "region" {
  type = "string"

  default = "eu-west-1"
}

variable "subnet1" {
  type = "string"

  default = "172.23.5.0/24"
}

variable "subnet2" {
  type = "string"

  default = "172.23.2.0/24"
}

variable "vpccidr" {
  type    = "string"
  default = "172.23.0.0/16"
}
