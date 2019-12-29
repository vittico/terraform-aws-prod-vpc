# Shared vars
variable "environment" {
  description = "This is the environment this vpc will belong to, defaults to dev, used for naming and tagging the resource"
  default     = ""
}

variable "name" {
  description = "The name of the app this VPC will host, as the environment string it is used to tag the resource and for easy identification"
  default     = "vpc"
}

# VPC vars
variable "cidr_block" {
  description = "The CIDR block for this vpc, defaults to 10.254.0.0/16, please change this, do not use the default as it is too wide"
  default     = "10.254.0.0/16"
}

variable "enabled_ipv6" {
  description = "Should we enable ipv6 on this? Will request a /56 block from amazon, defaults to false "
  default     = false
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults true"
  default     = true
}

variable "additional_tags" {
  description = "A set of extra tags for resources"
  default     = null
}

variable "depends" {
  description = "A list of resources we depend on"
  default     = null
}

variable "enable_classiclink" {
  description = "Enables classic link on this vpc"
  default     = false
}

variable "enable_classiclink_dns_support" {
  description = "Enables classic link dns on this vpc"
  default     = false
}

# Subnets vars

variable "az_count" {
  description = "How many az use to spread our load? defaults to 2"
  default     = 2
}