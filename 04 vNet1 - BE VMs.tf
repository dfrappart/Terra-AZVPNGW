##############################################################
#This file creates BE DB servers
##############################################################

#NSG Rules


#Availability set creation


module "AS_BEGR1" {

    #Module source

    #source = "./Modules/13 AvailabilitySet"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//13 AvailabilitySet"


    #Module variables
    ASName                  = "AS_BEGR1"
    RGName                  = "${module.ResourceGroup.Name}"
    ASLocation              = "${lookup(var.AzureRegion, 0)}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"

}


#NIC Creation

module "NICs_BEGR1" {

    #module source

    #source = "./Modules/09 NICWithoutPIPWithCount"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//09 NICWithoutPIPWithCount"


    #Module variables

    NICcount            = "1"
    NICName             = "NIC_BEGR1"
    NICLocation         = "${lookup(var.AzureRegion, 0)}"
    RGName              = "${module.ResourceGroup.Name}"
    SubnetId            = "${module.BEApps_Subnet_vNet1.Id}"
    EnvironmentTag      = "${var.EnvironmentTag}"
    EnvironmentUsageTag = "${var.EnvironmentUsageTag}"


}

#Datadisk creation

module "DataDisks_BEGR1" {

    #Module source

    #source = "./Modules/06 ManagedDiskswithcount"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 ManagedDiskswithcount"


    #Module variables

    Manageddiskcount    = "1"
    ManageddiskName     = "DataDisk_BEGR1"
    RGName              = "${module.ResourceGroup.Name}"
    ManagedDiskLocation = "${lookup(var.AzureRegion, 0)}"
    StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
    CreateOption        = "Empty"
    DiskSizeInGB        = "63"
    EnvironmentTag      = "${var.EnvironmentTag}"
    EnvironmentUsageTag = "${var.EnvironmentUsageTag}"


}

#VM creation

module "VMs_BEGR1" {

    #module source

    #source = "./Modules/14 LinuxVMWithCount"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//14 LinuxVMWithCount"


    #Module variables

    VMCount                     = "1"
    VMName                      = "GR1-BE"
    VMLocation                  = "${lookup(var.AzureRegion, 0)}"
    VMRG                        = "${module.ResourceGroup.Name}"
    VMNICid                     = ["${module.NICs_BEGR1.Ids}"]
    VMSize                      = "${lookup(var.VMSize, 0)}"
    ASID                        = "${module.AS_BEGR1.Id}"
    VMStorageTier               = "${lookup(var.Manageddiskstoragetier, 0)}"
    VMAdminName                 = "${var.VMAdminName}"
    VMAdminPassword             = "${var.VMAdminPassword}"
    DataDiskId                  = ["${module.DataDisks_BEGR1.Ids}"]
    DataDiskName                = ["${module.DataDisks_BEGR1.Names}"]
    DataDiskSize                = ["${module.DataDisks_BEGR1.Sizes}"]
    VMPublisherName             = "${lookup(var.PublisherName, 4)}"
    VMOffer                     = "${lookup(var.Offer, 4)}"
    VMsku                       = "${lookup(var.sku, 4)}"
    DiagnosticDiskURI           = "${module.DiagStorageAccount1.PrimaryBlobEP}"
    #BootConfigScriptFileName    = "${lookup(var.BootConfigScriptFileList, 2)}"
    PublicSSHKey                = "${var.AzurePublicSSHKey}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"

}

#VM Agent


module "CustomScriptForBEGR1" {

    #Module Location
    #source = "./Modules/19 CustomLinuxExtension-Ansible"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//23 CustomLinuxExtension-Docker"


    #Module variables
    AgentCount              = "1"
    AgentName               = "BEGR1CustomScript"
    AgentLocation           = "${lookup(var.AzureRegion, 0)}"
    AgentRG                 = "${module.ResourceGroup.Name}"
    VMName                  = ["${module.VMs_BEGR1.Name}"]
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}



#Network Watcher Agent

module "NetworkWatcherAgentForBEGR1" {

    #Module Location
    #source = "./Modules/20 LinuxNetworkWatcherAgent"
    source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//20 LinuxNetworkWatcherAgent"

    #Module variables
    AgentCount              = "1"
    AgentName               = "NetworkWatcherAgentForBEGR1"
    AgentLocation           = "${lookup(var.AzureRegion, 0)}"
    AgentRG                 = "${module.ResourceGroup.Name}"
    VMName                  = ["${module.VMs_BEGR1.Name}"]
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}

