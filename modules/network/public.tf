resource "aws_subnet" "public-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.network}.${var.net-pub-1}.0/24"
    availability_zone = "${lookup(var.zone-1, var.aws_region)}"
    tags {
        subnet = "public"
        env = "${var.env}"
        zone = "1"
    }
}

output "aws_subnet_public_1" {
    value = "${aws_subnet.public-1.id}"
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main.id}"
    }
}

resource "aws_route_table_association" "public-1" {
    subnet_id = "${aws_subnet.public-1.id}"
    route_table_id = "${aws_route_table.public.id}"
}

