##############################################################
#This module allows the creation of a VPN Gateway
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
  default = "Vpn"

}

variable "GWVpnType" {
  type    = "string"
  default = "Routebased"
  #default = "Policybased"
  
}

variable "EnableBGP" {
  type    = "string"
  default = "false"

  
}

variable "FTOption" {
  type = "string"
  default = "false"
}

variable "GWsku" {
  type    = "string"
  default = "VpnGw1"
  #default = "VpnGw2"
  #default = "VpnGw3"
  #default = "Basic"

}

variable "GWIPConfName" {
    type    = "string"
    default = "DefaultGWConf"
}

variable "GWPRivateIPAlloc" {
    type    = "string"
    default = "Dynamic"
}

variable "GWSubnetId" {
    type = "string"
}

variable "GWPIPId" {
    type = "string"
}

variable "count" {
    type    = "string"
    default = "1"
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

resource "azurerm_virtual_network_gateway" "TerraVirtualNetworkGW" {


    #count                       = "${var.count}"
    name                        = "${var.GWName}"
    resource_group_name         = "${var.GWRGName}"
    location                    = "${var.GWLocation}"
    type                        = "${var.GWType}"
    vpn_type                    = "${var.GWVpnType}"
    enable_bgp                  = "${var.EnableBGP}"
    active_active               = "${var.FTOption}"
    sku                         = "${var.GWsku}"
    
    ip_configuration {

        name                            = "${var.GWIPConfName}"
        private_ip_address_allocation   = "${var.GWPRivateIPAlloc}"
        subnet_id                       = "${var.GWSubnetId}"
        #public_ip_address_id            = "${element(var.GWPIPId,count.index)}"
        public_ip_address_id            = "${var.GWPIPId}"

    }

    tags {
    
        environment = "${var.EnvironmentTag}"
        usage       = "${var.EnvironmentUsageTag}"
    }  



}



#Output



output "Name" {

  value = ["${azurerm_virtual_network_gateway.TerraVirtualNetworkGW.name}"]
}

output "Id" {

  #value = ["${azurerm_virtual_network_gateway.TerraVirtualNetworkGW.*.id}"]
  value = "${azurerm_virtual_network_gateway.TerraVirtualNetworkGW.id}"
}

output "Type" {

  #value = ["${azurerm_virtual_network_gateway.TerraVirtualNetworkGW.*.type}"]
  value = "${azurerm_virtual_network_gateway.TerraVirtualNetworkGW.type}"
}

output "Sku" {

  #value = ["${azurerm_virtual_network_gateway.TerraVirtualNetworkGW.*.sku}"]
  value = "${azurerm_virtual_network_gateway.TerraVirtualNetworkGW.sku}"
}