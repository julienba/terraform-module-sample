resource "aws_security_group" "nat" {
    name = "nat"
    description = "Allow services from the private subnet through NAT"
    vpc_id = "${aws_vpc.main.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = -1
        to_port = -1
        protocol = "icmp"
    }

    tags {
        Name = "nat"
        env = "${var.env}"
    }
}

resource "aws_instance" "nat" {
    ami = "${lookup(var.aws_nat_ami, var.aws_region)}"
    instance_type = "t1.micro"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.nat.id}"]
    subnet_id = "${aws_subnet.public-1.id}"
    associate_public_ip_address = true
    source_dest_check = false
    tags {
        Name = "nat"
        subnet = "public"
        env = "${var.env}"
    }
}

resource "aws_eip" "nat" {
    instance = "${aws_instance.nat.id}"
    vpc = true
}
