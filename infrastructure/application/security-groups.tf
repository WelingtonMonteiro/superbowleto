resource "aws_security_group" "lambda" {
  name_prefix = "superbowleto_"
  description = "superbowleto Lambda Security Group"
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "superbowleto Lambda Security Group"
  }
}

resource "aws_security_group" "database" {
  name_prefix = "superbowleto_"
  description = "superbowleto Database Security Group"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "superbowleto Database Security Group"
  }
}

resource "aws_security_group_rule" "lambda-to-all-1" {
  security_group_id = "${aws_security_group.lambda.id}"
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lambda-to-all-2" {
  security_group_id = "${aws_security_group.lambda.id}"
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lambda-to-database-1" {
  security_group_id = "${aws_security_group.lambda.id}"
  type = "egress"
  from_port = 5432
  to_port = 5432
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.database.id}"
}

resource "aws_security_group_rule" "database-from-lambda-1" {
  security_group_id = "${aws_security_group.database.id}"
  type = "ingress"
  from_port = 5432
  to_port = 5432
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.lambda.id}"
}
