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
| [aws_ssm_parameter.config_param](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_param_name"></a> [param\_name](#input\_param\_name) | Nombre del parámetro | `string` | n/a | yes |
| <a name="input_param_value"></a> [param\_value](#input\_param\_value) | Valor del parámetro | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_param_name"></a> [param\_name](#output\_param\_name) | Nombre del parámetro creado |
<!-- END_TF_DOCS -->