variable "vpc_id" {
  description = "L'ID du VPC"
  type        = string
}

variable "public_subnets" {
  description = "Liste des sous-réseaux publics pour le Load Balancer"
  type        = list(string)
}

variable "route53_zone_id" {
  description = "ID de la zone Route 53 pour la validation du certificat SSL"
  type        = string
}
