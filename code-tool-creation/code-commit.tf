#CodeCommit Repo
resource "aws_codecommit_repository" "repo" {
  repository_name = var.repo_name
  description     = "This is a demo CodeCommit repo"
  default_branch  = var.repo_branch

  tags = merge({ Name = var.repo_name }, var.tags)
}

#Null resource to break out to command line and upload code to code commit
resource "null_resource" "upload_to_codecommit" {
  depends_on = [
    aws_codecommit_repository.repo,
    null_resource.create_ecr_image2,
    local_file.global_vars
  ]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
cd ../..
git clone ${aws_codecommit_repository.repo.clone_url_http}
cd ${var.repo_name}
git init .
git checkout -B main
cp ../awscodetooldemo/demo-repo/* . -fr
git add --all
git commit -am "commit demo code to repo"
git push --set-upstream origin main
EOF
  }
}
