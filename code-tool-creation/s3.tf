#Create S3 bucket for artifacts
resource "aws_s3_bucket" "artifact_bucket" {
  #Give bucket name with AWS account ID prefix
  bucket_prefix = "${data.aws_caller_identity.current.account_id}-artifact-bucket"
  acl           = "private"
  force_destroy = true
  tags = merge({ Name = "${data.aws_caller_identity.current.account_id}-artifact-bucket" }, var.tags)
}

#Terraform Remote State
#Create S3 bucket for artifacts
resource "aws_s3_bucket" "tf_bucket" {
  #Give bucket name with AWS account ID prefix
  bucket_prefix = "tfstate-bucket"
  acl           = "private"
  force_destroy = true
  tags = merge({ Name = "tfstate-bucket" }, var.tags)
}