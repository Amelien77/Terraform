variable "vpc_id" {
  description = "ID du VPC"
  type        = string
}

variable "private_subnets" {
  description = "Liste des sous-réseaux privés"
  type        = list(string)
}

variable "ami_id" {
  description = "ID de l'AMI Ubuntu à utiliser pour les instances WordPress"
  type        = string
  default     = "" 
}

variable "instance_type" {
  description = "Type d'instance EC2 pour les instances WordPress"
  type        = string
  default     = "t2.micro"
}

variable "launch_configuration_name" {
  description = "Nom de la configuration de lancement pour les instances WordPress"
  type        = string
  default     = "wordpress_lc"
}

variable "asg_min_size" {
  description = "Taille minimale de l'Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Taille maximale de l'Auto Scaling Group"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default     = {
    Name        = "wordpress-instance"
    Environment = "dev"
  }
}
