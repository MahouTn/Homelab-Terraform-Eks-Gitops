# Fetch the current AWS Account ID
data "aws_caller_identity" "current" {}

# Fetch the EKS Cluster OIDC URL from the module named 'eks'
locals {
  oidc_issuer = module.eks.oidc_issuer_url
}

# 1. IAM Role for the EBS CSI Driver Service Account
resource "aws_iam_role" "ebs_csi_driver_role" {
  name = "EksEbsCsiDriverRole"

  # Trust policy that securely allows the K8s ServiceAccount (from OIDC) to assume this role.
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
            # Only allow the specific ServiceAccount in the kube-system namespace to assume the role
            "${trimprefix(local.oidc_issuer, "https://")}:sub" : "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      },
    ]
  })
}

# 2. Inline Policy: Guaranteed to work since managed policies failed (404)
resource "aws_iam_role_policy" "ebs_csi_driver_inline_policy" {
  name = "EBS_CSI_Driver_Inline_Policy"
  role = aws_iam_role.ebs_csi_driver_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateVolume",
          "ec2:DeleteVolume",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:ModifyVolume",
          "ec2:CopySnapshot",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeSnapshots",
          "ec2:DescribeVolumesModifications",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      },
    ]
  })
}

# 3. Output the ARN, which we need for the Helm command annotation
output "ebs_csi_irsa_role_arn" {
  description = "The ARN of the IAM Role for the EBS CSI Driver Service Account."
  value       = aws_iam_role.ebs_csi_driver_role.arn
}
