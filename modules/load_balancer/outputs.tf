output "alb_arn" {
  description = "L'ARN du Load Balancer"
  value       = aws_lb.wordpress_alb.arn
}

output "alb_sg_id" {
  description = "L'ID du groupe de sécurité du Load Balancer"
  value       = aws_security_group.alb_sg.id
}

output "wordpress_tg_arn" {
  description = "L'ARN du groupe cible"
  value       = aws_lb_target_group.wordpress_tg.arn
}

output "http_listener_arn" {
  description = "L'ARN du listener HTTP"
  value       = aws_lb_listener.http_listener.arn
}

output "https_listener_arn" {
  description = "L'ARN du listener HTTPS"
  value       = aws_lb_listener.https_listener.arn
}
