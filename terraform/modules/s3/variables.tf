variable "bucket_name" {
  description = "The name of your bucket"
  type        = string
}

variable "create_bucket" {
  description = "Controls if S3 bucket should be created"
  type        = bool
  default     = true
}

variable "versioning" {
  description = "Map containing versioning configuration."
  type        = map(string)
  default     = {}
}

variable "tags" {
  default     = {}
  description = "A mapping of tags to assign to the object."
  type        = map(string)
}
