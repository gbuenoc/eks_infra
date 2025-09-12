module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "eks-lab"
  kubernetes_version = "1.33"

  addons = { #create the cluster with no addons
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

  vpc_id                   = data.aws_vpc.lab.id
  subnet_ids               = data.aws_subnets.lab_private.ids
  control_plane_subnet_ids = data.aws_subnets.lab_private.ids

  #   fargate_profiles = {
  #   coredns = {
  #     name = "coredns"
  #     selectors = [
  #       {
  #         namespace = "kube-system"
  #         labels = {
  #           k8s-app = "kube-dns"
  #         }
  #       }
  #     ]
  #     subnets = data.aws_subnets.lab_private.ids
  #     tags = {
  #       Name = "eks-fargate-coredns"
  #     }
  #   }

  #   karpenter = {
  #     name = "karpenter"
  #     selectors = [
  #       {
  #         namespace = "kube-system"
  #         labels = {
  #           "app.kubernetes.io/name" = "karpenter"
  #         }
  #       }
  #     ]
  #     subnets = data.aws_subnets.lab_private.ids
  #     tags = {
  #       Name = "eks-fargate-karpenter"
  #     }
  #   }
  # }

  # EKS Self Managed Node Group(s)
  self_managed_node_groups = {
    ng_tools = {
      name          = "ng-tools"
      ami_type      = "BOTTLEROCKET_x86_64"
      instance_type = "t3.medium"
      min_size      = 2
      max_size      = 5
      desired_size  = 2

      taints = {
        agent_not_ready = {
          key    = "node.cilium.io/agent-not-ready"
          value  = "true"
          effect = "NO_EXECUTE"
        }
      }

      tags = {
        "Name" = "eks-lab-ng-tools"
      }
    }
  }

  node_security_group_additional_rules = {
    # allow all from VPC (simple + effective for tests)
    allow_all_from_vpc = {
      description = "Allow all traffic from VPC CIDR"
      type        = "ingress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_blocks = ["10.0.0.0/16"]
    }

    # optional: be explicit for ICMP if you prefer tighter rules
    allow_icmp_from_vpc = {
      description = "Allow ICMP from VPC CIDR"
      type        = "ingress"
      protocol    = "icmp"
      from_port   = -1
      to_port     = -1
      cidr_blocks = ["10.0.0.0/16"]
    }

    allow_all_from_cilium = {
      description = "Allow all traffic from Cilium CIDR"
      type        = "ingress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_blocks = ["100.64.0.0/16"]
    }
  }

  tags = {
    Environment              = "lab"
    Terraform                = "true"
    "karpenter.sh/discovery" = "eks-lab" # Required for Karpenter to discover usable subnets
  }
}