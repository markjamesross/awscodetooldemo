#Create Elastic Container Registry Repository
resource "aws_ecr_repository" "image_repo" {
  name                 = var.image_repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  #encryption_configuration {
  #  encryption_type = "KMS"
  #}
  tags = merge({ Name = var.image_repo_name }, var.tags)
}