resource "helm_release" "cilium" {
  count       = var.cilium_enable ? 1 : 0
  name        = "cilium"
  description = "A Helm chart to deploy cilium"
  namespace   = "kube-system"
  chart       = "cilium"
  version     = var.cilium_version
  repository  = "https://helm.cilium.io"
  wait        = false
  replace     = true

  values = [
    templatefile("${path.module}/helm-values/values-cilium.tpl.yaml", {
      k8sServiceHost = replace(data.aws_eks_cluster.default.endpoint, "https://", "")
      k8sServicePort = "443"
    })
  ]
  depends_on = [
    module.eks
  ]
}

resource "aws_eks_addon" "coredns" {
  count                       = var.coredns_enable ? 1 : 0
  cluster_name                = module.eks.cluster_name
  addon_name                  = "coredns"
  addon_version               = var.coredns_version
  resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"
  configuration_values = jsonencode({
    tolerations = [
      { key = "node.kubernetes.io/not-ready", operator = "Exists" },
      { key = "node.kubernetes.io/agent-not-ready", operator = "Exists" }
    ]
    replicaCount = 2
    resources = {
      limits = {
        memory : "170Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "70Mi"
      }
    }
  })

  depends_on = [
    helm_release.cilium
  ]

  tags = {
    "eks_addon" = "coredns"
  }
}