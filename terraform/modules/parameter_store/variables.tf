variable "param_name" {
  description = "The name of the AWS SSM Parameter Store entry."
  type        = string

  validation {
    condition     = length(var.param_name) > 0
    error_message = "Parameter name must not be empty."
  }
}

variable "param_value" {
  description = "The value assigned to the AWS SSM Parameter Store entry."
  type        = string

  validation {
    condition     = length(var.param_value) > 0
    error_message = "Parameter value must not be empty."
  }
}

variable "param_type" {
  description = "The type of the AWS SSM Parameter Store entry (String, StringList, or SecureString)."
  type        = string
  default     = "String"

  validation {
    condition     = contains(["String", "StringList", "SecureString"], var.param_type)
    error_message = "Valid values for param_type are 'String', 'StringList', or 'SecureString'."
  }
}