#Break large main.tf in to multipl managable grouped .tf files like variable/providers


# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = var.azrg
  location = var.azloc
}

#create Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.100.0.0/16"]
  dns_servers         = ["8.8.8.8", "4.4.4.4"]

  subnet {
    name           = "websubnet"
    address_prefix = "10.100.1.0/24"
  }

  subnet {
    name           = "dbsubnet2"
    address_prefix = "10.100.2.0/24"
    security_group = azurerm_network_security_group.exampleNSG.id
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_security_group" "exampleNSG" {
  name                = "DBNSG"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "allowwebtodb"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.dbport
    source_address_prefix      = "10.100.1.0/24"
    destination_address_prefix = "10.100.2.0/24"
  }

  tags = {
    environment = "Production"
  }
}