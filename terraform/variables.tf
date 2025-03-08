## Bucket Variables ##

variable "bucket_name" {
  description = "Nombre del bucket S3"
  type        = string
}

## Paramter Store Variables ##

variable "param_name" {
  description = "Nombre del parámetro"
  type        = string
}

variable "param_value" {
  description = "Valor del parámetro"
  type        = string
}

## Iam Module Variables ##

variable "app_iam_config" {
  description = "Configuration map for IAM role and policy"
  type = map(any)
}

variable "git_iam_config" {
  description = "Configuration map for IAM role and policy"
  type = map(any)
}

