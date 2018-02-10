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
    GWPIPId                 = ["${module.Gateway_vNet1_PIP.Ids}"]
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"

}