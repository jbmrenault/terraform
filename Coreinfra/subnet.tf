resource "aws_subnet" "mainjbm" {
  vpc_id     = "${aws_vpc.mainjbm.id}"
  cidr_block = "172.23.1.0/24"

  tags {
    Name = "Mainjbm"
  }
}

resource "aws_subnet" "mainjbm2" {
  vpc_id                  = "${aws_vpc.mainjbm.id}"
  cidr_block              = "172.23.2.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "Mainjbm2"
  }
}
