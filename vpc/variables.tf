variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}

variable "Public_subnet_AZ1_cidr_block" {
    default = "10.0.1.0/24"
}

variable "Public_subnet_AZ2_cidr_block" {
    default = "10.0.2.0/24"
}
variable "Private_subnet_AZ1_cidr_block" {
    default = "10.0.3.0/24"
}

variable "Private_subnet_AZ2_cidr_block" {
    default = "10.0.4.0/24"
}

variable "ssh_location" {
    default = "0.0.0.0/0"
    description = "this should be my ip"
}

variable "certificate-rn" {
    default = "arn:aws:acm:us-east-1:871909687521:certificate/03ae218d-8dde-49a6-95ec-47d54f5904ff"
    description = "Certificate arn"
}
variable "ami_image" {
    default = "ami-0440d3b780d96b29d"
    description = "launch template ami"
}

variable "key_pair_name" {
    default = "SSH-KEY-Jenkins"
}

