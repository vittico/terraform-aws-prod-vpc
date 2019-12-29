provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source       = "../../"
  cidr_block   = "192.168.0.0/16"
  name         = "test-module"
  environment  = "dev"
  enabled_ipv6 = true

  az_count = 2


  additional_tags = merge(
    {
      extra = "extra tag"
    }
  )

}