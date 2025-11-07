resource "aws_connect_queue" "queue" {
  instance_id           = var.instance_id
  name                  = var.name
  description           = var.description
  status                = var.status
  hours_of_operation_id = var.hours_of_operation_id != "" ? var.hours_of_operation_id : null
  max_contacts          = var.max_contacts

  dynamic "outbound_caller_config" {
    for_each = var.outbound_caller_config != null ? [var.outbound_caller_config] : []
    content {
      outbound_caller_id_name     = outbound_caller_config.value.outbound_caller_id_name
      outbound_caller_id_number_id = outbound_caller_config.value.outbound_caller_id_number_id
      outbound_flow_id             = outbound_caller_config.value.outbound_flow_id
    }
  }

  quick_connect_ids = var.quick_connect_ids

  tags = var.tags
}
