##############################################################
#This module allows the creation of a VPN Gateway
##############################################################

#Variable declaration for Module

variable "GWConnectionName" {

    type = "string"
    
}

variable "GWConnectionLocation" {

    type = "string"
    
}

variable "GWConnectionRG" {

    type = "string"
    
}



variable "GWConnectionGWId" {

    type = "string"
    
}

variable "GWConnectionPeerGWId" {

    type = "string"
    
}

variable "GWConnectionSK" {

    type = "string"
    
}

variable "EnvironmentTag" {

    type = "string"
    
}

variable "EnvironmentUsageTag" {

    type = "string"
    
}
#Resource Creation

resource "azurerm_virtual_network_gateway_connection" "TerraVNETGWConnection" {

    name                                = "${var.GWConnectionName}"
    location                            = "${var.GWConnectionLocation}"
    resource_group_name                 = "${var.GWConnectionRG}"
    type                                = "Vnet2Vnet"
    virtual_network_gateway_id          = "${var.GWConnectionGWId}"
    peer_virtual_network_gateway_id     = "${var.GWConnectionPeerGWId}"

    shared_key                          = "${var.GWConnectionSK}"

    tags {
    
        environment = "${var.EnvironmentTag}"
        usage       = "${var.EnvironmentUsageTag}"
    }  
}


#Output

