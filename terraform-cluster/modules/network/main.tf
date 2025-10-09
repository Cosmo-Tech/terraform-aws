resource "aws_default_subnet" "subnet1" {
  availability_zone = "${var.cluster_region}a"
}

resource "aws_default_subnet" "subnet2" {
  availability_zone = "${var.cluster_region}b"
}