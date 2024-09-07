variable "db_username" {
  description = "Nom d'utilisateur pour la base de données"
  type        = string
}

variable "db_password" {
  description = "Mot de passe pour la base de données"
  type        = string
  sensitive   = true
}

variable "allowed_ssh_ips" {
  description = "Les adresses IP autorisées pour l'accès SSH au bastion"
  type        = list(string)
  default     = ["34.241.31.66/32"]  # Replace with your actual IP address
}
