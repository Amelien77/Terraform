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
