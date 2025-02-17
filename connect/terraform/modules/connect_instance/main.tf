resource "aws_connect_instance" "connect_instance" {
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled    = true
  instance_alias           = var.connect_instance_alias
  outbound_calls_enabled   = true
}

output "connect_instance_arn" {
  value = aws_connect_instance.connect_instance.arn
}

output "connect_instance_id" {
  value = aws_connect_instance.connect_instance.id
}
