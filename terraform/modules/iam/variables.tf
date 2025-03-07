variable "role_name" {
  description = "The name of the IAM role"
  type        = string
  default     = "app-role"
}

variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
  default     = "app-policy"
}

variable "assume_role_policy" {
  description = "The assume role policy document in JSON format"
  type        = string
}

variable "policy_document" {
  description = "The policy document in JSON format"
  type        = string
}