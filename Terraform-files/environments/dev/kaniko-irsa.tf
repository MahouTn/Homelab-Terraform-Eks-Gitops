# Filename: kaniko-irsa.tf
# Description: Creates the IAM Role and Policy necessary for the Kaniko-based
#              Jenkins agent to securely log in and push Docker images to ECR,
#              using the IAM Roles for Service Accounts (IRSA) method.

# Fetch the EKS Cluster OIDC URL from the EKS module
data "aws_eks_cluster" "eks_cluster" {
  # This references the 'local.cluster_name' defined in main.tf
  name = local.cluster_name
}


# 1. IAM Policy: Grants permissions to access ECR and pull the Kaniko image
resource "aws_iam_policy" "kaniko_ecr_policy" {
  name        = "KanikoECRPolicy-${local.cluster_name}"
  description = "Allows Kaniko to authenticate and push to ECR."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # --- STATEMENT 1 (CRITICAL FIX): GetAuthorizationToken must use Resource: "*" ---
      {
        "Sid" : "ECRAuthToken",
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken"
        ],
        "Resource" : "*"
      },
      # --- STATEMENT 2: Repository actions constrained to the repository ARN ---
      {
        "Sid" : "ECRPushActions",
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        # Restrict access to all ECR repositories in the current region/account
        "Resource" : "arn:aws:ecr:${data.aws_eks_cluster.eks_cluster.region}:${data.aws_caller_identity.current.account_id}:repository/*"
      },
    ]
  })
}

# 2. IAM Role: Assumable by the Kaniko Kubernetes Service Account
resource "aws_iam_role" "kaniko_irsa_role" {
  name = "KanikoECRPushRole-${local.cluster_name}"

  # The Trust Policy must allow the OIDC provider (EKS) to assume this role.
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          # FIX: Apply trimprefix here to ensure the Federated principal is a valid domain name
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${trimprefix(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer,"https://")}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            # Note: The issuer URL in the condition check (OIDC provider ARN) *must* include the https:// prefix.
            "${trimprefix(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://")}:sub" : "system:serviceaccount:ci-cd:kaniko-sa"
            "${trimprefix(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://")}:aud" = "sts.amazonaws.com"
          }
        }
      },
    ]
  })
}

# 3. Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "kaniko_policy_attach" {
  policy_arn = aws_iam_policy.kaniko_ecr_policy.arn
  role       = aws_iam_role.kaniko_irsa_role.name
}

# 4. Output the ARN for the Kubernetes Service Account annotation
output "kaniko_role_arn_output" {
  description = "The ARN of the IAM Role for the Kaniko ECR Push Service Account."
  value       = aws_iam_role.kaniko_irsa_role.arn
}
