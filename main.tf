# ReUse the created resource group,Enter resource group name in Gitlab ENV variable

data "azurerm_resource_group" "rg" {
    name   = "${var.runner_resource_group}"
}

# ReUse the created virtual network,enter the vnet name in Gitlab ENV variable

data "azurerm_virtual_network" "vnet" {
    name                = "${var.runner_vnet}"
    resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

# Reuse created Subnet
data "azurerm_subnet" "runner_subnet" {
    name                 = "${var.runner_subnet}"
    resource_group_name  = "${data.azurerm_resource_group.rg.name}"
    virtual_network_name = "${data.azurerm_virtual_network.vnet.name}"
}


#ReUse the network security group enter the value in GITLAB ENV VARIABLE
data "azurerm_network_security_group" "runner_nsg" {
    name                = "${var.runner_nsg}"
    resource_group_name = "${data.azurerm_resource_group.rg.name}"
}



#create a new network interface
resource "azurerm_network_interface" "net" {
    count                     = "${var.count}"
    name                      = "net-${var.resource_suffix}${count.index+1}"
    location                  = "${var.location}"
    resource_group_name       = "${data.azurerm_resource_group.rg.name}"
    network_security_group_id = "${data.azurerm_network_security_group.runner_nsg.id}"

    ip_configuration {
        name                          = "nic-${var.resource_suffix}${count.index+1}"
        subnet_id                     = "${data.azurerm_subnet.runner_subnet.id}"
        private_ip_address_allocation = "Dynamic"
    }

    tags {
        environment = "${var.env}"
    }
}
