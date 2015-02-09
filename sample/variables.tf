variable "key_name" {
    description = "Name of the SSH keypair to use in AWS."
}

variable "key_path" {
    description = "Path to the private portion of the SSH key specified."
}

variable "access_key" {}
variable "secret_key" {}

variable "aws_region" {
    description = "AWS region to launch servers."
    default = "eu-west-1"
}

# Packer debian salt images
variable "aws_amis" {
    default = {
        eu-west-1 = "ami-9c62cdeb"
    }
}

variable "allowed_network" {
    description = "The CIDR of network that is allowed to access the bastion host"
}

variable "zone-1" {
    default = {
       eu-west-1 = "eu-west-1a" 
    }
}

variable "aws_nat_ami" {
    default = {
        eu-west-1 = "ami-30913f47"
    }
}

variable "env" {}
 
