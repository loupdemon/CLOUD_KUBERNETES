

resource "azurerm_public_ip" "gateway" {
  name                    = "gw-pip"
  resource_group_name     = data.azurerm_resource_group.rg-kubi.name
  location                = data.azurerm_resource_group.rg-kubi.location
  allocation_method       = "Static"
  sku                     = "Standard"
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
  zones                   = ["1", "2", "3"]
}

# resource "azurerm_user_assigned_identity" "gateway" {
#   name                = "gw-uid"
#   resource_group_name = data.azurerm_resource_group.rg-kubi.name
#   location            = data.azurerm_resource_group.rg-kubi.location
# }

resource "azurerm_application_gateway" "gateway" {
  name                = "agic-appgw"
  resource_group_name = data.azurerm_resource_group.rg-kubi.name
  location            = data.azurerm_resource_group.rg-kubi.location
  enable_http2        = false
  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = "1"
    max_capacity = "2"
  }

  zones = ["1", "2", "3"]

  gateway_ip_configuration {
    name      = "gw-ip-conf"
    subnet_id = azurerm_subnet.sub-appgw.id

  }

  frontend_ip_configuration {
    name                 = "fe-ip"
    public_ip_address_id = azurerm_public_ip.gateway.id
  }

  frontend_port {
    name = "fe-port"
    port = 80
  }

  probe {
    name                = "http-probe"
    path                = "/"
    port                = 80
    interval            = 30
    protocol            = "Http"
    timeout             = 60
    unhealthy_threshold = 3

    pick_host_name_from_backend_http_settings = true
  }

  # ssl_certificate {
  #   name                = "certif-gw"
  #   key_vault_secret_id = azurerm_key_vault_certificate.gw.secret_id
  # }

  backend_http_settings {
    name                  = "http-setting"
    cookie_based_affinity = "Disabled"
    protocol              = "Http"
    port                  = 80
    request_timeout       = 1
     probe_name            = "http-probe"

     pick_host_name_from_backend_address = true
  }

  backend_address_pool {
    name  = "backpool"
  }

  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "fe-ip"
    frontend_port_name             = "fe-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "listener"
    backend_address_pool_name  = "backpool"
    backend_http_settings_name = "http-setting"
    priority                   = "1000"
  }

  # ssl_policy {
  #   policy_name = "AppGwSslPolicy20170401S"
  #   policy_type = "Predefined"
  # }

  # identity {
  #   type         = "UserAssigned"
  #   identity_ids = [azurerm_user_assigned_identity.gateway.id]
  # }

  # Prevent overriding AGIC configuration 
  # made on Application Gateway resource
  lifecycle {
    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      frontend_port,
      http_listener,
      probe,
      request_routing_rule,
      redirect_configuration,
      tags,
      ssl_certificate
    ]
  }
}
