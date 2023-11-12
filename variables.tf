variable "vela_server_private_key" {
  type      = string
  sensitive = true
}

variable "vela_database_addr" {
  type      = string
  sensitive = true
}

variable "vela_database_encryption_key" {
  type      = string
  sensitive = true
}

variable "vela_queue_addr" {
  type      = string
  sensitive = true
}

variable "vela_queue_private_key" {
  type      = string
  sensitive = true
}

variable "vela_queue_public_key" {
  type      = string
  sensitive = true
}

variable "vela_scm_client" {
  type      = string
  sensitive = true
}

variable "vela_scm_secret" {
  type      = string
  sensitive = true
}

variable "vela_api" {
  type      = string
  sensitive = true
}

variable "vela_api_hostname" {
  type      = string
  sensitive = true
}

variable "vela_webui_addr" {
  type      = string
  sensitive = true
}

variable "vela_webui_addr_hostname" {
  type      = string
  sensitive = true
}

variable "vela_worker_addr" {
  type      = string
  sensitive = true
}

variable "vela_worker_addr_hostname" {
  type      = string
  sensitive = true
}