output "vpc_id" {
  value = aws_vpc.datascientest_vpc.id
}

output "app_subnet_a_id" {
  value = aws_subnet.app_subnet_a.id
}

output "app_subnet_b_id" {
  value = aws_subnet.app_subnet_b.id
}
