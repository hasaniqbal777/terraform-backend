# ##############################################################################
# IAM - S3 Policy
# ##############################################################################
resource "aws_iam_policy" "s3_terraform_state_policy" {
  name        = var.aws_region == "us-east-1" ? "s3-terraform-state-policy" : "s3-terraform-state-policy-${var.aws_region}"
  path        = "/"
  description = "Policy giving roles permission to access the S3 Terraform State Bucket"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "s3:ListBucket",
          "Resource" : [
            "${aws_s3_bucket.terraform_state_bucket.arn}",
            "${aws_s3_bucket.terraform_state_bucket.arn}/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
          "Resource" : "${aws_s3_bucket.terraform_state_bucket.arn}/state/terraform.tfstate"
        }
      ]
  })
}

# ##############################################################################
# IAM - DynamoDB Policy
# ##############################################################################
resource "aws_iam_policy" "dynamodb_terraform_lock_policy" {
  name        = var.aws_region == "us-east-1" ? "dynamodb-terraform-lock-policy" : "dynamodb-terraform-lock-policy-${var.aws_region}"
  path        = "/"
  description = "Policy giving roles permission to access the DynamoDB Lock Table"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:DescribeTable",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:DeleteItem"
          ],
          "Resource" : "${aws_dynamodb_table.terraform_lock_table.arn}"
        }
      ]
    }
  )
}