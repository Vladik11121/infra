variable "service_account_key_file" {
  description = "Path to service account key file"
  type        = string
  default     = "packer-key.json"
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  default     = "b1ga8kilo5nklegmh627"
}
