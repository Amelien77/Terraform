
#-----------------------------Database-----------------------------#

########## Création instance base de données RDS (mysql) pour WordPress ##########
resource "aws_db_instance" "wordpress_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "wordpress_db"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  multi_az             = true
  publicly_accessible  = false
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name

  tags = {
    Name = "wordpress-rds"
  }
}

# allocated_storage = 20 Définit la taille de stockage pour la base de données : 20giga
# engine  = "mysql" on définit le moteur
# instance_class = "db.t3.micro" le type d'instance comùme demandé dans l'exercice
# username password --> information d'identification dans variables.tf
# parameter_group_name ensemble de paramètre
# multi_az = true pour permettre la réplication de la db dans d'autres AZ. Permet la haute disponibilité 
# publicly_accessible  = false on ne souhaite pas que l'accès soit publique
# vpc_security_group_ids = [aws_security_group.db_sg.id] liste des groupes de sécu attaché à la db

######### groupe de sous-réseaux pour db ############

resource "aws_db_subnet_group" "db_subnet" {
  name       = "wordpress-db-subnet"
  subnet_ids = var.private_subnets

  tags = {
    Name = "wordpress-db-subnet-group"
  }
}

# création d'un groupe réseau pour db en prenant l'ID d'un sous réseau--> variables.tf 

########## groupe de sécurité pour db ##########

resource "aws_security_group" "db_sg" {
  name        = "wordpress-db-sg"
  description = "Groupe de sécurité pour la base de données WordPress"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.app_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# création d'un groupe de sécurité dans le VPC existant: vpc_id = var.vpc_id
# ingress = entrant sur port 3306 protocol TCP
# cidr_blocks = var.app_subnet_cidrs plages d'adresse IP permettant l'accès à la database --W variables.tf
# egress = sortant sur tous ports peu importe le protocol

