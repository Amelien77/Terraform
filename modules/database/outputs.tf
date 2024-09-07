# Output de l'endpoint de la base de données
output "db_endpoint" {
  description = "L'endpoint de la base de données"
  value       = aws_db_instance.wordpress_db.endpoint
}

# Output de l'ID de l'instance de base de données
output "db_instance_id" {
  description = "L'ID de l'instance de base de données"
  value       = aws_db_instance.wordpress_db.id
}

# Output du nom du groupe de sous-réseaux
output "db_subnet_group_name" {
  description = "Le nom du groupe de sous-réseaux pour la base de données"
  value       = aws_db_subnet_group.db_subnet.name
}

# Output de l'ID du groupe de sécurité de la base de données
output "db_sg_id" {
  description = "L'ID du groupe de sécurité de la base de données"
  value       = aws_security_group.db_sg.id
}
