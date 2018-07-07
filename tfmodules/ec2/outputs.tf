output "ec2_id" {
  value = "${aws_instance.ec2_demo.id}"
}

output "security_group_id" {
  value = "${aws_security_group.my_sg.id}"
}
