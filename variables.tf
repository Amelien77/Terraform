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
  default     = ["YOUR_IP_ADDRESS/32"]  # Remplacez par votre adresse IP
}
