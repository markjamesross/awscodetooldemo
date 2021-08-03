#Create S3 bucket for artifacts
resource "aws_s3_bucket" "artifact_bucket" {
  #Give bucket name with AWS account ID prefix
  bucket        = "${data.aws_caller_identity.current.account_id}-artifact-bucket"
  acl           = "private"
  force_destroy = true
  #server_side_encryption_configuration {
  #  rule {
  #    apply_server_side_encryption_by_default {
  #      sse_algorithm = "aws:kms"
  #    }
  #  }
  #}
  tags = merge({ Name = "${data.aws_caller_identity.current.account_id}-artifact-bucket" }, var.tags)
}