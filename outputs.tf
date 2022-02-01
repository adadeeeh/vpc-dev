output "aws_region" {
  description = "AWS Region"
  value       = var.aws_region
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.dev.id
}

output "sg_ec2" {
  description = "SG EC2"
  value       = aws_security_group.sg_ec2.id
}

output "public_subnet_1" {
  description = "Public subnet 1"
  value       = aws_subnet.public.id
}