provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "aws_jbmtest" {
  cidr_block = "172.23.0.0/16"

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
  cidr_block        = "172.23.1.0/24"
  availability_zone = "eu-west-1a"
}

resource "aws_route_table_association" "route_subnet2" {
  subnet_id      = "${aws_subnet.pubnet2.id}"
  route_table_id = "${aws_route_table.route_internet.id}"
}

resource "aws_subnet" "pubnet2" {
  vpc_id            = "${aws_vpc.aws_jbmtest.id}"
  cidr_block        = "172.23.2.0/24"
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

# ami ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "userdatajbm" {
  template = "${file("${path.module}/userdata.tpl")}"

  vars {
    username = "jbm"
  }
}

################ instance
resource "aws_instance" "web" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.pubnet1.id}"
  associate_public_ip_address = true
  user_data                   = "${data.template_file.userdatajbm.rendered} "
  key_name                    = "JBM"
  vpc_security_group_ids      = ["${aws_security_group.allow_http.id}"]

  tags {
    Name = "helloword"
  }
}

###################"
output "webinstance_publique_ip" {
  value = "${aws_instance.web.public_ip}"
}
