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
  subscription_id = "3dbd48a9-8b88-4f04-afe7-1e18cd8b175b"
}