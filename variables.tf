#--------------------------Crédentials database-------------------------#

variable "db_username" {
  description = "Nom d'utilisateur pour la base de données"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Mot de passe pour la base de données"
  type        = string
  sensitive   = true
}


#-------------------------Crédentials AWS CLI-----------------------------#

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

#------------------------Adresse IP pour bastion----------------------------#

variable "allowed_ssh_ips" {
  description = "Les adresses IP autorisées pour l'accès SSH au bastion"
  type        = list(string)
  default     = ["34.241.31.66/32"]
}
