resource "azurerm_virtual_machine" "vm" {
  count                            = "${var.count}"
  name                             = "${var.hostname}${count.index+1}"
  location                         = "${var.location}"
  resource_group_name              = "${data.azurerm_resource_group.rg.name}"
  network_interface_ids            = ["${element(azurerm_network_interface.net.*.id, count.index)}"]
  vm_size                          = "${var.vmsize}"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = false


  storage_image_reference {
        publisher = "credativ"
        offer     = "${var.img_offer}"
        sku       = "${var.img_sku}"
        version   = "latest"
  }

  storage_os_disk {
    name              = "server-os${count.index+1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.storage_type}"
  }

  os_profile {
    computer_name      = "${var.hostname}${count.index+1}"
    admin_username     = "${var.admin_user}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_user}/.ssh/authorized_keys"
      key_data = "${var.sshkey_value}"
    }
}

    tags {
          environment = "${var.env}"
          project = "${var.project}"
         }
}

resource "azurerm_virtual_machine_extension" "vm" {
  count                = "${var.count}"
  name                 = "${var.hostname}${count.index+1}"
  location             = "${data.azurerm_resource_group.rg.location}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
  virtual_machine_name = "${element(azurerm_virtual_machine.vm.*.name, count.index)}"
  #virtual_machine_name = "${azurerm_virtual_machine.vm.*.name[count.index]}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
        {
        "commandToExecute": "apt-get update -y && apt-get install curl -y &&   --output initialization.sh && chmod +x initialization.sh && ./initialization.sh --token ${var.GITLAB_RUNNER_TOKEN} --executor ${var.GITLAB_RUNNER_EXECUTOR} --url ${var.GITLAB_URL} --tag ${var.GITLAB_RUNNER_TAG}${count.index+1} --locked ${var.GITLAB_RUNNER_LOCKED}"
        }
SETTINGS

  tags = {
    environment = "${var.env}"
  }
}
