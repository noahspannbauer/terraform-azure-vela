resource "azurerm_container_app" "server" {
  name                         = "server"
  container_app_environment_id = azurerm_container_app_environment.environment.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "vela-server"
      image  = "docker.io/target/vela-server:v0.21.0"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "VELA_ADDR"
        value = var.vela_api
      }

      env {
        name        = "VELA_SERVER_PRIVATE_KEY"
        secret_name = "vela-server-private-key"
      }

      env {
        name  = "VELA_PORT"
        value = "80"
      }

      env {
        name  = "VELA_DATABASE_DRIVER"
        value = "postgres"
      }

      env {
        name        = "VELA_DATABASE_ADDR"
        secret_name = "vela-database-addr"
      }

      env {
        name        = "VELA_DATABASE_ENCRYPTION_KEY"
        secret_name = "vela-database-encryption-key"
      }

      env {
        name  = "VELA_QUEUE_DRIVER"
        value = "redis"
      }

      env {
        name        = "VELA_QUEUE_ADDR"
        secret_name = "vela-queue-addr"
      }

      env {
        name        = "VELA_QUEUE_PRIVATE_KEY"
        secret_name = "vela-queue-private-key"
      }

      env {
        name        = "VELA_QUEUE_PUBLIC_KEY"
        secret_name = "vela-queue-public-key"
      }

      env {
        name        = "VELA_SCM_CLIENT"
        secret_name = "vela-scm-client"
      }

      env {
        name        = "VELA_SCM_SECRET"
        secret_name = "vela-scm-secret"
      }

      env {
        name  = "VELA_WEBUI_ADDR"
        value = var.vela_webui_addr
      }

      env {
        name  = "VELA_REPO_ALLOWLIST"
        value = "*"
      }

      env {
        name  = "VELA_SCHEDULE_ALLOWLIST"
        value = "*"
      }
    }
  }

  secret {
    name  = "vela-server-private-key"
    value = data.azurerm_key_vault_secret.vela_server_private_key.value
  }

  secret {
    name  = "vela-database-addr"
    value = data.azurerm_key_vault_secret.vela_database_addr.value
  }

  secret {
    name  = "vela-database-encryption-key"
    value = data.azurerm_key_vault_secret.vela_database_encryption_key.value
  }

  secret {
    name  = "vela-queue-addr"
    value = data.azurerm_key_vault_secret.vela_queue_addr.value
  }

  secret {
    name  = "vela-queue-private-key"
    value = data.azurerm_key_vault_secret.vela_queue_private_key.value
  }

  secret {
    name  = "vela-queue-public-key"
    value = data.azurerm_key_vault_secret.vela_queue_public_key.value
  }

  secret {
    name  = "vela-scm-client"
    value = data.azurerm_key_vault_secret.vela_scm_client.value
  }

  secret {
    name  = "vela-scm-secret"
    value = data.azurerm_key_vault_secret.vela_scm_secret.value
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vela_identity.id]
  }

  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = 80
    transport                  = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  depends_on = [azurerm_key_vault.keyvault]
}

resource "terraform_data" "add_server_domain" {
  count            = 1
  triggers_replace = []

  lifecycle {
    replace_triggered_by = [azurerm_container_app.server]
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]

    command = <<-EOT
        az containerapp hostname add -n ${azurerm_container_app.server.name} -g ${azurerm_resource_group.rg.name} --hostname ${var.vela_api_hostname}
      EOT
    when    = create
  }

  depends_on = [azurerm_container_app.server]
}