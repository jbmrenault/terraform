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
  subnet_id                   = "${data.terraform_remote_state.rs_vpc.subnet1}"
  associate_public_ip_address = true
  user_data                   = "${data.template_file.userdatajbm.rendered} "
  key_name                    = "${var.keyname}"
  vpc_security_group_ids      = ["${data.terraform_remote_state.rs_vpc.sgjbm}"]

  tags {
    Name = "helloword"
  }
}
