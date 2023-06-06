resource "aws_security_group" "ec2" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.PORTS_EC2
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name        = "${var.PROJECT_NAME}_sg_ec2"
    Terraform   = "true"
    Environment = "dev"
  }
}


resource "aws_security_group" "efs" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = [aws_security_group.ec2.id]
  }

  ingress {
    security_groups = [aws_security_group.ec2.id]
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
  }

  tags = {
    Name        = "${var.PROJECT_NAME}_sg_efs"
    Terraform   = "true"
    Environment = "dev"
  }
}


resource "aws_security_group" "elb" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.PORTS_ELB
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name        = "${var.PROJECT_NAME}_sg_elb"
    Terraform   = "true"
    Environment = "dev"
  }
}
