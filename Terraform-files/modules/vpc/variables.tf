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

variable "internet_route" {
  type        = string
  description = "route to the internet 0.0.0.0/0"
  default     = "0.0.0.0/0"
}