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

## ECR Module Variables ##
variable "api_repository_name" {
  description = "The name of the ECR Repository"
  type        = string
}

variable "api_image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of 'MUTABLE' or 'IMMUTABLE'"
  type        = string
  default     = "MUTABLE"
}

variable "api_tags" {
  description = "A map of tags to assign to the repository"
  type        = map(string)
  default     = {}
}


variable "aux_repository_name" {
  description = "The name of the ECR Repository"
  type        = string
}

variable "aux_image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of 'MUTABLE' or 'IMMUTABLE'"
  type        = string
  default     = "MUTABLE"
}

variable "aux_tags" {
  description = "A map of tags to assign to the repository"
  type        = map(string)
  default     = {}
}

