module "eks_core_apps" {
  source       = "./module"
  region       = "us-east-1"
  cluster_name = "eks-lab"


  # kube_proxy - https://docs.aws.amazon.com/pt_br/eks/latest/userguide/managing-kube-proxy.html
  kube_proxy_enable  = false
  kube_proxy_version = "v1.33.3-eksbuild.6"

  # vpc_cni - https://artifacthub.io/packages/helm/aws/aws-vpc-cni
  vpc_cni_enable      = false
  vpc_cni_version     = "1.20.1"
  subnets_filter_name = "private"        # subnets da rede CNI
  sg_filter_name      = "eks-cluster-sg" # sg do node

  # aws_load_balancer_controller - https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
  #(Necessário add tag na Subnet"kubernetes.io/role/internal-elb:1")
  alb_controller_enable  = false
  alb_controller_version = "1.13.4"

  # karpenter - https://artifacthub.io/packages/helm/aws-karpenter-crd/karpenter-crd
  karpenter_enable  = false
  karpenter_version = "1.6.3"
  cluster_version   = "1.33"
  capacity_type     = "on-demand"
  disk_size         = 30
  disk_iops         = 3000

  # autoscaler - https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler
  autoscaler_enable  = false
  autoscaler_version = "9.50.1"

  # metrics_server - https://artifacthub.io/packages/helm/metrics-server/metrics-server
  metrics_server_enable  = false
  metrics_server_version = "3.13.0"

  # nginx_controler - https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx
  nginx_controler_enable = false
  #certificate_arn         = "arn:aws:acm:..."
  nginx_controler_version = "4.13.2"

  # kube_dashboard - https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard
  kube_dashboard_enable        = false
  kube_dashboard_version       = "7.13.0"
  kube_dashboard_ingress_class = "nginx"
  kube_dashboard_url           = "kubedashboard.dominio"

  # kubecost - https://artifacthub.io/packages/helm/kubecost/cost-analyzer
  kubecost_enable        = false
  kubecost_version       = "2.8.2"
  kubecost_ingress_class = "nginx"
  kubecost_url           = "kubecost.dominio"

  # kube_prometheus_stack - https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack
  kube_prometheus_stack_enable                = false
  kube_prometheus_stack_version               = "77.5.0"
  kube_prometheus_stack_grafana_ingress_class = "nginx"
  kube_prometheus_stack_grafana_url           = "grafana.dominio"

  # aws_ebs_csi_driver - https://artifacthub.io/packages/helm/aws-ebs-csi-driver/aws-ebs-csi-driver
  ebs_csi_driver_enable  = false
  ebs_csi_driver_version = "2.48.0"

  # external_dns - https://artifacthub.io/packages/helm/bitnami/external-dns
  external_dns_enable             = false
  external_dns_version            = "9.0.3"
  external_dns_hosted_zone_id     = "Z06655772UAPK5LQZERAO"
  external_dns_hosted_zone_domain = "dominio"

}
