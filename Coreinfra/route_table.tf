resource "aws_route_table" "r_jbm" {
  vpc_id = "${aws_vpc.mainjbm.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "mainjbm"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.mainjbm.id}"
  route_table_id = "${aws_route_table.r_jbm.id}"
}
