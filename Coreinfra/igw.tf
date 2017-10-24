resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.mainjbm.id}"

  tags {
    Name = "mainjbm"
  }
}
