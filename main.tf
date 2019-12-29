# VPC Block
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  # We should never need this again
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support

  assign_generated_ipv6_cidr_block = var.enabled_ipv6

  tags = merge(
    {
      Name               = "${var.name}-${var.environment}-vpc"
      Environment        = var.environment
      Terraform          = "True"
      AdditionalComments = "This resource created with Terraform using vittico's modules"
    },
    var.additional_tags
  )

  depends_on = [var.depends]
}

resource "aws_default_route_table" "rt" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = merge(
    {
      Name               = "${var.name}-${var.environment}-default-rt"
      Environment        = var.environment
      Terraform          = "True"
      AdditionalComments = "This resource created with Terraform using vittico's modules"
    },
    var.additional_tags
  )


}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id

  ingress {
    protocol    = -1
    self        = true
    from_port   = 0
    to_port     = 0
    description = "This vpc default sg"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name               = "${var.name}-${var.environment}-default-sg"
      Environment        = var.environment
      Terraform          = "True"
      AdditionalComments = "This resource created with Terraform using vittico's modules"
    },
    var.additional_tags
  )

}


resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    {
      Name               = "${var.name}-${var.environment}-default-acl"
      Environment        = var.environment
      Terraform          = "True"
      AdditionalComments = "This resource created with Terraform using vittico's modules"
    },
    var.additional_tags
  )

  lifecycle {
    ignore_changes = [subnet_ids]
  }

}

# Subnets blocks
module "available_zones" {
  source = "github.com/vittico/terraform-aws-utils-zones.git?ref=v1.0.0"
}


resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
  availability_zone = module.available_zones.zones.names[count.index]
  vpc_id            = aws_vpc.this.id

  tags = merge(
    {
      Name               = "${var.name}-${module.available_zones.zones.names[count.index]}-priv-0${count.index}-${var.environment}-subnet"
      Environment        = var.environment
      Terraform          = "True"
      AdditionalComments = "This resource created with Terraform using vittico's modules"
    },
    var.additional_tags
  )

}

resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, var.az_count + count.index)
  availability_zone       = module.available_zones.zones.names[count.index]
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name               = "${var.name}-${module.available_zones.zones.names[count.index]}-pub-0${count.index}-${var.environment}-subnet"
      Environment        = var.environment
      Terraform          = "True"
      AdditionalComments = "This resource created with Terraform using vittico's modules"
    },
    var.additional_tags
  )

}

# Internet gateway resource
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name               = "${var.name}-${var.environment}-igw"
      Environment        = var.environment
      Terraform          = "True"
      AdditionalComments = "This resource created with Terraform using vittico's modules"
    },
    var.additional_tags
  )
}

# Elastic IP resource
resource "aws_eip" "this" {
  count = var.az_count
  vpc   = true

  tags = merge(
    {
      Name               = "${var.name}-0${count.index}-${var.environment}-eip"
      Environment        = var.environment
      Terraform          = "True"
      AdditionalComments = "This resource created with Terraform using vittico's modules"
    },
    var.additional_tags
  )
}

# Route resource
resource "aws_route" "this" {
  route_table_id         = aws_vpc.this.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# NAT gateway
resource "aws_nat_gateway" "this" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.private.*.id, count.index)
  allocation_id = element(aws_eip.this.*.id, count.index)

  tags = merge(
    {
      Name               = "${var.name}-eip-0${count.index}-${var.environment}-natwg"
      Environment        = var.environment
      Terraform          = "True"
      AdditionalComments = "This resource created with Terraform using vittico's modules"
    },
    var.additional_tags
  )

}

# Route table resource
resource "aws_route_table" "this" {
  count  = var.az_count
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.this.*.id, count.index)
  }

  tags = merge(
    {
      Name               = "${var.name}-0${count.index}-${var.environment}-eip-rt"
      Environment        = var.environment
      Terraform          = "True"
      AdditionalComments = "This resource created with Terraform using vittico's modules"
    },
    var.additional_tags
  )

}

resource "aws_route_table_association" "this" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.this.*.id, count.index)
}



