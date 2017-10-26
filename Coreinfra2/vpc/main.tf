resource "aws_vpc" "aws_jbmtest" {
  cidr_block = "${var.vpccidr}"

  tags {
    Name = "vpcjbm"
  }
}

resource "aws_internet_gateway" "gateway_jbmtest" {
  vpc_id = "${aws_vpc.aws_jbmtest.id}"
}

resource "aws_route_table" "route_internet" {
  vpc_id = "${aws_vpc.aws_jbmtest.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway_jbmtest.id}"
  }
}

resource "aws_route_table_association" "route_subnet1" {
  subnet_id      = "${aws_subnet.pubnet1.id}"
  route_table_id = "${aws_route_table.route_internet.id}"
}

resource "aws_subnet" "pubnet1" {
  vpc_id            = "${aws_vpc.aws_jbmtest.id}"
  cidr_block        = "${var.subnet1}"
  availability_zone = "eu-west-1a"
}

resource "aws_route_table_association" "route_subnet2" {
  subnet_id      = "${aws_subnet.pubnet2.id}"
  route_table_id = "${aws_route_table.route_internet.id}"
}

resource "aws_subnet" "pubnet2" {
  vpc_id            = "${aws_vpc.aws_jbmtest.id}"
  cidr_block        = "${var.subnet2}"
  availability_zone = "eu-west-1b"
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow all http traffic"
  vpc_id      = "${aws_vpc.aws_jbmtest.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
