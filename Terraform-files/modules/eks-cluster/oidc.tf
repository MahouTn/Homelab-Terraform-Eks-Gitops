# oidc.tf

resource "aws_iam_openid_connect_provider" "eks" {
  # The URL of the OIDC issuer is a unique identifier from your EKS cluster
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer

  # This is the client ID used by AWS STS to interact with the provider
  client_id_list = ["sts.amazonaws.com"]

  # The thumbprint is required by the AWS API. This value is a common, 
  # publicly known thumbprint for the Amazon root CA used by EKS.
  # Note: Terraform often automatically fetches the thumbprint, but explicitly 
  # defining a known working one ensures deployment stability.
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]

  # The OIDC provider must be created only after the cluster exists and exposes its OIDC issuer URL.
  depends_on = [
    aws_eks_cluster.main
  ]
}