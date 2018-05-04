######################################################
# This file deploys the subnet and NSG for 
#Azure Gateway Test Architecture
######################################################

######################################################################
# Subnet and NSG
######################################################################

######################################################################
# Front End
######################################################################

#FEApps_Subnet NSG

module "NSG_FEApps_Subnet_vNet1" {

    #Module location
    #source = "./Modules/07 NSG"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//07 NSG/"

    #Module variable
    NSGName                 = "NSG_${lookup(var.SubnetName, 0)}_vNet1"
    RGName                  = "${module.ResourceGroup.Name}"
    NSGLocation             = "${lookup(var.AzureRegion, 0)}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"


}

#FEApps_Subnet

module "FEApps_Subnet_vNet1" {

    #Module location
    #source = "./Modules/06 Subnet"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 Subnet"

    #Module variable
    SubnetName                  = "${lookup(var.SubnetName, 0)}"
    RGName                      = "${module.ResourceGroup.Name}"
    vNetName                    = "${module.vNet1.Name}"
    Subnetaddressprefix         = "${lookup(var.vNet1SubnetAddressRange, 0)}"
    NSGid                       = "${module.NSG_FEApps_Subnet_vNet1.Id}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"

}


######################################################################
# Back End
######################################################################

#BEApps_Subnet NSG

module "NSG_BEApps_Subnet_vNet1" {

    #Module location
    #source = "./Modules/07 NSG"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//07 NSG/"

    #Module variable
    NSGName                 = "NSG_${lookup(var.SubnetName, 1)}_vNet1"
    RGName                  = "${module.ResourceGroup.Name}"
    NSGLocation             = "${lookup(var.AzureRegion, 0)}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"


}

#BEApps_Subnet

module "BEApps_Subnet_vNet1" {

    #Module location
    #source = "./Modules/06 Subnet"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 Subnet"

    #Module variable
    SubnetName                  = "${lookup(var.SubnetName, 1)}"
    RGName                      = "${module.ResourceGroup.Name}"
    vNetName                    = "${module.vNet1.Name}"
    Subnetaddressprefix         = "${lookup(var.vNet1SubnetAddressRange, 1)}"
    NSGid                       = "${module.NSG_BEApps_Subnet_vNet1.Id}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"

}

######################################################################
# Infra zone
######################################################################


#INFRA_Subnet NSG


module "NSG_INFRA_Subnet_vNet1" {

    #Module location
    #source = "./Modules/07 NSG"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//07 NSG/"

    #Module variable
    NSGName                 = "NSG_${lookup(var.SubnetName, 2)}_vNet1"
    RGName                  = "${module.ResourceGroup.Name}"
    NSGLocation             = "${lookup(var.AzureRegion, 0)}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"


}

#INFRA_Subnet_vNet1

module "INFRA_Subnet_vNet1" {

    #Module location
    #source = "./Modules/06 Subnet"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 Subnet/"

    #Module variable
    SubnetName                  = "${lookup(var.SubnetName, 2)}"
    RGName                      = "${module.ResourceGroup.Name}"
    vNetName                    = "${module.vNet1.Name}"
    Subnetaddressprefix         = "${lookup(var.vNet1SubnetAddressRange, 2)}"
    NSGid                       = "${module.NSG_INFRA_Subnet_vNet1.Id}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"

}

######################################################################
# FE ADmin zone
######################################################################


#FEADMIN_Subnet NSG


module "NSG_FEADMIN_Subnet_vNet1" {

    #Module location
    #source = "./Modules/07 NSG"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//07 NSG/"

    #Module variable
    NSGName                 = "NSG_${lookup(var.SubnetName, 3)}_vNet1"
    RGName                  = "${module.ResourceGroup.Name}"
    NSGLocation             = "${lookup(var.AzureRegion, 0)}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"


}

#FEADMIN_Subnet

module "FEADMIN_Subnet_vNet1" {

    #Module location
    #source = "./Modules/06 Subnet"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 Subnet/"

    #Module variable
    SubnetName                  = "${lookup(var.SubnetName, 3)}"
    RGName                      = "${module.ResourceGroup.Name}"
    vNetName                    = "${module.vNet1.Name}"
    Subnetaddressprefix         = "${lookup(var.vNet1SubnetAddressRange, 3)}"
    NSGid                       = "${module.NSG_FEADMIN_Subnet_vNet1.Id}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"

}


######################################################################
# GW Subnet
######################################################################


#GW Subnet


module "GW_Subnet_vNet1" {

    #Module location
    source = "./Modules/SubnetGateway"
    #source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 Subnet/"

    #Module variable
    #SubnetName                  = "${lookup(var.SubnetName, 4)}"
    RGName                      = "${module.ResourceGroup.Name}"
    vNetName                    = "${module.vNet1.Name}"
    Subnetaddressprefix         = "${lookup(var.vNet1SubnetAddressRange, 4)}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"

}