terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Variables
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "silabosusmp"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = "East US"

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Storage Account para Azure Functions
resource "azurerm_storage_account" "main" {
  name                     = "${replace(var.project_name, "-", "")}${var.environment}st"
  resource_group_name      = azurerm_resource_group.main.name
  location                = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# App Service Plan para Azure Functions (Consumption)
resource "azurerm_service_plan" "main" {
  name                = "${var.project_name}-${var.environment}-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Windows"
  sku_name            = "Y1"  # Consumption plan (gratis)

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Azure Function App
resource "azurerm_windows_function_app" "main" {
  name                = "${var.project_name}-${var.environment}-func"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key
  service_plan_id            = azurerm_service_plan.main.id

  site_config {
    application_stack {
      node_version = "~20"
    }
    
    cors {
      allowed_origins = [
        "http://localhost:3000",
        "http://localhost:5173",
        "http://127.0.0.1:5173"
      ]
      support_credentials = true
    }
  }

  app_settings = {
    "FUNCTIONS_EXTENSION_VERSION" = "~4"
    "WEBSITE_NODE_DEFAULT_VERSION" = "~20"
    "FUNCTIONS_WORKER_RUNTIME" = "node"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Static Web App para el frontend
resource "azurerm_static_web_app" "frontend" {
  name                = "${var.project_name}-${var.environment}-frontend"
  resource_group_name = azurerm_resource_group.main.name
  location            = "East US 2"
  sku_tier            = "Free"
  sku_size            = "Free"

  app_settings = {
    "VITE_API_URL" = "https://${azurerm_windows_function_app.main.default_hostname}/api"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Outputs
output "function_app_name" {
  value = azurerm_windows_function_app.main.name
}

output "function_app_url" {
  value = "https://${azurerm_windows_function_app.main.default_hostname}"
}

output "frontend_url" {
  value = "https://${azurerm_static_web_app.frontend.default_host_name}"
}

output "frontend_deployment_token" {
  value = azurerm_static_web_app.frontend.api_key
  sensitive = true
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}
