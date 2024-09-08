#------------------Variables pour main.tf bastion--------------------#


variable "vpc_id" {
  description = "ID du VPC"
  type        = string
}

variable "public_subnets" {
  description = "Liste des sous-réseaux publics"
  type        = list(string)
}

variable "subnet_id" {
  description = "ID du sous-réseau dans lequel déployer le Bastion"
  type        = string
}

variable "allowed_ssh_ips" {
  description = "Liste des adresses IP autorisées à se connecter en SSH"
  type        = list(string)
}

variable "ami_id" {
  description = "The ID of the AMI to use for the Bastion instance"
  type        = string
  default     = "" 
}

variable "instance_type" {
  description = "The instance type for the Bastion instance"
  type        = string
  default     = "t2.micro"  
}

variable "private_ip" {
  description = "Private IP address for the bastion host"
  type        = string
  default     = ""  # Valeur par défaut vide ou appropriée
}

variable "security_group_id" {
  description = "ID of the security group to associate with the bastion host"
  type        = string
  default     = ""  # Valeur par défaut vide ou appropriée
}
