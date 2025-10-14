variable "cidr_vpc" {
  type        = string
  description = "vpc cidr"
}

variable "cidr_public_subnets" {
  type        = list(any)
  description = "cidr for the public subnets"
}


variable "cidr_private_subnets" {
  type        = list(any)
  description = "cidr for the private subnets"
}

variable "azs" {
  type        = list(any)
  description = "availability zones"
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "internet" {
  description = "The CIDR block representing all internet traffic"
  type        = string
  default     = "0.0.0.0/0"
}