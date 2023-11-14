variable "owner" {
  description = "email address of the owner of this resource"
}
variable "costcenter" {
  description = "cost center of this resource"
}
variable "location" {
  description = "location of this resource"
}

variable "unumber" {
  description = "your official unmuber"
}

provider "azurerm" {  
    features {}
}

resource "azurerm_resource_group" "training" {
  name     = "training-${var.unumber}"
  location = var.location
  tags = {
    Owner = var.owner
    CostCenter = var.costcenter
  }
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "training" {
  name                = "training-${var.unumber}"
  resource_group_name = azurerm_resource_group.training.name
  location            = azurerm_resource_group.training.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.training.name
  virtual_network_name = azurerm_virtual_network.training.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "pip-${var.unumber}"
  resource_group_name = azurerm_resource_group.training.name
  location            = azurerm_resource_group.training.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "training" {
  name                = "nic1-${var.unumber}"
  resource_group_name = azurerm_resource_group.training.name
  location            = azurerm_resource_group.training.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface" "internal" {
  name                = "nic2-${var.unumber}"
  resource_group_name = azurerm_resource_group.training.name
  location            = azurerm_resource_group.training.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "webserver" {
  name                = "tls_webserver"
  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "tls"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "443"
    destination_address_prefix = azurerm_network_interface.training.private_ip_address
  }
}

resource "azurerm_network_interface_security_group_association" "training" {
  network_interface_id      = azurerm_network_interface.internal.id
  network_security_group_id = azurerm_network_security_group.webserver.id
}

resource "azurerm_linux_virtual_machine" "training" {
  name                = "vm-${var.unumber}"
  resource_group_name = azurerm_resource_group.training.name
  location            = azurerm_resource_group.training.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.training.id,
    azurerm_network_interface.internal.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

output "ip_address" {
  value = azurerm_linux_virtual_machine.training.public_ip_address
}