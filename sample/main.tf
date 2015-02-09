module "network" {
    source = "../modules/network"
    access_key = "${var.access_key}"
    key_path = "${var.key_path}"
    key_name = "${var.key_name}"
    secret_key = "${var.secret_key}"
    allowed_network = "${var.allowed_network}"
    network = "${var.network}"
} 


output "aws_vpc_id" {
    value = "${module.network.aws_vpc_id}" 
}

output "aws_subnet_public_subnet_1" {
    value = "${module.network.aws_subnet_public_1}"
}

output "aws_sg_allow_bastion" {
    value = "${module.network.aws_sg_allow_bastion}"
}

output "aws_subnet_private_1" {
    value = "${module.network.aws_subnet_private_1}"
}

##
# Bastion
## 

resource "aws_instance" "bastion-1" {
    ami = "${lookup(var.aws_amis, var.aws_region)}"
    instance_type = "t1.micro"
    key_name = "${var.key_name}"
    associate_public_ip_address = true
    security_groups = [
        "${module.network.aws_sg_bastion_id}"
    ]

    subnet_id = "${module.network.aws_subnet_public_1}"

    tags {
        Name = "bastion-1"
        subnet = "public"
        env = "${var.env}"
    }
}

output "bastion_1_ip" {
    value = "${aws_instance.bastion-1.public_ip}"
}

resource "aws_security_group" "consul" {
    name = "consul"
    description = "Consul internal traffic + maintenance."
    vpc_id = "${module.network.aws_vpc_id}"

    ingress {
        from_port = 53
        to_port = 53
        protocol = "tcp"
        self = true
    }
    ingress {
        from_port = 53
        to_port = 53
        protocol = "udp"
        self = true
    }
    ingress {
        from_port = 8300
        to_port = 8302
        protocol = "tcp"
        self = true
    }
    ingress {
        from_port = 8301
        to_port = 8302
        protocol = "udp"
        self = true
    }
    ingress {
        from_port = 8400
        to_port = 8400
        protocol = "tcp"
        self = true
    }
    ingress {
        from_port = 8500
        to_port = 8500
        protocol = "tcp"
        self = true
    }
}

resource "aws_instance" "consul" {
    ami = "${lookup(var.aws_amis, var.aws_region)}"
    instance_type = "t1.micro"
    count = 1
    key_name = "${var.key_name}"
    security_groups = [
        "${module.network.aws_sg_allow_bastion}",
        "${aws_security_group.consul.id}"
    ]
    subnet_id = "${module.network.aws_subnet_private_1}"
    tags = {
        Name = "consul-${count.index}"
        subnet = "private"
        env = "${var.env}"
        role = "dns"
    }
}
