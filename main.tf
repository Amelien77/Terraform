module "network_vpc" {
  source = "./modules/network_vpc"
  # Pass the required variables
}

module "wordpress" {
  source = "./modules/wordpress"
  vpc_id = module.network_vpc.vpc_id
  private_subnets = [
    module.network_vpc.app_subnet_a_id,
    module.network_vpc.app_subnet_b_id
  ]
}

module "database" {
  source          = "./modules/database"
  db_username     = var.db_username
  db_password     = var.db_password
  vpc_id          = module.network_vpc.vpc_id
  private_subnets = module.network_vpc.private_subnets
  app_subnet_cidrs = module.network_vpc.app_subnet_cidrs
}
