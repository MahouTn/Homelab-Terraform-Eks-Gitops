#Output the role ARN for annotating the k8s ServiceAccount
output "lb_controller_irsa_role_arn" {
  description = "ARN of the IAM role for aws-load-balancer-controller service account."
  value       = aws_iam_role.lb_controller_role.arn
}
