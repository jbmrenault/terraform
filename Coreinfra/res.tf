resource "aws_vpc" "mainjbm" {
  cidr_block       = "172.23.0.0/16"
  instance_tenancy = "dedicated"

  tags {
    Name = "mainjbm"
  }
}
resource "aws_subnet" "mainjbm" {
  vpc_id                  = "${aws_vpc.mainjbm.id}"
  cidr_block              = "172.23.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags {
    Name = "Mainjbm"
  }
}

resource "aws_subnet" "mainjbm2" {
  vpc_id     = "${aws_vpc.mainjbm.id}"
  cidr_block = "172.23.2.0/24"

  tags {
    Name = "Mainjbm2"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.mainjbm.id}"

  tags {
    Name = "mainjbm"
  }
}
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
provider "aws" {
  region = "us-east-1"
}

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

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.mainjbm.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "JBMSCRIPT" {
  template = "${file("${path.module}/userdata.tpl")}"
}

output "subid" {
  value = "${aws_subnet.mainjbm.id}"
}

resource "aws_network_interface" "interfacejbm" {
  subnet_id = "${aws_subnet.mainjbm.id}"

  tags {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name      = "JBM"

  network_interface {
    network_interface_id = "${aws_network_interface.interfacejbm.id}"
    device_index         = 0
  }

  #subnet_id = "${aws_subnet.mainjbm.id}"
  user_data = "${data.template_file.JBMSCRIPT.rendered}"

  tags {
    Name = "HelloWorldJBM"
  }
}

output "public_ip" {
  value = "${aws_instance.web.public_ip}"
}
