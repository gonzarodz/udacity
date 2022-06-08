provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
}

output "id" {
  value = data.azurerm_resource_group.main.id
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags = {
    name = "First Project"
  }
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-sub"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    name = "First Project"
  }
}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-pub-ip"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
  tags = {
    name = "First Project"
  }
}

resource "azurerm_lb" "main" {
  name                = "${var.prefix}-lb"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                 = "${var.prefix}-front-ip"
    public_ip_address_id = azurerm_public_ip.main.id
  }
  tags = {
    name = "First Project"
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  name                = "${var.prefix}-backend-pool"
  loadbalancer_id     = azurerm_lb.main.id
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-sg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  security_rule {
    name                       = "Allow inbound within sub"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Deny all trafic"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    name = "First Project"
  }
}

resource "azurerm_availability_set" "main" {
  name                = "${var.prefix}-availability-set"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags = {
    name = "First Project"
  }
}

data "azurerm_image" "main" {
  name = "myFirstProject"
  resource_group_name = "first-project-rg"
}

output "image_id" {
  value = "/subscriptions/d10556ae-ae0e-4fa8-8ea9-4bddb33248b8/resourceGroups/RG-EASTUS-SPT-PLATFORM/providers/Microsoft.Compute/images/myPackerImage"
}

resource "azurerm_virtual_machine" "main" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = data.azurerm_resource_group.main.location
  vm_size                         = "Standard_B1s"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  storage_image_reference {
    id = "${data.azurerm_image.main.id}"
  }

  storage_os_disk {
    name              = "${var.prefix}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
}

  os_profile {
    computer_name  = "UdacityProject"
    admin_username = "adminuser"
    admin_password = "P@ssword1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    name = "First Project"
  }
}