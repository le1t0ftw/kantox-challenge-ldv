variable "repository_name" {
  description = "The name of the ECR Repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of 'MUTABLE' or 'IMMUTABLE'"
  type        = string
  default     = "MUTABLE"
}

variable "tags" {
  description = "A map of tags to assign to the repository"
  type        = map(string)
  default     = {}
}