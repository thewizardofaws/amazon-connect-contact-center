resource "aws_connect_contact_flow" "contact_flow" {
  instance_id = var.instance_id
  name        = var.name
  description = var.description
  type        = "CONTACT_FLOW"
  content     = var.content

  tags = var.tags
}
