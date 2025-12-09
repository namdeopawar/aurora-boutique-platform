variable "name" {
  type        = string
  description = "Prefix for EKS resources."
}

variable "region" {
  type        = string
  description = "AWS region."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the cluster."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for node groups."
}

variable "cluster_version" {
  type        = string
  default     = "1.29"
  description = "Kubernetes version."
}

variable "system_instance_type" {
  type        = string
  default     = "t3.medium"
  description = "Instance type for system node group."
}

variable "workload_instance_type" {
  type        = string
  default     = "t3.large"
  description = "Instance type for workload node group."
}

variable "workload_min" {
  type        = number
  default     = 1
  description = "Min nodes for workload group."
}

variable "workload_max" {
  type        = number
  default     = 4
  description = "Max nodes for workload group."
}

variable "workload_desired" {
  type        = number
  default     = 2
  description = "Desired nodes for workload group."
}

variable "oidc_thumbprint" {
  type        = string
  description = "Thumbprint for EKS OIDC provider (per AWS region)."
  default     = "9e99a48a9960b14926bb7f3b02e22da0afd10df6"
}
