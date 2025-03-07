output "bucket_name" {
  description = "Nombre del bucket creado"
  value       = aws_s3_bucket.app_bucket.bucket
}