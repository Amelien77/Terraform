# ---------------------------------------------AMI-----------------------------#

# Récupération de la dernière AMI Ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*"]
  }
}


# most_recent = true --> version de l'image la plus récente
# owners = ["099720109477"] --> ID du propriétaire de l'AMI
# filter --> on filtre le nom par values

#---------------------------------security group---------------------------------#

# Création du groupe de sécurité pour WordPress
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "Groupe de sécurité pour les instances WordPress"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# vpc_id = var.vpc_id --> on inclut le groupe de sécurité dans le VPC
# ingress --> trafic entrant sur port 80
# egress --> trafic sortant sur tous ports et tous protocoles

#------------------------------Autoscaling--------------------------------#

# conf. de lancement instances EC2 pour Auto Scaling Group
resource "aws_launch_configuration" "wordpress_lc" {
  name          = var.launch_configuration_name
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  security_groups = [
    aws_security_group.wordpress_sg.id
  ]

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y apache2 php mysql-client
              apt install -y wordpress php-gettext
              ln -s /usr/share/wordpress /var/www/html/wordpress
              EOF
}
# image_id = data.aws_ami.ubuntu.id on utilise l'AMI généré plus haut
# instance_type = "t2.micro", type d'instance la plus petite d'AWS. 
# security_groups --> security group à utiliser sur l'instance.
# lifecycle {create_before_destroy = true}, permet de s'assurer que la nouvelle instance soit créer avant de supprimer l'ancienne pour éviter les interruptions 
# user_data --> script bash pour mettre à jour les paquets, installer appache, php etc.


# Auto Scaling Group pour gérer les instances EC2 de manière dynamique
resource "aws_autoscaling_group" "wordpress_asg" {
  launch_configuration = aws_launch_configuration.wordpress_lc.id
  vpc_zone_identifier  = var.private_subnets
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size

  tag {
    key                 = "Name"
    value               = var.tags["Name"]
    propagate_at_launch = true
  }
}

# launch_configuration = aws_launch_configuration.wordpress_lc.id on utilise l'ID de l'instance EC2 vu plus haut
# vpc_zone_identifier  = var.private_subnets Liste les sous-réseaux pricé dans lequel l'instance doit être lancé
# min/max size détermine le minimum et maximum d'instance déployable
# tag ... propagate_at_launch = true définit le nom/balise automatiquement pour chaque nouvelle instance créé.


#------- Attache l'Auto Scaling Group au Target Group du Load Balancer-----------#


resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
  lb_target_group_arn    = aws_lb_target_group.wordpress_tg.arn
}


resource "aws_lb_target_group" "wordpress_tg" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}
