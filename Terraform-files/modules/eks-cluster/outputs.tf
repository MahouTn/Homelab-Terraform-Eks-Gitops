output "cluster_name" {
  value       = aws_eks_cluster.main.name
  description = "Cluster name"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.main.endpoint
  description = "Cluster endpoint"
}

output "cluster_certificate" {
  value       = aws_eks_cluster.main.certificate_authority[0].data
  description = "Cluster certificate"
}

output "node_role_arn" {
  # Replace aws_iam_role.node_role with the correct IAM Role resource name
  # used by your worker node group(s).
  value       = aws_iam_role.node.arn
  description = "The ARN of the IAM Role used by EKS Node Groups."
}

output "oidc_issuer_url" {
  description = "..."
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}