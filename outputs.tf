output "network_vpc_id" {
  value = module.network_vpc.vpc_id
}

output "wordpress_asg_id" {
  value = module.wordpress.wordpress_asg_id
}

output "database_db_instance_id" {
  value = module.database.db_instance_id
}

output "bastion_instance_id" {
  value = module.bastion.bastion_instance_id
}
