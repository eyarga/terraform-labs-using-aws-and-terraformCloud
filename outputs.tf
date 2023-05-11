output "out_vpc_id" {
  value = aws_vpc.this.id
}

output "out_vpc_module_name" {
  value = module.vpc_module.name
}