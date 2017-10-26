output "vpc_id" {
  value = "${aws_vpc.aws_jbmtest.id}"
}

output "subnet1" {
  value = "${aws_subnet.pubnet1.id}"
}

output "subnet2" {
  value = "${aws_subnet.pubnet2.id}"
}

output "sgjbm" {
  value = "${aws_security_group.allow_http.id}"
}
