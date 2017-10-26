output "vpc_id" {
  value = "${data.terraform_remote_state.rs_vpc.vpc_id}"
}

output "subnet1" {
  value = "${data.terraform_remote_state.rs_vpc.subnet1}"
}

output "subnet2" {
  value = "${data.terraform_remote_state.rs_vpc.subnet2}"
}

output "webinstance_publique_ip" {
  value = "${aws_instance.web.public_ip}"
}
