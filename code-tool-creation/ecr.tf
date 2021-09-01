#Create Elastic Container Registry Repository
resource "aws_ecr_repository" "image_repo" {
  name                 = var.image_repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
  tags = merge({ Name = var.image_repo_name }, var.tags)
}

#Null resource to create and upload docker image to ECR
resource "null_resource" "create_ecr_image2" {
  depends_on = [
    aws_ecr_repository.image_repo
  ]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
cd ../docker-image
sudo docker build . -t terraform
ECR_PW=$(aws ecr get-login-password --region ${data.aws_region.current.name})
sudo docker login --username AWS --password $ECR_PW ${data.aws_caller_identity.current.account_id}.dkr.${data.aws_region.current.name}.amazonaws.com
unset ECR_PW
sudo docker tag terraform:latest ${aws_ecr_repository.image_repo.repository_url}:latest
sudo docker push ${aws_ecr_repository.image_repo.repository_url}:latest
cd ..
EOF
  }
}