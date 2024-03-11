# Create ssh sg
resource "aws_security_group" "SSH_security_group" {
    name        = "allow_to_ssh"
    description = "Allow SSH inbound traffic and all outbound traffic"
    vpc_id      = aws_vpc.dev-vpc.id
    
    ingress {
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = [var.ssh_location]
  }
       ingress {
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
  }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = -1
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "SSH security group"
    }
}

# Create ALB sg
resource "aws_security_group" "ALB_security_group" {
    name        = "For ALB"
    #description = "Allow SSH inbound traffic and all outbound traffic"
    vpc_id      = aws_vpc.dev-vpc.id
    
    ingress {
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
  }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = -1
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ALB Security Group"
    }
}

# Create Webserver Security Group
resource "aws_security_group" "webserver_sg" {
    name        = "For webserver sg"
    #description = "Allow SSH inbound traffic and all outbound traffic"
    vpc_id      = aws_vpc.dev-vpc.id
    
    ingress {
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        security_groups = [ aws_security_group.SSH_security_group.id ]
        #cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        security_groups = [ aws_security_group.ALB_security_group.id ]
        #cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
        from_port        = 443
        to_port          = 443
        security_groups = [ aws_security_group.ALB_security_group.id ]
        protocol         = "tcp"
        #cidr_blocks      = ["0.0.0.0/0"]
  }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = -1
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "webserver sg"
    }
}
# Create rds security group

resource "aws_security_group" "database_sg" {
    name        = "For database sg"
    #description = "Allow mysql/aurora connection on port 3306"
    vpc_id      = aws_vpc.dev-vpc.id
    
    ingress {
        from_port        = 3306
        to_port          = 3306
        protocol         = "tcp"
        security_groups = [ aws_security_group.webserver_sg.id ]
        #cidr_blocks      = ["0.0.0.0/0"]
  }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = -1
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "database-sg"
    }
}