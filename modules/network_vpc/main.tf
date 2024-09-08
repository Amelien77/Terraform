
#---------------------------------1 VPC----------------------------------------#


######### Création du VPC datascientest ##########
resource "aws_vpc" "datascientest_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "datascientest-vpc"
  }
}


#-------------------------------4 sous-réseaux-----------------------------------#


########## Sous-réseaux publics ##########
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.datascientest_vpc.id
  cidr_block              = var.cidr_public_subnet_a
  map_public_ip_on_launch = true
  availability_zone       = var.az_a
  tags = {
    Name        = "public-a"
    Environment = var.environment
  }
  depends_on = [aws_vpc.datascientest_vpc]
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.datascientest_vpc.id
  cidr_block              = var.cidr_public_subnet_b
  map_public_ip_on_launch = true
  availability_zone       = var.az_b
  tags = {
    Name        = "public-b"
    Environment = var.environment
  }
  depends_on = [aws_vpc.datascientest_vpc]
}

########## Sous-réseaux privés ##########
resource "aws_subnet" "app_subnet_a" {
  vpc_id                  = aws_vpc.datascientest_vpc.id
  cidr_block              = var.cidr_app_subnet_a
  availability_zone       = var.az_a
  tags = {
    Name        = "app-a"
    Environment = var.environment
  }
  depends_on = [aws_vpc.datascientest_vpc]
}

resource "aws_subnet" "app_subnet_b" {
  vpc_id                  = aws_vpc.datascientest_vpc.id
  cidr_block              = var.cidr_app_subnet_b
  availability_zone       = var.az_b
  tags = {
    Name        = "app-b"
    Environment = var.environment
  }
  depends_on = [aws_vpc.datascientest_vpc]
}

# vpc_id = aws_vpc.datascientest_vpc.id permet d'inclure le sous-réseau au VPC
# cidr_block = var.cidr_app_subnet_X permet de donner un plage d'adresse IP --> variables.tf
# availability_zone = var.az_b permet de définir une AZ (+région) pour chaque Sous réseau --> variables.tf
# tags pour donner un nom descriptif & environnement utilisé
# depends_on = [aws_vpc.datascientest_vpc] indique une dépendance explicite pour s'asurer que le VPC soit créé avant le sous réseau

#------------------------ 2 NAT Gateways ----------------------------------------#


########## Création de la passerelle NAT pour le sous-réseau public-a ##########
resource "aws_eip" "eip_public_a" {
  domain = "vpc" # Utilisation de l'attribut 'domain'
}

resource "aws_nat_gateway" "gw_public_a" {
  allocation_id = aws_eip.eip_public_a.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "datascientest-nat-public-a"
  }
}


########## Création de la passerelle NAT pour le sous-réseau public-b ##########
resource "aws_eip" "eip_public_b" {
  domain = "vpc"
}

resource "aws_nat_gateway" "gw_public_b" {
  allocation_id = aws_eip.eip_public_b.id
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "datascientest-nat-public-b"
  }
}

#------------------------------------1 Gateway internet-----------------------#

# Création de la gateway Internet
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.datascientest_vpc.id
  tags = {
    Name = "${var.environment}-igw"
  }
}

#--------------------3 table de routage & route/3 associations----------------#

# Table de routage pour les sous-réseaux publics
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.datascientest_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
  tags = {
    Name = "${var.environment}-public-route-table"
  }
}

# Association des sous-réseaux publics avec la table de routage
resource "aws_route_table_association" "public_route_table_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

# Table de routage pour le sous-réseau privé A
resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.datascientest_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw_public_a.id  # Utilisation de la NAT Gateway correcte
  }
  tags = {
    Name = "${var.environment}-private-route-table-a"
  }
}

# Association du sous-réseau privé A avec sa table de routage
resource "aws_route_table_association" "private_route_table_association_a" {
  subnet_id      = aws_subnet.app_subnet_a.id
  route_table_id = aws_route_table.private_route_table_a.id
}

# Table de routage pour le sous-réseau privé B
resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.datascientest_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw_public_b.id  # Utilisation de la NAT Gateway correcte
  }
  tags = {
    Name = "${var.environment}-private-route-table-b"
  }
}

# Association du sous-réseau privé B avec sa table de routage
resource "aws_route_table_association" "private_route_table_association_b" {
  subnet_id      = aws_subnet.app_subnet_b.id
  route_table_id = aws_route_table.private_route_table_b.id
}
