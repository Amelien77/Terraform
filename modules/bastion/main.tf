#---------------Sélection de la dernière AMI AWS pour le Bastion ------------#

data "aws_ami" "bastion_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

# définit une data source pour rechercher une AMI la plus récente


#--------------- Groupe de sécurité pour le Bastion ------------------------#

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Groupe de sécurité pour le Bastion"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

#----------------- Instance bastion ---------------------------------------#

resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "Bastion-Instance"
  }

  associate_public_ip_address = true
}

#-------------------------Interface réseau pour le bastion-------------------#

resource "aws_network_interface" "bastion_nic" {
  subnet_id   = var.subnet_id
  private_ips  = [var.private_ip]
  security_groups = [var.security_group_id]

  tags = {
    Name = "bastion-nic"
  }
}


#---------------------- Configuration de lancement pour le bastion------------#

resource "aws_launch_configuration" "bastion_lc" {
  name          = "bastion-lc"
  image_id      = data.aws_ami.bastion_ami.id
  instance_type = "t2.micro"
  security_groups = [
    aws_security_group.bastion_sg.id
  ]
  
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y amazon-linux-extras
              EOF
}

# associe l'image récupéré plus haut au bastion
# security_groups = [ aws_security_group.bastion_sg.id ] associe le groupe de sécurité au bastion
# user_data permet d'exectuer un script bash lors du démarrage de l'instance, installe les paquets

# ----------------------------Autoscaling pour bastion (Bonus)------------------------#

########## Autoscaling Group pour le Bastion ##########
resource "aws_autoscaling_group" "bastion_asg" {
  launch_configuration = aws_launch_configuration.bastion_lc.id
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  vpc_zone_identifier  = var.public_subnets

  tag {
    key                 = "Name"
    value               = "bastion-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# launch_configuration = aws_launch_configuration.bastion_lc.id permet de lié l'autoscaling à notre instance bastion
# vpc_zone_identifier  = var.public_subnets spécifie les sous-réseaux publics dans lesquels les instances seront lancées --> variables
# tag permet de donner le nom "bastion-instance" à toutes les instances créer par cet autoscaling
# lifecycle ... permet de s'assurer que la nouvelle instance soit créée avant la suppression de l'ancienne pour éviter les interruptions

