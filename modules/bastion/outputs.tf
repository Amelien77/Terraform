output "bastion_asg_id" {
  description = "ID de l'Auto Scaling Group pour le Bastion"
  value       = aws_autoscaling_group.bastion_asg.id
}

output "bastion_sg_id" {
  description = "ID du groupe de sécurité pour le Bastion"
  value       = aws_security_group.bastion_sg.id
}

output "bastion_lc_id" {
  description = "ID de la configuration de lancement pour le Bastion"
  value       = aws_launch_configuration.bastion_lc.id
}

output "bastion_instance_id" {
  description = "ID de l'instance Bastion"
  value       = aws_instance.bastion.id
}
