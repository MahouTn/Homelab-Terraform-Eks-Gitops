variable "public_subnet_ids" {
  type        = list(string)
  description = "list of public subnets"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "list of private subnets"
}

variable "internet" {
  type        = string
  default     = "0.0.0.0/0"
  description = "public_cidr"

}

variable "cluster_name" {
  description = "The name for the EKS cluster and related resources."
  type        = string
  default     = "homelab-eks" # Setting a default is often convenient
}

variable "vpc_id" {
  type = string
}

variable "ssh_key_name" {
  description = "The name of the EC2 Key Pair to use for SSH access to EKS worker nodes."
  type        = string
}
