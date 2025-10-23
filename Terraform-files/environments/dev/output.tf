output "cluster_name" {
  value       = module.eks.cluster_name # This references the output you just created
  description = "Name of the EKS cluster for kubectl configuration."
}

output "kubeconfig_command" {
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
  description = "Command to configure your local kubectl for access."
}

output "lb_controller_irsa_role_arn" {
  description = "ARN of the IAM role for aws-load-balancer-controller service account (forwarded from lb_iam child module)."
  value       = module.lb_iam.lb_controller_irsa_role_arn
}


# 4. Output the ARN for the Kubernetes Service Account annotation
output "kaniko_irsa_role_arn" {
  description = "The ARN of the IAM Role for the Kaniko ECR Push Service Account."
  value       = aws_iam_role.kaniko_irsa_role.arn
}