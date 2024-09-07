variable "environment" {
  description = "L'environnement pour les ressources"
  type        = string
  default     = "dev"
}

variable "cidr_vpc" {
  description = "CIDR du VPC"
  default     = "10.1.0.0/16"
}

variable "cidr_public_subnet_a" {
  description = "CIDR du Sous-réseau public A"
  default     = "10.1.0.0/24"
}

variable "cidr_public_subnet_b" {
  description = "CIDR du Sous-réseau public B"
  default     = "10.1.1.0/24"
}

variable "cidr_app_subnet_a" {
  description = "CIDR du Sous-réseau privé A"
  default     = "10.1.2.0/24"
}

variable "cidr_app_subnet_b" {
  description = "CIDR du Sous-réseau privé B"
  default     = "10.1.3.0/24"
}

variable "az_a" {
  description = "Zone de disponibilité A"
  default     = "eu-west-3a"
}

variable "az_b" {
  description = "Zone de disponibilité B"
  default     = "eu-west-3b"
}
