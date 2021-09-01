provider "aws" {
  region = var.region

  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/${var.pipeline_role}"
  }
}

terraform {
  backend "s3" {}
}
