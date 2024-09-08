output "alb_id" {
  description = "ID du Load Balancer"
  value       = aws_lb.wordpress_alb.id
}

output "asg_id" {
  description = "ID du groupe de mise à l'échelle automatique"
  value       = aws_autoscaling_group.wordpress_asg.id
}

output "launch_configuration_id" {
  description = "ID de la configuration de lancement"
  value       = aws_launch_configuration.wordpress_lc.id
}

output "alb_security_group_id" {
  description = "ID du groupe de sécurité pour l'ALB"
  value       = aws_security_group.alb_sg.id
}

output "wordpress_security_group_id" {
  description = "ID du groupe de sécurité pour WordPress"
  value       = aws_security_group.wordpress_sg.id
}

output "target_group_arn" {
  description = "ARN du groupe cible"
  value       = aws_lb_target_group.wordpress_tg.arn
}

output "http_listener_arn" {
  description = "ARN du listener HTTP"
  value       = aws_lb_listener.http_listener.arn
}

output "https_listener_arn" {
  description = "ARN du listener HTTPS"
  value       = aws_lb_listener.https_listener.arn
}

output "wordpress_asg_id" {
  description = "ID du groupe de mise à l'échelle automatique WordPress"
  value       = aws_autoscaling_group.wordpress_asg.id
}
