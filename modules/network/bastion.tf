resource "aws_security_group" "bastion" {
    name = "bastion"
    description = "Allow SSH traffic from the internet"
    vpc_id = "${aws_vpc.main.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "bastion"
        env = "${var.env}"
    }
}

output "aws_sg_bastion_id" {
    value = "${aws_security_group.bastion.id}"
}

resource "aws_security_group" "allow_bastion" {
    name = "allow_bastion_ssh"
    description = "Allow access from bastion host"
    vpc_id = "${aws_vpc.main.id}"   
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        security_groups = ["${aws_security_group.bastion.id}"]
        self = false
    }
}

output "aws_sg_allow_bastion" {
    value = "${aws_security_group.allow_bastion.id}"
}
