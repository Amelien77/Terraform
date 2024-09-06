variable "db_username" {
  description = "Nom d'utilisateur pour la base de données"
  type        = string
}

variable "db_password" {
  description = "Mot de passe pour la base de données"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "L'ID du VPC"
  type        = string
}

variable "private_subnets" {
  description = "Liste des sous-réseaux privés"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDR des sous-réseaux où les instances WordPress résident"
  type        = list(string)
}
