# output.tf


# ===================================================================
# service account: email, name. unique_id
# ===================================================================

output "email" {
  value       = google_service_account.srvc_acc.email
  description = "The e-mail address of the service account."
}
output "name" {
  value       = google_service_account.srvc_acc.name
  description = "The fully-qualified name of the service account."
}
# output "account_id" {
output "unique_id" {
  value       = google_service_account.srvc_acc.unique_id
  description = "The unique id of the service account."
}

# ===================================================================
# private key
# ===================================================================

output "private_key" {
  value     = google_service_account_key.srvc_acc_key.private_key
  sensitive = true
}

output "decoded_private_key" {
  value     = base64decode(google_service_account_key.srvc_acc_key.private_key)
  sensitive = true
}