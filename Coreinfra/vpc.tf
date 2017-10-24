resource "aws_vpc" "mainjbm" {
  cidr_block       = "172.23.0.0/16"
  instance_tenancy = "dedicated"

  tags {
    Name = "mainjbm"
  }
}
