output "s3_bucket" {
  description = "Nombre del bucket S3"
  value       = module.s3.bucket_name
}

output "parameter_name" {
  description = "Nombre del parámetro en AWS Parameter Store"
  value       = module.parameter_store.param_name
}

output "iam_role" {
  description = "ARN del rol IAM"
  value       = module.app_role.iam_role_arn
}