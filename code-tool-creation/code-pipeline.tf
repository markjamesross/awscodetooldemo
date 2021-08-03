#IAM role for Code Pipeline
resource "aws_iam_role" "codepipeline_role" {
  name               = var.pipeline_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
  path               = "/"
  tags               = merge({ Name = var.pipeline_role_name }, var.tags)
}

#IAM policy for Code Pipeline
resource "aws_iam_policy" "codepipeline_policy" {
  name        = var.pipeline_policy_name
  description = "Policy to allow codepipeline to execute"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject", "s3:GetObjectVersion", "s3:PutObject",
        "s3:GetBucketVersioning"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.artifact_bucket.arn}/*"
    },
    {
      "Action" : [
        "codebuild:StartBuild", "codebuild:BatchGetBuilds",
        "cloudformation:*",
        "iam:PassRole"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action" : [
        "ecs:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action" : [
        "codecommit:CancelUploadArchive",
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:GetUploadArchiveStatus",
        "codecommit:UploadArchive"
      ],
      "Effect": "Allow",
      "Resource": "${aws_codecommit_repository.repo.arn}"
    }
  ]
}
EOF
  tags        = merge({ Name = var.pipeline_policy_name }, var.tags)
}

#Attach Code Pipeline policy to role
resource "aws_iam_role_policy_attachment" "codepipeline-attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

#Create Code Pipeline
resource "aws_codepipeline" "pipeline" {
  depends_on = [
    aws_codebuild_project.codebuild_plan,
    aws_codebuild_project.codebuild_apply,
    aws_codebuild_project.codebuild_validate,
    aws_codebuild_project.codebuild_security,
    aws_codecommit_repository.repo
  ]
  name     = "${var.repo_name}-${var.repo_branch}-Pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  artifact_store {
    location = aws_s3_bucket.artifact_bucket.bucket
    type     = "S3"
  }
  tags = merge({ Name = "${var.repo_name}-${var.repo_branch}-Pipeline" }, var.tags)

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeCommit"
      output_artifacts = ["SourceOutput"]
      run_order        = 1
      configuration = {
        RepositoryName       = var.repo_name
        BranchName           = var.repo_branch
        PollForSourceChanges = "true"
      }
    }
  }
  stage {
    name = "Validate"
    action {
      name             = "Validate"
      category         = "Build"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["ValidateOutput"]
      run_order        = 4
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_validate.id
      }
    }
  }

  stage {
    name = "Security"
    action {
      name             = "Security"
      category         = "Build"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      run_order        = 4
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_security.id
      }
    }
  }

  stage {
    name = "Plan"
    action {
      name             = "Plan"
      category         = "Build"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      run_order        = 4
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_plan.id
      }
    }
  }

  stage {
    name = "Approval"
    action {
      name             = "Approval"
      category         = "Approval"
      run_order        = 5
      owner            = "AWS"
      version          = "1"
      provider         = "Manual"
    }
  }

  stage {
    name = "Apply"
    action {
      name             = "Apply"
      category         = "Build"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      run_order        = 6
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_apply.id
      }
    }
  }
}