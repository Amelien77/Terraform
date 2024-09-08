output "vpc_id" {
  description = "L'ID du VPC"
  value       = aws_vpc.datascientest_vpc.id
}

output "public_subnet_a_id" {
  description = "L'ID du sous-réseau public A"
  value       = aws_subnet.public_subnet_a.id
}

output "public_subnet_b_id" {
  description = "L'ID du sous-réseau public B"
  value       = aws_subnet.public_subnet_b.id
}

output "app_subnet_a_id" {
  description = "L'ID du sous-réseau privé A"
  value       = aws_subnet.app_subnet_a.id
}

output "app_subnet_b_id" {
  description = "L'ID du sous-réseau privé B"
  value       = aws_subnet.app_subnet_b.id
}

output "nat_gateway_a_id" {
  description = "L'ID de la passerelle NAT dans le sous-réseau public A"
  value       = aws_nat_gateway.gw_public_a.id
}

output "nat_gateway_b_id" {
  description = "L'ID de la passerelle NAT dans le sous-réseau public B"
  value       = aws_nat_gateway.gw_public_b.id
}

output "public_subnets" {
  description = "output combiné des sous-réseaux publics pour module load_balancer"
  value = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value = [
    aws_subnet.app_subnet_a.id,
    aws_subnet.app_subnet_b.id
  ]
}


#-----------------------------1 table publique -------------------------#

output "public_route_table_id" {
  value       = aws_route_table.public_route_table.id
  description = "ID de la table de routage publique"
}

#------------------------------2 tables privés---------------------------#

output "private_route_table_a_id" {
  value       = aws_route_table.private_route_table_a.id
  description = "ID de la table de routage privée pour le sous-réseau privé A"
}

output "private_route_table_b_id" {
  value       = aws_route_table.private_route_table_b.id
  description = "ID de la table de routage privée pour le sous-réseau privé B"
}
