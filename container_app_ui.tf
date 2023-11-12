resource "azurerm_container_app" "ui" {
  name                         = "ui"
  container_app_environment_id = azurerm_container_app_environment.environment.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "vela-ui"
      image  = "docker.io/target/vela-ui:v0.21.0"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "VELA_API"
        value = var.vela_api
      }
    }
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

  depends_on = [azurerm_container_app.server]
}

resource "terraform_data" "add_ui_domain" {
  count            = 1
  triggers_replace = []

  lifecycle {
    replace_triggered_by = [azurerm_container_app.ui]
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]

    command = <<-EOT
        az containerapp hostname add -n ${azurerm_container_app.ui.name} -g ${azurerm_resource_group.rg.name} --hostname ${var.vela_webui_addr_hostname}
      EOT
    when    = create
  }

  depends_on = [azurerm_container_app.ui, terraform_data.add_server_domain]
}