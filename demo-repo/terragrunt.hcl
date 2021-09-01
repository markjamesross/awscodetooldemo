locals {
  account_id = run_cmd("${get_parent_terragrunt_dir()}/get_vars.sh", "account_id")
  tf_bucket_name = run_cmd("${get_parent_terragrunt_dir()}/get_vars.sh", "tf_bucket_name")
  tf_dynamodb_table = run_cmd("${get_parent_terragrunt_dir()}/get_vars.sh", "tf_dynamodb_table")
  pipeline_role = run_cmd("${get_parent_terragrunt_dir()}/get_vars.sh", "pipeline_role")
  region = run_cmd("${get_parent_terragrunt_dir()}/get_vars.sh", "region")
}

remote_state {
  backend = "s3"

  config = {
    encrypt        = true
    bucket         = "${local.tf_bucket_name}"
    key            = "${local.account_id}/${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.region}"
    role_arn       = "arn:aws:iam::${local.account_id}:role/${local.pipeline_role}"
    dynamodb_table = "${local.tf_dynamodb_table}"
    s3_bucket_tags = {
      "Name"               = "${local.tf_bucket_name}"
      "Managed_by"         = "terraform"
    }
    dynamodb_table_tags = {
      "Name"               = "${local.tf_dynamodb_table}"
      "Managed_by"         = "terraform"
    }
  }
}

dependencies {
  paths = []
}

terraform {
  extra_arguments "modules" {
    commands  = ["get"]
    arguments = ["-update=true"]
  }

  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=20m"]
  }

  extra_arguments "backups" {
    commands  = ["apply"]
    arguments = ["-backup=-"]
  }

  extra_arguments "tfvars" {
    commands = ["init", "plan", "apply", "destroy"]
    optional_var_files = [
      "${get_parent_terragrunt_dir()}/global.tfvars"
    ]
    arguments = ["-compact-warnings"]
  }
}