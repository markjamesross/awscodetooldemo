#Use template to make global vars file with relevant inputs
data "template_file" "global_vars" {
  template = "${file("${path.module}/source/global.tfvars")}"
  vars = {
    pipeline_role = aws_iam_role.codebuild_role.id
    account_id = data.aws_caller_identity.current.account_id
    tf_bucket_name = aws_s3_bucket.tf_bucket.id
    tf_dynamodb_table = aws_dynamodb_table.tfstate_lock.name
    region = data.aws_region.current.name
  }
}
#Create file and store in demo repo
resource "local_file" "global_vars" {
    content     = data.template_file.global_vars.rendered
    filename = "${path.module}/../demo-repo/global.tfvars"
}