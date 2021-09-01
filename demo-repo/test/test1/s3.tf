#Create a demo S3 bucket
#tfsec:ignore:AWS002 Ignores the need to have a logging bucket enabled in security checks
resource "aws_s3_bucket" "example" {
  #Give bucket name with AWS account ID prefix
  bucket_prefix = "${data.aws_caller_identity.current.account_id}-demo-bucket"
  acl           = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = { 
    Name = "${data.aws_caller_identity.current.account_id}-demo-bucket" 
  }
}

#Apply block public access
resource "aws_s3_bucket_public_access_block" "example" {
	bucket = aws_s3_bucket.example.id
	block_public_acls   = true
	block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = true
}