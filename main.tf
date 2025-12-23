# create instance
resource "aws_instance" "docker" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  # instance_type = "t3.medium"    # because t3.micro doesnot support kubernetes
  vpc_security_group_ids = [aws_security_group.allow-all-docker.id]

# need more for terraform
  root_block_device {
    volume_size = 50
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  user_data = file("docker.sh")
# iam_instance_profile = "TerraformAdmin"  

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-docker"
    }

  )
}

# security group
resource "aws_security_group" "allow-all-docker" {
  name        = "allow-all-docker"
  description = "this security group is for docker instance"

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

#   lifecycle {
#     create_before_destroy = true
#   }

  tags = merge(
    local.common_tags,
    {
        Name = "allow-all-docker"
    }
  )
}