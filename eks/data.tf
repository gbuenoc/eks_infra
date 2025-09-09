data "aws_vpcs" "lab" {
  filter {
    name   = "tag:Name"
    values = ["*lab*"]
  }
}

data "aws_vpc" "lab" {
  id = data.aws_vpcs.lab.ids[0]
}

data "aws_subnets" "lab_private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}
