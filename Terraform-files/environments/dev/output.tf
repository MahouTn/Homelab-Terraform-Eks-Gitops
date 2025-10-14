output "cluster_name" {
  value       = module.eks.cluster_name # This references the output you just created
  description = "Name of the EKS cluster for kubectl configuration."
}

output "kubeconfig_command" {
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
  description = "Command to configure your local kubectl for access."
}
