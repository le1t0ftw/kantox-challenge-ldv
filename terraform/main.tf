# Module to create an S3 bucket
module "s3" {
  source      = "./modules/s3"  # Path to the S3 module
  bucket_name = var.bucket_name  # The name assigned to the S3 bucket
}

# Module to create an AWS Systems Manager Parameter Store entry
module "parameter_store" {
  source      = "./modules/parameter_store"  # Path to the Parameter Store module
  param_name   = var.param_name  # Name of the parameter to be stored
  param_value  = var.param_value  # Value assigned to the parameter
  param_type   = var.param_type   # Type of the parameter (String, StringList, or SecureString)
}

# Module to create an IAM role with associated policies
module "app_role" {
  source = "./modules/iam"  # Path to the IAM module

  role_name          = var.app_iam_config["role_name"]           # IAM role name to be created
  policy_name        = var.app_iam_config["policy_name"]         # IAM policy name to be attached
  assume_role_policy = file("./policy_files/app-assume-role.json") # JSON file defining the assume role policy (who can assume the role)
  policy_document    = file("./policy_files/app-policy.json")    # JSON file defining the IAM policy document (permissions granted to the role)
}
