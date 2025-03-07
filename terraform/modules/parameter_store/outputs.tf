output "param_name" {
  description = "Nombre del parámetro creado"
  value       = aws_ssm_parameter.config_param.name
}