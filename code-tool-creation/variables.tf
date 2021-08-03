variable "tags" {
  description = "Tags to apply to resources"
  type        = map(any)
  default = {
    Environment = "Code Tool Demo"
  }
}

variable "repo_name" {
  description = "Name of repo"
  type        = string
  default     = "demo-repo"
}

variable "repo_branch" {
  description = "Default branch of repo"
  type        = string
  default     = "main"
}

variable "pipeline_role_name" {
  description = "Name of IAM role for the pipeline"
  type        = string
  default     = "pipeline-role"
}

variable "pipeline_policy_name" {
  description = "Name of IAM policy for the pipeline"
  type        = string
  default     = "pipeline-policy"
}

variable "codebuild_role_name" {
  description = "Name of IAM role for the CodeBuild"
  type        = string
  default     = "codebuild-role"
}

variable "codebuild_policy_name" {
  description = "Name of IAM policy for CodeBuild"
  type        = string
  default     = "codebuild-policy"
}

variable "image_repo_name" {
  description = "Name of container image repo"
  type        = string
  default     = "terraform"
}

output "image_repo_url" {
  value = aws_ecr_repository.image_repo.repository_url
}

output "image_repo_arn" {
  value = aws_ecr_repository.image_repo.arn
}