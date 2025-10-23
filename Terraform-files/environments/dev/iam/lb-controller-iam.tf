data "aws_caller_identity" "current" {}

# now accept cluster_name and oidc_issuer as inputs instead of referencing module.eks
variable "cluster_name" {
  type = string
}

variable "oidc_issuer" {
  type = string
}

locals {
  cluster_name = var.cluster_name
  oidc_issuer  = var.oidc_issuer
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "sa_namespace" {
  type    = string
  default = "kube-system"
}

variable "sa_name" {
  type    = string
  default = "aws-load-balancer-controller"
}

resource "aws_iam_policy" "lb_controller_policy" {
  name   = "AWSLoadBalancerControllerIAMPolicy-${local.cluster_name}"
  policy = file("${path.module}/aws-lb-controller-policy.json")
}

resource "aws_iam_role" "lb_controller_role" {
  name = "eks-alb-controller-role-${local.cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${trimprefix(local.oidc_issuer, "https://")}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${trimprefix(local.oidc_issuer, "https://")}:sub" = "system:serviceaccount:${var.sa_namespace}:${var.sa_name}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lb_controller_attach" {
  role       = aws_iam_role.lb_controller_role.name
  policy_arn = aws_iam_policy.lb_controller_policy.arn
}

