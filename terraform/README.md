
## 🌍 Terraform Infrastructure Deployment

Before deploying applications in Kubernetes, deploy the **AWS infrastructure**  
using **Terraform**. The **Terraform state file** will be **stored locally** for this challenge.

### **📌 Infrastructure Overview**
| AWS Service | Purpose |
|-------------|---------|
| **S3 Bucket** | Stores static files and logs. |
| **IAM Role & Policies** | Grants permissions to services. |
| **Parameter Store** | Securely stores app configuration values. |

### **1️⃣ Initialize Terraform**
```sh
cd terraform
terraform init
```

### **2️⃣ Plan Deployment**
```sh
terraform plan
```
Shows the **AWS resources** that will be created.

### **3️⃣ Apply Deployment**
```sh
terraform apply -auto-approve
```
This will deploy the **S3 bucket, IAM roles, and Parameter Store settings**.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_role"></a> [app\_role](#module\_app\_role) | ./modules/iam | n/a |
| <a name="module_parameter_store"></a> [parameter\_store](#module\_parameter\_store) | ./modules/parameter_store | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ./modules/s3 | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_iam_config"></a> [app\_iam\_config](#input\_app\_iam\_config) | Configuration map for IAM role and policy | `map(any)` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Nombre del bucket S3 | `string` | n/a | yes |
| <a name="input_git_iam_config"></a> [git\_iam\_config](#input\_git\_iam\_config) | Configuration map for IAM role and policy | `map(any)` | n/a | yes |
| <a name="input_param_name"></a> [param\_name](#input\_param\_name) | Nombre del parámetro | `string` | n/a | yes |
| <a name="input_param_value"></a> [param\_value](#input\_param\_value) | Valor del parámetro | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role"></a> [iam\_role](#output\_iam\_role) | ARN del rol IAM |
| <a name="output_parameter_name"></a> [parameter\_name](#output\_parameter\_name) | Nombre del parámetro en AWS Parameter Store |
| <a name="output_s3_bucket"></a> [s3\_bucket](#output\_s3\_bucket) | Nombre del bucket S3 |
<!-- END_TF_DOCS -->