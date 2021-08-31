#Get information about AWS session
data "aws_caller_identity" "current" {}

#Get information about region
data "aws_region" "current" {}