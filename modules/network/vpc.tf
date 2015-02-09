resource "aws_vpc" "main" {
    cidr_block = "${var.network}.0.0/16"

    tags {
        Name = "test"
        env = "${var.env}"
    }
}

output "aws_vpc_id" {
    value = "${aws_vpc.main.id}"
}

resource "aws_internet_gateway" "main" {
    vpc_id = "${aws_vpc.main.id}"
}

output "aws_internet_gateway_id" {
    value = "${aws_internet_gateway.main.id}"
}

