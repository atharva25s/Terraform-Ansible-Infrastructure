# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.0"
#     }
    
#      local = {
#       source  = "hashicorp/local"
#       version = "~> 2.0"
#     }
#   }
# }

# provider "aws" {
#   region     = "ap-south-1"
# }

# EC2 INSTANCE
resource "aws_instance" "web_server" {

  ami           = "ami-019715e0d74f695be"   # Ubuntu AMI in ap-south-1
  instance_type = "t2.medium"

  key_name = "test-key"  # name of keypair in AWS, not .pem file

  vpc_security_group_ids = ["sg-078b5757a151cdbc4"]

  root_block_device {
    volume_size = 24
    volume_type = "gp3"
  } 

  tags = {
    Name = "terraform-ec2"
  }
}

output "ec2_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.web_server.private_ip
}

resource "local_file" "ansible_inventory" {
  filename = "/home/ubuntu/ansible/inventory.ini"

  content = <<EOT
[ec2]
${aws_instance.web_server.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/configs/test-key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOT
}
