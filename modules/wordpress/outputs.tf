output "wordpress_asg_id" {
  description = "ID de l'Auto Scaling Group pour WordPress"
  value       = aws_autoscaling_group.wordpress_asg.id
}

output "wordpress_sg_id" {
  description = "ID du groupe de sécurité pour WordPress"
  value       = aws_security_group.wordpress_sg.id
}

output "launch_configuration_id" {
  value = aws_launch_configuration.wordpress_lc.id
}
