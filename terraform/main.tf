module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "parameter_store" {
  source      = "./modules/parameter_store"
  param_name  = var.param_name
  param_value = var.param_value
}

module "app_role" {
  source = "./modules/iam"

  role_name          = var.app_iam_config["role_name"]
  policy_name        = var.app_iam_config["policy_name"]
  assume_role_policy = file("./policy_files/app-assume-role.json")
  policy_document    = file("./policy_files/app-policy.json")
}

module "github_role" {
  source = "./modules/iam"

  role_name          = var.git_iam_config["role_name"]
  policy_name        = var.git_iam_config["policy_name"]
  assume_role_policy = file("./policy_files/app-assume-role.json")
  policy_document    = file("./policy_files/app-policy.json")
}


module "ecr" {
  source             = "./modules/ecr"
  repository_name    = var.repository_name
  image_tag_mutability = var.image_tag_mutability
}