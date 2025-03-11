# Resource to create an AWS Systems Manager (SSM) Parameter Store entry
resource "aws_ssm_parameter" "this" {
  name   = var.param_name   # The name assigned to the parameter in SSM Parameter Store
  value  = var.param_value  # The value stored in the parameter
  type   = var.param_type   # The type of the parameter (String, StringList, or SecureString)
}
