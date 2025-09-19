output "group_names" {
  value = { for r in local.roles : r => "${local.name_prefix}${r}" }
}