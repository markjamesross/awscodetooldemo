#Role for Codebuild
resource "aws_iam_role" "codebuild_role" {
  name               = var.codebuild_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
  path               = "/"
  tags               = merge({ Name = var.codebuild_role_name }, var.tags)
}

#Policy for CodeBuild
resource "aws_iam_policy" "codebuild_policy" {
  name        = var.codebuild_policy_name
  description = "Policy to allow codebuild to execute build spec"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ecr:GetAuthorizationToken"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.artifact_bucket.arn}/*"
    },
    {
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Effect": "Allow",
      "Resource": "${aws_ecr_repository.image_repo.arn}"
    },
    {
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Effect": "Allow",
      "Resource": "${aws_ecr_repository.image_repo.arn}"
    },
    {
      "Action": [
        "ssm:GetParameters"
      ],
      "Effect": "Allow",
      "Resource": "${aws_ssm_parameter.example.arn}"
    }
  ]
}
EOF
  tags        = merge({ Name = var.codebuild_policy_name }, var.tags)
}

#Attach CodeBuild policy to role
resource "aws_iam_role_policy_attachment" "codebuild-attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

#Codebuild Projects
resource "aws_codebuild_project" "codebuild_plan" {
  depends_on = [
    aws_codecommit_repository.repo,
    aws_ecr_repository.image_repo
  ]
  name         = "codebuild-${var.repo_name}-${var.repo_branch}-plan"
  service_role = aws_iam_role.codebuild_role.arn
  tags         = merge({ Name = "codebuild-${var.repo_name}-${var.repo_branch}-plan" }, var.tags)
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "${aws_ecr_repository.image_repo.repository_url}:latest"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "SERVICE_ROLE"
  }
  source {
    type = "CODEPIPELINE"
    buildspec = "pipelines/buildspec-plan.yml"
  }
}       

resource "aws_codebuild_project" "codebuild_apply" {
  depends_on = [
    aws_codecommit_repository.repo,
    aws_ecr_repository.image_repo
  ]
  name         = "codebuild-${var.repo_name}-${var.repo_branch}-apply"
  service_role = aws_iam_role.codebuild_role.arn
  tags         = merge({ Name = "codebuild-${var.repo_name}-${var.repo_branch}-apply" }, var.tags)
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "${aws_ecr_repository.image_repo.repository_url}:latest"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "SERVICE_ROLE"
  }
  source {
    type = "CODEPIPELINE"
    buildspec = "pipelines/buildspec-apply.yml"
  }
}        

resource "aws_codebuild_project" "codebuild_validate" {
  depends_on = [
    aws_codecommit_repository.repo,
    aws_ecr_repository.image_repo
  ]
  name         = "codebuild-${var.repo_name}-${var.repo_branch}-validate"
  service_role = aws_iam_role.codebuild_role.arn
  tags         = merge({ Name = "codebuild-${var.repo_name}-${var.repo_branch}-validate" }, var.tags)
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "${aws_ecr_repository.image_repo.repository_url}:latest"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "SERVICE_ROLE"
  }
  source {
    type = "CODEPIPELINE"
    buildspec = "pipelines/buildspec-validate.yml"
  }
}   

resource "aws_codebuild_project" "codebuild_security" {
  depends_on = [
    aws_codecommit_repository.repo,
    aws_ecr_repository.image_repo
  ]
  name         = "codebuild-${var.repo_name}-${var.repo_branch}-secuirty"
  service_role = aws_iam_role.codebuild_role.arn
  tags         = merge({ Name = "codebuild-${var.repo_name}-${var.repo_branch}-secuirty" }, var.tags)
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "${aws_ecr_repository.image_repo.repository_url}:latest"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "SERVICE_ROLE"
  }
  source {
    type = "CODEPIPELINE"
    buildspec = "pipelines/buildspec-security.yml"
  }
}   