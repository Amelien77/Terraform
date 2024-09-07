#------------------Variables pour main.tf bastion--------------------#


variable "vpc_id" {
  description = "L'ID du VPC où le Bastion sera créé"
  type        = string
}

variable "public_subnets" {
  description = "Liste des sous-réseaux publics pour le Bastion"
  type        = list(string)
}

variable "allowed_ssh_ips" {
  description = "Liste des adresses IP autorisées pour accéder au Bastion via SSH"
  type        = list(string)
}
