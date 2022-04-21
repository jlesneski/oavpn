terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.92.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "62b4ac63-dbaf-4233-bb78-63a2a2539745"
}