resource "aws_ssm_parameter" "example" {
  name  = "example-ssm-param"
  type  = "String"
  value = "This is the example value stored in SSM parameter stored for Code build test"
}