module "vpc" {
  source               = "../../modules/vpc"
  cidr_vpc             = var.cidr_vpc
  cidr_public_subnets  = var.cidr_public_subnets
  cidr_private_subnets = var.cidr_private_subnets
  azs                  = var.azs
}

module "eks" {
  source = "../../modules/eks-cluster" # Assuming your EKS module is here

  # --- Required VPC and Subnet IDs ---
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  ssh_key_name = "homelab-eks"


}





