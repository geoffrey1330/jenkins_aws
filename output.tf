output "ec2_public_ip" {
  description = "EC2 public ip address"
  value       = aws_instance.instance1.public_ip
}

output "elb_dns_name" {
  description = "ELB DNS name"
  value       = module.elb.elb_dns_name
}

output "instance2_local_ip" {
  description = "EC2 instance 2 public IP address"
  value = aws_instance.instance2.private_ip
}

output "instance2_public_ip" {
  description = "EC2 instance 2 public IP address"
  value = aws_instance.instance2.public_ip
}

output "instance3_public_ip" {
  description = "EC2 instance 2 public IP address"
  value = aws_instance.instance3.public_ip
}
