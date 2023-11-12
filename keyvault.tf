resource "azurerm_key_vault" "keyvault" {
  name                      = "velakeyvault"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  tenant_id                 = data.azurerm_subscription.subscription.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = true
  purge_protection_enabled  = false
}

resource "azurerm_role_assignment" "role_keyvault_identity" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.vela_identity.principal_id
}

resource "azurerm_role_assignment" "role_keyvault_me" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.client.object_id
}

resource "azurerm_key_vault_secret" "vela_server_private_key" {
  name         = "vela-server-private-key"
  value        = var.vela_server_private_key
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_role_assignment.role_keyvault_identity, azurerm_role_assignment.role_keyvault_me]
}

resource "azurerm_key_vault_secret" "vela_database_addr" {
  name         = "vela-database-addr"
  value        = var.vela_database_addr
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_role_assignment.role_keyvault_identity, azurerm_role_assignment.role_keyvault_me]
}

resource "azurerm_key_vault_secret" "vela_database_encryption_key" {
  name         = "vela-database-encryption-key"
  value        = var.vela_database_encryption_key
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_role_assignment.role_keyvault_identity, azurerm_role_assignment.role_keyvault_me]
}

resource "azurerm_key_vault_secret" "vela_queue_addr" {
  name         = "vela-queue-addr"
  value        = var.vela_queue_addr
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_role_assignment.role_keyvault_identity, azurerm_role_assignment.role_keyvault_me]
}

resource "azurerm_key_vault_secret" "vela_queue_private_key" {
  name         = "vela-queue-private-key"
  value        = var.vela_queue_private_key
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_role_assignment.role_keyvault_identity, azurerm_role_assignment.role_keyvault_me]
}

resource "azurerm_key_vault_secret" "vela_queue_public_key" {
  name         = "vela-queue-public-key"
  value        = var.vela_queue_public_key
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_role_assignment.role_keyvault_identity, azurerm_role_assignment.role_keyvault_me]
}

resource "azurerm_key_vault_secret" "vela_scm_client" {
  name         = "vela-scm-client"
  value        = var.vela_scm_client
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_role_assignment.role_keyvault_identity, azurerm_role_assignment.role_keyvault_me]
}

resource "azurerm_key_vault_secret" "vela_scm_secret" {
  name         = "vela-scm-secret"
  value        = var.vela_scm_secret
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_role_assignment.role_keyvault_identity, azurerm_role_assignment.role_keyvault_me]
}