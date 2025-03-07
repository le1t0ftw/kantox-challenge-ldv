module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "parameter_store" {
  source      = "./modules/parameter_store"
  param_name  = var.param_name
  param_value = var.param_value
}

module "iam" {
  source = "./modules/iam"
}