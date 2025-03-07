output "iam_role_arn" {
  description = "ARN del rol IAM"
  value       = aws_iam_role.app_role.arn
}