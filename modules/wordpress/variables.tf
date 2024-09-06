variable "vpc_id" {
  description = "ID du VPC"
  type        = string
}

variable "private_subnets" {
  description = "Liste des sous-réseaux privés"
  type        = list(string)
}
