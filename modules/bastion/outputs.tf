output "bastion_asg_id" {
  value = aws_autoscaling_group.bastion_asg.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}
