##############################################################
#This file creates VPN GW
##############################################################


module "Gateway_vNet1_PIP" {

    #Module source

    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//10 PublicIP"

    #Module variables
    PublicIPCount           = "1"
    PublicIPName            = "gwvnet1pip"
    PublicIPLocation        = "${lookup(var.AzureRegion, 0)}"
    RGName                  = "${module.ResourceGroup.Name}"
    PIPAddressAllocation    = "Dynamic"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"


}


module "Gateway_vNet1" {

    #Module source
    source = "./Modules/AzureGateway"
    

    #Module variable

    GWName                  = "Gateway_vNet1"
    GWRGName                = "${module.ResourceGroup.Name}"
    GWLocation              = "${lookup(var.AzureRegion, 0)}"
    GWSubnetId              = "${module.GW_Subnet_vNet1.Id}"
    GWPIPId                 = "${element(module.Gateway_vNet1_PIP.Ids,0)}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"

}

module "ConnectionSK" {

    #Module source
    source = "./Modules/RandomString"
        
}

module "vNet1_to_vNet2_Connection" {

    #Module source
    source = "./Modules/VNET2VNETConnection"
    

    #Module variable

    GWConnectionName        = "vNet1_to_vNet2_Connection"
    GWConnectionRG          = "${module.ResourceGroup.Name}"
    GWConnectionLocation    = "${lookup(var.AzureRegion, 0)}"
    GWConnectionGWId        = "${module.Gateway_vNet1.Id}"
    GWConnectionPeerGWId    = "${module.Gateway_vNet2.Id}"
    GWConnectionSK          = "${module.ConnectionSK.Result}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"


}