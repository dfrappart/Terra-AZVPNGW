##############################################################
#This module allows the creation of a SubVPNnet Gateway
##############################################################

#Variable declaration for Module

variable "GWName" {
  type    = "string"
  default = "GatewaySubnet"
}


variable "GWRGName" {
  type    = "string"
  default = "DefaultRSG"
}

variable "GWLocation" {
  type    = "string"

}

variable "GWType" {
  type    = "string"

}

variable "GWsku" {
  type    = "string"

}

variable "GWIPConfName" {
    type    = "string"
    default = "DefaultGWConf"
}

variable "GWSubnetId" {
    type = "string"
}

variable "EnvironmentTag" {
  type    = "string"
  default = "Poc"
}

variable "EnvironmentUsageTag" {
  type    = "string"
  default = "Poc usage only"
}

#Creation of the VPN Gateway

resource "azurerm_subnet" "TerraVirtualNetworkGW" {



    name                        = "${var.GWName}"
    resource_group_name         = "${var.GWRGName}"
    location                    = "${var.GWLocation}"
    type                        = "${var.GWType}"
    sku                         = "${var.GWsku}"
    
    ip_configuration {

        name                            = "${var.GWIPConfName}"
        private_ip_address_allocation   = "${var.GWPRivateIPAlloc}"
        subnet_id                       = "${var.GWSubnetId}"
        public_ip_address_id            = "${var.GWPIPId}"

    }

    tags {
    
        environment = "${var.EnvironmentTag}"
        usage       = "${var.EnvironmentUsageTag}"
    }  



}



#Output



output "Name" {

  value = "${azurerm_subnet.TerraSubnet.name}"
}

output "Id" {

  value = "${azurerm_subnet.TerraSubnet.id}"
}

output "AddressPrefix" {

  value = "${azurerm_subnet.TerraSubnet.address_prefix}"
}