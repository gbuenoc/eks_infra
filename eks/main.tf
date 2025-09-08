module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "eks-lab"
  kubernetes_version = "1.33"

  addons = {
    # coredns                = {}
    # eks-pod-identity-agent = {
    #   before_compute = true
    # }
    # kube-proxy             = {}
    # vpc-cni                = {
    #   before_compute = true
    # }
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = "vpc-052dc7c998e545c5a"
  subnet_ids               = ["subnet-0172b2e38bfc79d17", "subnet-0d4b6f0113c101d41", "subnet-0b7f6fe8e48e1685b"]
  control_plane_subnet_ids = ["subnet-0172b2e38bfc79d17", "subnet-0d4b6f0113c101d41", "subnet-0b7f6fe8e48e1685b"]

  fargate_profiles = {
  coredns = {
    name = "coredns"
    selectors = [
      {
        namespace = "kube-system"
        labels = {
          k8s-app = "kube-dns"
        }
      }
    ]
    subnets = ["subnet-0172b2e38bfc79d17", "subnet-0d4b6f0113c101d41", "subnet-0b7f6fe8e48e1685b"]
    tags = {
      Name = "eks-fargate-coredns"
    }
  }

  karpenter = {
    name = "karpenter"
    selectors = [
      {
        namespace = "kube-system"
        labels = {
          "app.kubernetes.io/name" = "karpenter"
        }
      }
    ]
    subnets = ["subnet-0172b2e38bfc79d17", "subnet-0d4b6f0113c101d41", "subnet-0b7f6fe8e48e1685b"]
    tags = {
      Name = "eks-fargate-karpenter"
    }
  }
}

  # EKS Managed Node Group(s)
#   eks_managed_node_groups = {
#     example = {
#       # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
#       ami_type       = "AL2023_x86_64_STANDARD"
#       instance_types = ["m5.xlarge"]

#       min_size     = 2
#       max_size     = 10
#       desired_size = 2
#     }
#   }

  tags = {
    Environment = "lab"
    Terraform   = "true"
    "karpenter.sh/discovery" = "eks-lab"
  }
}