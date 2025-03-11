output "ssm_parameter_arn" {
  description = "The ARN of the created AWS SSM Parameter."
  value       = aws_ssm_parameter.this.arn
}

output "ssm_parameter_name" {
  description = "The name of the created AWS SSM Parameter."
  value       = aws_ssm_parameter.this.name
}