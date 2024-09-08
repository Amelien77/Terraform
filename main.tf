module "network_vpc" {
  source = "./modules/network_vpc"
  # Pass the required variables
  # Example:
  # cidr_vpc = "10.0.0.0/16"
  # az_a = "eu-west-3a"
  # az_b = "eu-west-3b"
  # etc.
}

module "wordpress" {
  source = "./modules/wordpress"
  vpc_id = module.network_vpc.vpc_id
  private_subnets = [
    module.network_vpc.app_subnet_a_id,
    module.network_vpc.app_subnet_b_id
  ]
  ami_id = ""
  wordpress_asg_id = module.load_balancer.wordpress_asg_id
}

module "database" {
  source          = "./modules/database"
  db_username     = var.db_username
  db_password     = var.db_password
  vpc_id          = module.network_vpc.vpc_id
  private_subnets = [
    module.network_vpc.app_subnet_a_id,
    module.network_vpc.app_subnet_b_id
  ]
  app_subnet_cidrs = [
    "10.1.2.0/24",
    "10.1.3.0/24"
  ]
}

module "bastion" {
  source          = "./modules/bastion"
  vpc_id          = module.network_vpc.vpc_id
  public_subnets  = module.network_vpc.public_subnets
  subnet_id       = module.network_vpc.public_subnet_a_id
  allowed_ssh_ips = ["34.241.31.66/32"]

  ami_id          = "ami-12345678"  # Remplace par l'AMI appropriée
  instance_type   = "t2.micro"      # Remplace par le type d'instance souhaité

  depends_on = [module.network_vpc]
}



module "load_balancer" {
  source          = "./modules/load_balancer"
  public_subnets  = module.network_vpc.public_subnets
  private_subnets = module.network_vpc.private_subnets
  vpc_id          = module.network_vpc.vpc_id

  asg_min_size    = 1
  asg_max_size    = 3
  ami_id          = "ami-12345678"   # Remplace par l'AMI appropriée
  instance_type   = "t2.micro"       # Remplace par le type d'instance approprié
  tags            = {
    Name = "wordpress-instance"
  }
}

