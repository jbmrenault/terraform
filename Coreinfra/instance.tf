provider "aws" {
  region = "eu-west-1"
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
