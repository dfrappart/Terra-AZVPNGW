##############################################################
#This file creates VPN GW for vnet 2
##############################################################

module "Gateway_vNet2_PIP" {
  #Module source

  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//10 PublicIP"

  #Module variables
  PublicIPCount        = "1"
  PublicIPName         = "gwvnet2pip"
  PublicIPLocation     = "${lookup(var.AzureRegion, 1)}"
  RGName               = "${module.ResourceGroup.Name}"
  PIPAddressAllocation = "Dynamic"
  EnvironmentTag       = "${var.EnvironmentTag}"
  EnvironmentUsageTag  = "${var.EnvironmentUsageTag}"
}

module "Gateway_vNet2" {
  #Module source
  source = "./Modules/02 AzureGateway"

  #Module variable

  GWName              = "Gateway_${var.vNet2Name}"
  GWRGName            = "${module.ResourceGroup.Name}"
  GWLocation          = "${lookup(var.AzureRegion, 1)}"
  GWSubnetId          = "${module.GW_Subnet_vNet2.Id}"
  GWPIPId             = "${element(module.Gateway_vNet2_PIP.Ids,0)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "vNet2_to_vNet1_Connection" {
  #Module source
  source = "./Modules/04 VNET2VNETConnection"

  #Module variable

  GWConnectionName     = "${var.vNet2Name}_to_${var.vNet1Name}_Connection"
  GWConnectionRG       = "${module.ResourceGroup.Name}"
  GWConnectionLocation = "${lookup(var.AzureRegion, 1)}"
  GWConnectionGWId     = "${module.Gateway_vNet2.Id}"
  GWConnectionPeerGWId = "${module.Gateway_vNet1.Id}"
  GWConnectionSK       = "${module.ConnectionSK.Result}"
  EnvironmentTag       = "${var.EnvironmentTag}"
  EnvironmentUsageTag  = "${var.EnvironmentUsageTag}"
}
