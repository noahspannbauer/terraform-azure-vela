resource "azurerm_container_app" "worker" {
  name                         = "worker"
  container_app_environment_id = azurerm_container_app_environment.environment.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "vela-worker"
      image  = "docker.io/target/vela-worker:v0.21.0"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "VELA_QUEUE_DRIVER"
        value = "redis"
      }

      env {
        name  = "VELA_SERVER_ADDR"
        value = var.vela_api
      }

      env {
        name  = "VELA_WORKER_ADDR"
        value = var.vela_worker_addr
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

resource "terraform_data" "add_worker_domain" {
  count            = 1
  triggers_replace = []

  lifecycle {
    replace_triggered_by = [azurerm_container_app.worker]
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]

    command = <<-EOT
        az containerapp hostname add -n ${azurerm_container_app.worker.name} -g ${azurerm_resource_group.rg.name} --hostname ${var.vela_worker_addr_hostname}
      EOT
    when    = create
  }

  depends_on = [azurerm_container_app.worker, terraform_data.add_server_domain]
}