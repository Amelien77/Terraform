
#----------------------- Création load Balancer ---------------------------#
resource "aws_lb" "wordpress_alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false
  idle_timeout = 60
}

#internal = false car accessible depuis l'extérieur.
#load_balancer_type = "application" car type ALB
#enable_deletion_protection = false empèche la suppression accidentelle
#idle_timeout = 60 rend inactif au bout de 60s


#---------- Déclaration du groupe de mise à l'échelle automatique -------------#
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

#----------- configuration de lancement de l'autoscaling ---------------------#

resource "aws_launch_configuration" "wordpress_lc" {
  name          = "wordpress-launch-configuration"
  image_id      = var.ami_id
  instance_type = var.instance_type

  security_groups = [aws_security_group.wordpress_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}


#------------------ Création groupe de sécurité pour lb ---------------------#
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Groupe de sécurité pour l'ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

#------------------- Création groupe de sécurité wordpress -----------------#

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "Groupe de sécurité pour les instances WordPress"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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


#-------------- Création du target group -----------------------------------#
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

#----------- association instances au groupe cible via auto-scaling ----------#
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
  lb_target_group_arn    = aws_lb_target_group.wordpress_tg.arn
}

#---------------------- Listener sur port HTTP -------------------------------#

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}


#------------------- Listener sur port HTTPS ----------------------#
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = 443
  protocol          = "HTTPS"

  certificate_arn = aws_acm_certificate.wordpress_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

#-----------------------accès sécurisé (BONUS)------------------#

#---------------- Création du certificat SSL/TLS ------------------#
resource "aws_acm_certificate" "wordpress_cert" {
  domain_name       = "ambonneau-devops.cloudns.be"
  validation_method = "DNS"

  tags = {
    Name = "wordpress-cert"
  }
}

