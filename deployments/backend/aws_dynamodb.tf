# ##############################################################################
# DynamoDB - State Locking
# ##############################################################################
resource "aws_dynamodb_table" "terraform_lock_table" {
  name           = var.aws_region == "us-east-1" ? "${var.aws_account_name}-terraform-lock" : "${var.aws_account_name}-terraform-lock-${var.aws_region}"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
