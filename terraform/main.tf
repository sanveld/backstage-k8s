# Configure the Azure provider
provider "azurerm" {
  features {}
  subscription_id = "5f20f70d-402a-4ec5-87f9-04c3546ca6a5"
}

# Create resource group
resource "azurerm_resource_group" "backstage" {
  name     = "backstage"
  location = "westeurope"
}

# Create PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "backstage_db" {
  name                   = "backstage-postgres-devplatform0"
  resource_group_name    = azurerm_resource_group.backstage.name
  location               = azurerm_resource_group.backstage.location
  version                = "14"
  administrator_login    = var.db_username
  administrator_password = var.db_password
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms" # Burstable tier
  zone                   = "1"

  backup_retention_days = 7
}

# Create the database
resource "azurerm_postgresql_flexible_server_database" "backstage_catalog_db" {
  name      = "backstage_plugin_catalog"
  server_id = azurerm_postgresql_flexible_server.backstage_db.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# Create another database for backstage app plugin
resource "azurerm_postgresql_flexible_server_database" "backstage_app_db" {
  name      = "backstage_plugin_app"
  server_id = azurerm_postgresql_flexible_server.backstage_db.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
# Allow access from Azure services
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.backstage_db.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
# Allow access from specific IP
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_specific_ip" {
  name             = "AllowSpecificIP"
  server_id        = azurerm_postgresql_flexible_server.backstage_db.id
  start_ip_address = "178.224.61.178"
  end_ip_address   = "178.224.61.178"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_specific_ip_2" {
  name             = "AllowSpecificIP2"
  server_id        = azurerm_postgresql_flexible_server.backstage_db.id
  start_ip_address = "89.20.189.121"
  end_ip_address   = "89.20.189.121"
}

# Set to disable SSL requirement
resource "azurerm_postgresql_flexible_server_configuration" "disable_ssl" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.backstage_db.id
  value     = "off"
}

# Output connection string
output "postgresql_connection_string" {
  value     = "postgresql://${azurerm_postgresql_flexible_server.backstage_db.administrator_login}:${azurerm_postgresql_flexible_server.backstage_db.administrator_password}@${azurerm_postgresql_flexible_server.backstage_db.fqdn}:5432/${azurerm_postgresql_flexible_server_database.backstage_catalog_db.name}"
  sensitive = true
}

# Output PostgreSQL username
output "postgresql_username" {
  value     = azurerm_postgresql_flexible_server.backstage_db.administrator_login
  sensitive = true
}

# Output PostgreSQL password
output "postgresql_password" {
  value     = azurerm_postgresql_flexible_server.backstage_db.administrator_password
  sensitive = true
}