variable "role_name" {
  description = "The name of the IAM role to be created"
  type        = string
  default     = "app-role"
}

variable "policy_name" {
  description = "The name of the IAM policy to be created"
  type        = string
  default     = "app-policy"
}

variable "assume_role_policy" {
  description = "JSON-formatted policy document defining who can assume the IAM role"
  type        = string
}

variable "policy_document" {
  description = "JSON-formatted policy document defining permissions for the IAM role"
  type        = string
}
