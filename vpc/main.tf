module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "lab-vpc"
  cidr = "10.0.0.0/16"

  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]

  enable_nat_gateway = true
  single_nat_gateway = true

  private_subnet_tags = {
    "karpenter.sh/discovery" = "eks-lab" # Required for Karpenter to discover usable subnets
    #"kubernetes.io/role/internal-elb" = 1 # Uncomment if Ingress Controller should use private subnets
  }

  public_subnet_tags = {
    #"kubernetes.io/role/elb" = 1 # Uncomment if Ingress Controller should use public subnets
  }

  tags = {
    Terraform   = "true"
    Environment = "lab"
  }
}

# CIDR block and subnets for pods
resource "aws_vpc_ipv4_cidr_block_association" "cidr_pods" {
  vpc_id     = module.vpc.vpc_id
  cidr_block = "100.64.0.0/16"
}

resource "aws_subnet" "subnet_pod_1" {
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = "100.64.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  depends_on = [aws_vpc_ipv4_cidr_block_association.cidr_pods]

  tags = {
    Name              = "subnet_pod_1"
    Environment       = "lab"
    cilium-pod-subnet = true
  }
}

resource "aws_subnet" "subnet_pod_2" {
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = "100.64.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  depends_on = [aws_vpc_ipv4_cidr_block_association.cidr_pods]

  tags = {
    Name              = "subnet_pod_2"
    Environment       = "lab"
    cilium-pod-subnet = true
  }
}

resource "aws_subnet" "subnet_pod_3" {
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = "100.64.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = false

  depends_on = [aws_vpc_ipv4_cidr_block_association.cidr_pods]

  tags = {
    Name              = "subnet_pod_3"
    Environment       = "lab"
    cilium-pod-subnet = true
  }
}

resource "aws_route_table_association" "subnet_pod_1_assoc" {
  subnet_id      = aws_subnet.subnet_pod_1.id
  route_table_id = module.vpc.private_route_table_ids[0]
}

resource "aws_route_table_association" "subnet_pod_2_assoc" {
  subnet_id      = aws_subnet.subnet_pod_2.id
  route_table_id = module.vpc.private_route_table_ids[0]
}

resource "aws_route_table_association" "subnet_pod_3_assoc" {
  subnet_id      = aws_subnet.subnet_pod_3.id
  route_table_id = module.vpc.private_route_table_ids[0]
}