provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source     = "../../"
  cidr_block = "192.168.50.0/24"

  additional_tags = merge(
    {
      extra = "extra tag"
    }
  )

}