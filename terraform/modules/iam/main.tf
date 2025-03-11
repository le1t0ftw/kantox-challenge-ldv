# Resource to create an IAM role
resource "aws_iam_role" "this_role" {
  name = var.role_name  # Name of the IAM role

  assume_role_policy = var.assume_role_policy  # Policy that defines who can assume this role (provided as a JSON document)
}

# Resource to create an IAM policy
resource "aws_iam_policy" "this_policy" {
  name        = var.policy_name  # Name of the IAM policy
  description = "Policy for accessing resources"  # Description of the policy
  
  policy = var.policy_document  # JSON document defining the permissions granted by this policy
}

# Resource to attach the IAM policy to the IAM role
resource "aws_iam_role_policy_attachment" "this_attach" {
  role       = aws_iam_role.this_role.name  # The IAM role to which the policy will be attached
  policy_arn = aws_iam_policy.this_policy.arn  # The ARN of the IAM policy to be attached
}
