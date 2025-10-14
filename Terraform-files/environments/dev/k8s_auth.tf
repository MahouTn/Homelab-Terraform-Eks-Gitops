data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)

  # This section explicitly tells the Kubernetes provider how to get the token.
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # Arguments specify the command: "aws eks get-token --cluster-name homelab-eks --region eu-west-1"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name,
      "--region",
      "eu-west-1" # Hardcode or use a var if necessary
    ]
  }

}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = module.eks.node_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ])
    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::802617578034:user/ayoub.mahou@talan.com"
        username = "ayoub.mahou"
        groups   = ["system:masters"]
      }
    ])
  }
  depends_on = [
    # Force the ConfigMap to wait until the EKS Node Group is fully created and active.
    # Replace 'module.eks.aws_eks_node_group.workers' with your actual node group resource path.
    # Note: If you have multiple node groups, list all of them here.
    module.eks
  ]
}
