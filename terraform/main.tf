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

module "api_ecr" {
  source             = "./modules/ecr"
  repository_name    = var.api_repository_name
  image_tag_mutability = var.api_image_tag_mutability
}

module "aux_ecr" {
  source             = "./modules/ecr"
  repository_name    = var.aux_repository_name
  image_tag_mutability = var.aux_image_tag_mutability
}