variable "name" {
  type        = string
  description = "Base name for resources."
}

variable "region" {
  type        = string
  description = "Region for resources."
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR."
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr_a" {
  type        = string
  default     = "10.10.1.0/24"
  description = "Public subnet CIDR AZ a."
}

variable "private_subnet_cidr_a" {
  type        = string
  default     = "10.10.101.0/24"
  description = "Private subnet CIDR AZ a."
}
