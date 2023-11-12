resource "azurerm_resource_group" "rg" {
  name     = "Vela"
  location = "eastus"
}

data "azurerm_subscription" "subscription" {}

data "azurerm_client_config" "client" {}

data "azurerm_key_vault" "keyvault" {
  name                = "velakeyvault"
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [azurerm_resource_group.rg, azurerm_key_vault.keyvault]
}

data "azurerm_key_vault_secret" "vela_server_private_key" {
  name         = "vela-server-private-key"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_key_vault.keyvault]
}

data "azurerm_key_vault_secret" "vela_database_addr" {
  name         = "vela-database-addr"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_key_vault.keyvault]
}

data "azurerm_key_vault_secret" "vela_database_encryption_key" {
  name         = "vela-database-encryption-key"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_key_vault.keyvault]
}

data "azurerm_key_vault_secret" "vela_queue_addr" {
  name         = "vela-queue-addr"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_key_vault.keyvault]
}

data "azurerm_key_vault_secret" "vela_queue_private_key" {
  name         = "vela-queue-private-key"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_key_vault.keyvault]
}

data "azurerm_key_vault_secret" "vela_queue_public_key" {
  name         = "vela-queue-public-key"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_key_vault.keyvault]
}

data "azurerm_key_vault_secret" "vela_scm_client" {
  name         = "vela-scm-client"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_key_vault.keyvault]
}

data "azurerm_key_vault_secret" "vela_scm_secret" {
  name         = "vela-scm-secret"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_key_vault.keyvault]
}