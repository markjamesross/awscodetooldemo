#CodeCommit Repo
resource "aws_codecommit_repository" "repo" {
  repository_name = var.repo_name
  description     = "This is a demo CodeCommit repo"
  default_branch  = var.repo_branch

  tags = merge({ Name = var.repo_name }, var.tags)
}

