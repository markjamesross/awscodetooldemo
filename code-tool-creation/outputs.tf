output "repo_id" {
  value       = aws_codecommit_repository.repo.repository_id
  description = "Repository ID"
}

output "repo_arn" {
  value       = aws_codecommit_repository.repo.arn
  description = "Repository ARN"
}

output "repo_clone_url_http" {
  value       = aws_codecommit_repository.repo.clone_url_http
  description = "Repository clone url http"
}

output "repo_clone_url_ssh" {
  value       = aws_codecommit_repository.repo.clone_url_ssh
  description = "Repository clone url ssh"
}

output "registry_id" {
  value       = aws_ecr_repository.image_repo.registry_id
  description = "ECR Repo ID"
}

output "registry_url" {
  value       = aws_ecr_repository.image_repo.repository_url
  description = "ECR Repo URL"
}