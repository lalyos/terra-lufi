variable "owner" {
  description = "email address of the owner of this resource"
}
variable "costcenter" {
  description = "cost center of this resource"
}
variable "location" {
  description = "location of this resource"
}

variable "unumuber" {
  description = "your official unmuber"
}

provider "azurerm" {  
    features {}
}

resource "azurerm_resource_group" "training" {
  name     = "training-${var.unumuber}"
  location = var.location
  tags = {
    Owner = var.owner
    CostCenter = var.costcenter
  }
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "training" {
  name                = "training-${var.unumuber}"
  resource_group_name = azurerm_resource_group.training.name
  location            = azurerm_resource_group.training.location
  address_space       = ["10.0.0.0/16"]
}