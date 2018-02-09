##############################################################
#This file creates FE servers for subnet 2
##############################################################

#NSG rules for FE servers

module "AllowHTTPFromInternetFESubnet2In" {

    #Module source
    #source = "./Modules/08 NSGRule"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

    #Module variable
    RGName = "${module.ResourceGroup.Name}"
    NSGReference = "${module.NSG_FEApps_Subnet_vNet2.Name}"
    NSGRuleName = "AllowHTTPFromInternetFESubnet2In"
    NSGRulePriority = 101
    NSGRuleDirection = "Inbound"
    NSGRuleAccess = "Allow"
    NSGRuleProtocol = "Tcp"
    NSGRuleSourcePortRange = "*"
    NSGRuleDestinationPortRange = 80
    NSGRuleSourceAddressPrefix = "Internet"
    NSGRuleDestinationAddressPrefix = "${lookup(var.vNet2SubnetAddressRange, 0)}"
}





#Azure Load Balancer public IP Creation

module "LBWebPublicIP2" {

    #Module source
    #source = "./Modules/10 PublicIP"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//10 PublicIP"


    #Module variables
    PublicIPCount           = "1"
    PublicIPName            = "lbwebpip2"
    PublicIPLocation        = "${lookup(var.AzureRegion, 1)}"
    RGName                  = "${module.ResourceGroup.Name}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"


}

module "LBWebFE2" {

    #Module source
    #source = "./Modules/15 External LB"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//15 External LB"


    #Module variables
    LBCount             = "1"
    ExtLBName           = "LBWebFE2"
    AzureRegion         = "${lookup(var.AzureRegion, 1)}"
    RGName              = "${module.ResourceGroup.Name}"
    FEConfigName        = "LBWebFEConfig2"
    PublicIPId          = ["${module.LBWebPublicIP2.Ids}"]
    LBBackEndPoolName   = "LBWebFE_BEPool2"
    LBProbeName         = "LBWebFE_Probe2"
    LBProbePort         = "80"
    FERuleName          = "LBWebFEHTTPRule2"
    FERuleProtocol      = "tcp"
    FERuleFEPort        = "80"
    FERuleBEPort        = "80"
    TagEnvironment      = "${var.EnvironmentTag}"
    TagUsage            = "${var.EnvironmentUsageTag}"


} 

#Availability set creation


module "AS_FEGR2" {

    #Module source

    #source = "./Modules/13 AvailabilitySet"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//13 AvailabilitySet"


    #Module variables
    ASName                  = "AS_FEGR2"
    RGName                  = "${module.ResourceGroup.Name}"
    ASLocation              = "${lookup(var.AzureRegion, 1)}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"

}


#NIC Creation

module "NICs_FEGR2" {

    #module source

    #source = "./Modules/09 NICWithoutPIPWithCount"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//09 NICWithoutPIPWithCount"


    #Module variables

    NICcount            = "1"
    NICName             = "NIC_FEGR2"
    NICLocation         = "${lookup(var.AzureRegion, 1)}"
    RGName              = "${module.ResourceGroup.Name}"
    SubnetId            = "${module.FEApps_Subnet_vNet2.Id}"
    IsLoadBalanced      = "1"
    LBBackEndPoolid     = ["${module.LBWebFE2.LBBackendPoolIds}"]
    EnvironmentTag      = "${var.EnvironmentTag}"
    EnvironmentUsageTag = "${var.EnvironmentUsageTag}"


}

#Datadisk creation

module "DataDisks_FEGR2" {

    #Module source

    #source = "./Modules/06 ManagedDiskswithcount"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 ManagedDiskswithcount"


    #Module variables

    Manageddiskcount    = "1"
    ManageddiskName     = "DataDisk_FEGR2"
    RGName              = "${module.ResourceGroup.Name}"
    ManagedDiskLocation = "${lookup(var.AzureRegion, 1)}"
    StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
    CreateOption        = "Empty"
    DiskSizeInGB        = "63"
    EnvironmentTag      = "${var.EnvironmentTag}"
    EnvironmentUsageTag = "${var.EnvironmentUsageTag}"


}

#VM creation

module "VMs_FEGR2" {

    #module source

    #source = "./Modules/14 LinuxVMWithCount"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//14 LinuxVMWithCount"


    #Module variables

    VMCount                     = "1"
    VMName                      = "GR2-FE"
    VMLocation                  = "${lookup(var.AzureRegion, 1)}"
    VMRG                        = "${module.ResourceGroup.Name}"
    VMNICid                     = ["${module.NICs_FEGR2.LBIds}"]
    VMSize                      = "${lookup(var.VMSize, 0)}"
    ASID                        = "${module.AS_FEGR2.Id}"
    VMStorageTier               = "${lookup(var.Manageddiskstoragetier, 0)}"
    VMAdminName                 = "${var.VMAdminName}"
    VMAdminPassword             = "${var.VMAdminPassword}"
    DataDiskId                  = ["${module.DataDisks_FEGR2.Ids}"]
    DataDiskName                = ["${module.DataDisks_FEGR2.Names}"]
    DataDiskSize                = ["${module.DataDisks_FEGR2.Sizes}"]
    VMPublisherName             = "${lookup(var.PublisherName, 4)}"
    VMOffer                     = "${lookup(var.Offer, 4)}"
    VMsku                       = "${lookup(var.sku, 4)}"
    DiagnosticDiskURI           = "${module.DiagStorageAccount2.PrimaryBlobEP}"
    #BootConfigScriptFileName    = "${lookup(var.BootConfigScriptFileList, 2)}"
    PublicSSHKey                = "${var.AzurePublicSSHKey}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"

}

#VM Agent

module "CustomScriptForFEGR2" {

    #Module Location
    #source = "./Modules/19 CustomLinuxExtension-Ansible"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//22 CustomLinuxExtensionScript-Nginx"


    #Module variables
    AgentCount              = "1"
    AgentName               = "FEGR2CustomScript"
    AgentLocation           = "${lookup(var.AzureRegion, 1)}"
    AgentRG                 = "${module.ResourceGroup.Name}"
    VMName                  = ["${module.VMs_FEGR2.Name}"]
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}


#Network Watcher Agent

module "NetworkWatcherAgentForFEGR2" {

    #Module Location
    #source = "./Modules/20 LinuxNetworkWatcherAgent"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//20 LinuxNetworkWatcherAgent"


    #Module variables
    AgentCount              = "1"
    AgentName               = "NetworkWatcherAgentForFEGR2"
    AgentLocation           = "${lookup(var.AzureRegion, 1)}"
    AgentRG                 = "${module.ResourceGroup.Name}"
    VMName                  = ["${module.VMs_FEGR2.Name}"]
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}

