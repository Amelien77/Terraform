
#----------------------------Load Balancer----------------------------#

########## Création load Balancer ###############
resource "aws_lb" "wordpress_alb" {
  name               = "wordpress-alb"
  internal           = false  # Ce doit être un ALB externe (accessible depuis l'extérieur)
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets  # Les sous-réseaux publics pour l'ALB

  enable_deletion_protection = false  # Facultatif, pour la protection contre la suppression accidentelle
  idle_timeout = 60
}


########## Création groupe de sécurité pour lb ################

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Groupe de sécurité pour l'ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Autorise les connexions HTTP depuis l'extérieur
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Autorise les connexions HTTPS si configuré
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


############ Création du target group ##############
# contient les instances Wordpress vers lesquelles le trafic sera redirigé

resource "aws_lb_target_group" "wordpress_tg" {
  name     = "wordpress-tg"
  port     = 80  # Le port sur lequel le service WordPress écoute
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"  # Vérifie si le serveur répond avec un statut HTTP 200
  }
}

########### association instances au groupe cible via auto-scaling ###########

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
  alb_target_group_arn   = aws_lb_target_group.wordpress_tg.arn
}

########### Listener sur port HTTP ############


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}
