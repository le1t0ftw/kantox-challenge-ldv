output "s3_bucket" {
  description = "ARN of the provisioned S3 bucket"
  value       = module.s3.arn
}

output "ssm_parameter_arn" {
  description = "The ARN of the created AWS SSM Parameter."
  value       = module.parameter_store.ssm_parameter_arn
}

output "ssm_parameter_name" {
  description = "The name of the created AWS SSM Parameter."
  value       = module.parameter_store.ssm_parameter_name
}

output "iam_role" {
  description = "ARN of the IAM role assigned to the application"
  value       = module.app_role.iam_role_arn
}
