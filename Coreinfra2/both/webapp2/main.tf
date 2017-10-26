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
#resource "aws_instance" "web" {
#  ami                         = "${data.aws_ami.ubuntu.id}"
#  instance_type               = "t2.micro"
#  subnet_id                   = "${data.terraform_remote_state.rs_vpc.subnet1}"
#  associate_public_ip_address = true
#  user_data                   = "${data.template_file.userdatajbm.rendered} "
#  key_name                    = "${var.keyname}"
#  vpc_security_group_ids      = ["${data.terraform_remote_state.rs_vpc.sgjbm}"]
#
#  tags {
#    Name = "helloword"
#  }
#}

resource "aws_elb" "elbjbm" {
  name            = "terraform-elbjbm"
  subnets         = ["${data.terraform_remote_state.rs_vpc.subnet1}"]
  security_groups = ["${data.terraform_remote_state.rs_vpc.sgjbm}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    target              = "HTTP:80/"
    interval            = 5
  }
}

resource "aws_launch_configuration" "launch_cfg_jbm" {
  name_prefix     = "lcjbm"
  image_id        = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  security_groups = ["${data.terraform_remote_state.rs_vpc.sgjbm}"]
  key_name        = "JBM"
  user_data       = "${data.template_file.userdatajbm.rendered}"

  lifecycle {
    create_before_destroy = "true"
  }
}

resource "aws_autoscaling_group" "autosc_g_jbm" {
  vpc_zone_identifier       = ["${data.terraform_remote_state.rs_vpc.subnet1}"]
  name                      = "asg-${aws_launch_configuration.launch_cfg_jbm.name}"
  max_size                  = 20
  min_size                  = 10
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.launch_cfg_jbm.name}"
  load_balancers            = ["${aws_elb.elbjbm.id}"]

  tags = [
    {
      key                 = "Name"
      value               = "autoscaledserver_by_jbm"
      propagate_at_launch = true
    },
  ]

  lifecycle {
    create_before_destroy = "true"
  }
}
