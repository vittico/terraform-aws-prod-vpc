resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  # We should never need this again
  enable_classiclink             = false
  enable_classiclink_dns_support = false

  assign_generated_ipv6_cidr_block = var.enabled_ipv6

  tags = merge(
    {
      Name               = "${var.name}-${var.environment}"
      Environment        = var.environment
      Terraform          = "True"
      AdditionalComments = "This resource created with Terraform using vittico's modules"
    },
    var.additional_tags
  )

  depends_on = [var.depends]
}