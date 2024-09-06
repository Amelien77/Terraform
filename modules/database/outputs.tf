output "db_endpoint" {
  description = "L'endpoint de la base de données"
  value       = aws_db_instance.wordpress_db.endpoint
}
