terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.88.1"
    }
  }
}

provider "azurerm" {
  features {
    
  }
}

module "ResourceGroup" {
  source = "../../modules/ResourceGroup"
  base_name = "tfQC"
  location = "West US"
}

module "StorageAccount" {
  source = "../../modules/StorageAccount"
  base_name = "tfTesting"
  resource_group_name = module.ResourceGroup.rg_name_out
  location = "West US"
}

##ref: https://www.youtube.com/watch?v=0YLPfSLbp9Y