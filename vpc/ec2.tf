# # Create ec2 Instance
# resource "aws_instance" "this" {
#   ami                     = "ami-0440d3b780d96b29d"
#   instance_type           = "t2.micro"
#   key_name = "var.key_pair_name"
#   subnet_id = aws_subnet.Public-subnet-AZ1.id
#   security_groups = [ aws_security_group.SSH_security_group.id ]
#   associate_public_ip_address = true

#   tags = {
#     Name = "Test Ec2"
#   }
#    user_data = "${file("user-data-apache.sh")}"
# }
