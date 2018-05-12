##############################################################
#This file creates BE DB servers
##############################################################

#NSG Rules

#NSG rules for vNet to vNet Connectivity

module "AllowAllFromvNet1toBEAppsIn" {
  #Module source
  source = "./Modules/01 NSGRule_Multiplerange"

  #source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName           = "${module.ResourceGroup.Name}"
  NSGReference     = "${module.NSG_BEApps_Subnet_vNet2.Name}"
  NSGRuleName      = "AllowAllFromvNet1toBEAppsIn"
  NSGRulePriority  = 102
  NSGRuleDirection = "Inbound"
  NSGRuleAccess    = "Allow"
  NSGRuleProtocol  = "*"
  #NSGRuleSourcePortRanges                  = ["${var.AllNetworkPorts}"]
  NSGRuleDestinationPortRanges      = ["${var.AllNetworkPorts}"]
  NSGRuleSourceAddressPrefixes      = "${var.vNet1IPRange}"
  NSGRuleDestinationAddressPrefixes = ["${lookup(var.vNet2SubnetAddressRange, 1)}"]
}

module "AllowAllFromBEAppstovNet1Out" {
  #Module source
  source = "./Modules/01 NSGRule_Multiplerange"

  #source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName           = "${module.ResourceGroup.Name}"
  NSGReference     = "${module.NSG_BEApps_Subnet_vNet2.Name}"
  NSGRuleName      = "AllowAllFromBEAppstovNet1Out"
  NSGRulePriority  = 103
  NSGRuleDirection = "Outbound"
  NSGRuleAccess    = "Allow"
  NSGRuleProtocol  = "*"
  #NSGRuleSourcePortRange                  = ["${var.AllNetworkPorts}"]
  NSGRuleDestinationPortRange     = ["${var.AllNetworkPorts}"]
  NSGRuleSourceAddressPrefix      = ["${lookup(var.vNet2SubnetAddressRange, 1)}"]
  NSGRuleDestinationAddressPrefix = "${var.vNet1IPRange}"
}

#Availability set creation

module "AS_BEGR2" {
  #Module source

  #source = "./Modules/13 AvailabilitySet"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//13 AvailabilitySet"

  #Module variables
  ASName              = "AS_BEGR2"
  RGName              = "${module.ResourceGroup.Name}"
  ASLocation          = "${lookup(var.AzureRegion, 1)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#NIC Creation

module "NICs_BEGR2" {
  #module source

  #source = "./Modules/09 NICWithoutPIPWithCount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//09 NICWithoutPIPWithCount"

  #Module variables

  NICcount            = "1"
  NICName             = "NIC_BEGR2"
  NICLocation         = "${lookup(var.AzureRegion, 1)}"
  RGName              = "${module.ResourceGroup.Name}"
  SubnetId            = "${module.BEApps_Subnet_vNet2.Id}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "DataDisks_BEGR2" {
  #Module source

  #source = "./Modules/06 ManagedDiskswithcount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 ManagedDiskswithcount"

  #Module variables

  Manageddiskcount    = "1"
  ManageddiskName     = "DataDisk_BEGR2"
  RGName              = "${module.ResourceGroup.Name}"
  ManagedDiskLocation = "${lookup(var.AzureRegion, 1)}"
  StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
  CreateOption        = "Empty"
  DiskSizeInGB        = "63"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM creation

module "VMs_BEGR2" {
  #module source

  #source = "./Modules/14 LinuxVMWithCount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//14 LinuxVMWithCount"

  #Module variables

  VMCount           = "1"
  VMName            = "GR2-BE"
  VMLocation        = "${lookup(var.AzureRegion, 1)}"
  VMRG              = "${module.ResourceGroup.Name}"
  VMNICid           = ["${module.NICs_BEGR2.Ids}"]
  VMSize            = "${lookup(var.VMSize, 0)}"
  ASID              = "${module.AS_BEGR2.Id}"
  VMStorageTier     = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName       = "${var.VMAdminName}"
  VMAdminPassword   = "${var.VMAdminPassword}"
  DataDiskId        = ["${module.DataDisks_BEGR2.Ids}"]
  DataDiskName      = ["${module.DataDisks_BEGR2.Names}"]
  DataDiskSize      = ["${module.DataDisks_BEGR2.Sizes}"]
  VMPublisherName   = "${lookup(var.PublisherName, 4)}"
  VMOffer           = "${lookup(var.Offer, 4)}"
  VMsku             = "${lookup(var.sku, 4)}"
  DiagnosticDiskURI = "${module.DiagStorageAccount2.PrimaryBlobEP}"
  #BootConfigScriptFileName    = "${lookup(var.BootConfigScriptFileList, 2)}"
  PublicSSHKey        = "${var.AzurePublicSSHKey}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM Agent

module "CustomScriptForBEGR2" {
  #Module Location

  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//23 CustomLinuxExtension-Docker"

  #Module variables
  AgentCount          = "1"
  AgentName           = "BEGR2CustomScript"
  AgentLocation       = "${lookup(var.AzureRegion, 1)}"
  AgentRG             = "${module.ResourceGroup.Name}"
  VMName              = ["${module.VMs_BEGR2.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Network Watcher Agent

module "NetworkWatcherAgentForBEGR2" {
  #Module Location
  #source = "./Modules/20 LinuxNetworkWatcherAgent"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//20 LinuxNetworkWatcherAgent"

  #Module variables
  AgentCount          = "1"
  AgentName           = "NetworkWatcherAgentForBEGR2"
  AgentLocation       = "${lookup(var.AzureRegion, 1)}"
  AgentRG             = "${module.ResourceGroup.Name}"
  VMName              = ["${module.VMs_BEGR2.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}
