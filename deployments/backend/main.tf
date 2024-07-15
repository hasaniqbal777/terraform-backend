# ##############################################################################
# Backend
# ##############################################################################
terraform {
  backend "s3" {
    key                  = "backend/terraform.tfstat"
    workspace_key_prefix = "backend"
  }
}

# ##############################################################################
# Terraform and Provider Requirements
# ##############################################################################
terraform {
  required_version = "~>1.9.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.31.0"
    }
  }
}

provider "aws" {
  region              = var.aws_region
  profile             = var.aws_profile
  allowed_account_ids = [var.aws_account]

  default_tags {
    # tags holds the default tags applied to all resources.
    # Individual resources should override Name and Function,
    # (as well as anything else they find appropriate).
    tags = {
      Name          = "Terraform Backend - ${terraform.workspace} - ${var.aws_region}"
      Group         = "Terraform Backend - ${terraform.workspace}"
      Owner         = "Hasan Iqbal"
      Description   = "Terraform Backend"
      Environment   = terraform.workspace
      Criticality   = "High"
      TTL           = "2021-06-01"
      MangedBy      = "terraform"
      Business_Unit = "Infrastructure"
      Region        = var.aws_region
    }
  }
}

data "aws_caller_identity" "current" {}

# ##############################################################################
# Variables
# ##############################################################################
variable "aws_account_name" {
  type = string
  validation {
    condition     = length(var.aws_account_name) > 0
    error_message = "Use the -var-file flag with the terraform command to specify the account configuration."
  }
}

variable "aws_account" {
  type = string
  validation {
    condition     = length(var.aws_account) > 0
    error_message = "Use the -var-file flag with the terraform command to specify the account configuration."
  }
}

variable "aws_region" {
  type = string
  validation {
    condition     = length(var.aws_region) > 0
    error_message = "Use the -var-file flag with the terraform command to specify the account configuration."
  }
}

variable "aws_profile" {
  type = string
  validation {
    condition     = length(var.aws_profile) > 0
    error_message = "Use the -var-file flag with the terraform command to specify the account configuration."
  }
}
