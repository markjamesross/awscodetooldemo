#Terraform Remote State Locking
resource "aws_dynamodb_table" "tfstate_lock" {
  name           = "TF-State-Lock"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = merge({ Name = "TF-State-Lock" }, var.tags)
}