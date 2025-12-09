variable "name" {
  type        = string
  description = "Prefix for network resources."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC."
}

variable "public_subnets" {
  description = "Map of public subnet definitions keyed by suffix."
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  description = "Map of private subnet definitions keyed by suffix."
  type = map(object({
    cidr = string
    az   = string
  }))
}
