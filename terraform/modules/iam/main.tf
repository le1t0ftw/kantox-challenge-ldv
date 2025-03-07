resource "aws_iam_role" "this_role" {
  name = var.role_name

  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "this_policy" {
  name        = var.policy_name
  description = "Policy for accessing resources"
  
  policy = var.policy_document
}

resource "aws_iam_role_policy_attachment" "this_attach" {
  role       = aws_iam_role.this_role.name
  policy_arn = aws_iam_policy.this_policy.arn
}