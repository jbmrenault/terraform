resource "aws_subnet" "mainjbm" {
  vpc_id     = "vpc-e11fc699"
  cidr_block = "172.23.1.0/24"

  tags {
    Name = "Mainjbm"
  }
}
