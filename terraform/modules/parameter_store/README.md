<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_param_name"></a> [param\_name](#input\_param\_name) | The name of the AWS SSM Parameter Store entry. | `string` | n/a | yes |
| <a name="input_param_value"></a> [param\_value](#input\_param\_value) | The value assigned to the AWS SSM Parameter Store entry. | `string` | n/a | yes |
| <a name="input_param_type"></a> [param\_type](#input\_param\_type) | The type of the AWS SSM Parameter Store entry (String, StringList, or SecureString). | `string` | `"String"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ssm_parameter_arn"></a> [ssm\_parameter\_arn](#output\_ssm\_parameter\_arn) | The ARN of the created AWS SSM Parameter. |
| <a name="output_ssm_parameter_name"></a> [ssm\_parameter\_name](#output\_ssm\_parameter\_name) | The name of the created AWS SSM Parameter. |
<!-- END_TF_DOCS -->