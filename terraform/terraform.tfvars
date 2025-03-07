bucket_name = "ldv12354905834098"
param_name = "prueba-ldv"
param_value = "aaaaa"
api_repository_name = "main-api"
aux_repository_name = "auxiliary-service"
api_image_tag_mutability = "MUTABLE"
aux_image_tag_mutability = "MUTABLE"
app_iam_config = {
  role_name          = "app-role"
  policy_name        = "app-policy"
}
git_iam_config = {
  role_name          = "git-role"
  policy_name        = "git-policy"
}