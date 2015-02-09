resource "aws_subnet" "private-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.network}.${var.net-priv-1}.0/24"
    availability_zone = "${aws_subnet.public-1.availability_zone}"
    tags {
        subnet = "private"
        env = "${var.env}"
        zone = "1"
    }
}

output "aws_subnet_private_1" {
  value = "${aws_subnet.private-1.id}"
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.main.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }
}

output "aws_route_table_private_id" {
    value = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "private-1" {
    subnet_id = "${aws_subnet.private-1.id}"
    route_table_id = "${aws_route_table.private.id}"
}

