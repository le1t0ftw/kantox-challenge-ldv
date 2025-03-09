## Bucket Variables ##
bucket_name = "ldv12354905834098"

## Parameter Store Variables ##
param_name = "prueba-ldv"
param_value = "test"

## Iam Role Variables ##
app_iam_config = {
  role_name          = "app-role"
  policy_name        = "app-policy"
}
git_iam_config = {
  role_name          = "git-role"
  policy_name        = "git-policy"
}