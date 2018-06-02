##############################################################
#This file creates BE servers
##############################################################

#NSG Rules

module "AllowSSHFromInternettoFEAdminIn" {
  #Module source
  #source = "./Modules/08 NSGRule"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName                          = "${module.ResourceGroup.Name}"
  NSGReference                    = "${module.NSG_FEADMIN_Subnet_vNet1.Name}"
  NSGRuleName                     = "AllowSSHFromInternetBastionIn"
  NSGRulePriority                 = 101
  NSGRuleDirection                = "Inbound"
  NSGRuleAccess                   = "Allow"
  NSGRuleProtocol                 = "Tcp"
  NSGRuleSourcePortRange          = "*"
  NSGRuleDestinationPortRange     = 22
  NSGRuleSourceAddressPrefix      = "Internet"
  NSGRuleDestinationAddressPrefix = "${lookup(var.vNet1SubnetAddressRange, 3)}"
}

module "AllowRDPFromInternettoFEAdminIn" {
  #Module source
  #source = "./Modules/08 NSGRule"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName                          = "${module.ResourceGroup.Name}"
  NSGReference                    = "${module.NSG_FEADMIN_Subnet_vNet1.Name}"
  NSGRuleName                     = "AllowRDPFromInternettoFEAdminIn"
  NSGRulePriority                 = 102
  NSGRuleDirection                = "Inbound"
  NSGRuleAccess                   = "Allow"
  NSGRuleProtocol                 = "Tcp"
  NSGRuleSourcePortRange          = "*"
  NSGRuleDestinationPortRange     = 3389
  NSGRuleSourceAddressPrefix      = "Internet"
  NSGRuleDestinationAddressPrefix = "${lookup(var.vNet1SubnetAddressRange, 3)}"
}

#NSG rules for vNet to vNet Connectivity

module "AllowAllFromvNet2toFEAdminIn" {
  #Module source
  source = "./Modules/01 NSGRule_Multiplerange"

  #source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName                          = "${module.ResourceGroup.Name}"
  NSGReference                    = "${module.NSG_FEADMIN_Subnet_vNet1.Name}"
  NSGRuleName                     = "AllowAllFromvNet2toFEAdminIn"
  NSGRulePriority                 = 106
  NSGRuleDirection                = "Inbound"
  NSGRuleAccess                   = "Allow"
  NSGRuleProtocol                 = "*"
  NSGRuleSourcePortRange          = ["*"]
  NSGRuleDestinationPortRange     = ["*"]
  NSGRuleSourceAddressPrefix      = "${var.vNet2IPRange}"
  NSGRuleDestinationAddressPrefix = ["${lookup(var.vNet1SubnetAddressRange, 3)}"]
}

module "AllowAllFromFEAdmintovNet2Out" {
  #Module source
  source = "./Modules/01 NSGRule_Multiplerange"

  #source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName                            = "${module.ResourceGroup.Name}"
  NSGReference                      = "${module.NSG_FEADMIN_Subnet_vNet1.Name}"
  NSGRuleName                       = "AllowAllFromFEAdmintovNet2Out"
  NSGRulePriority                   = 107
  NSGRuleDirection                  = "Outbound"
  NSGRuleAccess                     = "Allow"
  NSGRuleProtocol                   = "*"
  NSGRuleSourcePortRanges           = ["*"]
  NSGRuleDestinationPortRanges      = ["*"]
  NSGRuleSourceAddressPrefixes      = ["${lookup(var.vNet1SubnetAddressRange, 3)}"]
  NSGRuleDestinationAddressPrefixes = "${var.vNet2IPRange}"
}

#Bastion public IP Creation

module "BastionPublicIP" {
  #Module source
  #source = "./Modules/10 PublicIP"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//10 PublicIP"

  #Module variables
  PublicIPCount       = "1"
  PublicIPName        = "bastionpip"
  PublicIPLocation    = "${lookup(var.AzureRegion, 0)}"
  RGName              = "${module.ResourceGroup.Name}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Jump public IP Creation

module "JumpPublicIP" {
  #Module source
  #source = "./Modules/10 PublicIP"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//10 PublicIP"

  #Module variables
  PublicIPCount       = "1"
  PublicIPName        = "jumppip"
  PublicIPLocation    = "${lookup(var.AzureRegion, 0)}"
  RGName              = "${module.ResourceGroup.Name}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Availability set creation

module "AS_Bastion" {
  #Module source

  #source = "./Modules/13 AvailabilitySet"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//13 AvailabilitySet"

  #Module variables
  ASName              = "AS_Bastion"
  RGName              = "${module.ResourceGroup.Name}"
  ASLocation          = "${lookup(var.AzureRegion, 0)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "AS_Jump" {
  #Module source

  #source = "./Modules/13 AvailabilitySet"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//13 AvailabilitySet"

  #Module variables
  ASName              = "AS_Jump"
  RGName              = "${module.ResourceGroup.Name}"
  ASLocation          = "${lookup(var.AzureRegion, 0)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#NIC Creation

module "NICs_Bastion" {
  #module source

  #source = "./Modules/12 NICwithPIPWithCount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//12 NICwithPIPWithCount"

  #Module variables

  NICCount            = "1"
  NICName             = "NIC_Bastion"
  NICLocation         = "${lookup(var.AzureRegion, 0)}"
  RGName              = "${module.ResourceGroup.Name}"
  SubnetId            = "${module.FEADMIN_Subnet_vNet1.Id}"
  PublicIPId          = ["${module.BastionPublicIP.Ids}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "NICs_Jump" {
  #module source

  #source = "./Modules/12 NICwithPIPWithCount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//12 NICwithPIPWithCount"

  #Module variables

  NICCount            = "1"
  NICName             = "NIC_Jump"
  NICLocation         = "${lookup(var.AzureRegion, 0)}"
  RGName              = "${module.ResourceGroup.Name}"
  SubnetId            = "${module.FEADMIN_Subnet_vNet1.Id}"
  PublicIPId          = ["${module.JumpPublicIP.Ids}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "DataDisks_Bastion" {
  #Module source

  #source = "./Modules/06 ManagedDiskswithcount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 ManagedDiskswithcount"

  #Module variables

  Manageddiskcount    = "1"
  ManageddiskName     = "DataDisk_Bastion"
  RGName              = "${module.ResourceGroup.Name}"
  ManagedDiskLocation = "${lookup(var.AzureRegion, 0)}"
  StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
  CreateOption        = "Empty"
  DiskSizeInGB        = "63"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "DataDisks_Jump" {
  #Module source

  #source = "./Modules/06 ManagedDiskswithcount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 ManagedDiskswithcount"

  #Module variables

  Manageddiskcount    = "1"
  ManageddiskName     = "DataDisk_Jump"
  RGName              = "${module.ResourceGroup.Name}"
  ManagedDiskLocation = "${lookup(var.AzureRegion, 0)}"
  StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
  CreateOption        = "Empty"
  DiskSizeInGB        = "63"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM creation

module "VMs_Bastion" {
  #module source

  #source = "./Modules/14 LinuxVMWithCount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//14 LinuxVMWithCount"

  #Module variables

  VMCount           = "1"
  VMName            = "Bastion"
  VMLocation        = "${lookup(var.AzureRegion, 0)}"
  VMRG              = "${module.ResourceGroup.Name}"
  VMNICid           = ["${module.NICs_Bastion.Ids}"]
  VMSize            = "${lookup(var.VMSize, 0)}"
  ASID              = "${module.AS_Bastion.Id}"
  VMStorageTier     = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName       = "${var.VMAdminName}"
  VMAdminPassword   = "${var.VMAdminPassword}"
  DataDiskId        = ["${module.DataDisks_Bastion.Ids}"]
  DataDiskName      = ["${module.DataDisks_Bastion.Names}"]
  DataDiskSize      = ["${module.DataDisks_Bastion.Sizes}"]
  VMPublisherName   = "${lookup(var.PublisherName, 4)}"
  VMOffer           = "${lookup(var.Offer, 4)}"
  VMsku             = "${lookup(var.sku, 4)}"
  DiagnosticDiskURI = "${module.DiagStorageAccount1.PrimaryBlobEP}"
  #BootConfigScriptFileName    = "${lookup(var.BootConfigScriptFileList, 1)}"
  PublicSSHKey        = "${var.AzurePublicSSHKey}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "CustomScriptForBastion" {
  #Module Location
  #source = "./Modules/19 CustomLinuxExtension-Ansible"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//19 CustomLinuxExtension-Ansible"

  #Module variables
  AgentCount          = "1"
  AgentName           = "BastionCustomScript"
  AgentLocation       = "${lookup(var.AzureRegion, 0)}"
  AgentRG             = "${module.ResourceGroup.Name}"
  VMName              = ["${module.VMs_Bastion.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "NetworkWatcherAgentForBastion" {
  #Module Location
  #source = "./Modules/20 LinuxNetworkWatcherAgent"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//20 LinuxNetworkWatcherAgent"

  #Module variables
  AgentCount          = "1"
  AgentName           = "NetworkWatcherAgentForBastion"
  AgentLocation       = "${lookup(var.AzureRegion, 0)}"
  AgentRG             = "${module.ResourceGroup.Name}"
  VMName              = ["${module.VMs_Bastion.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "VMs_Jump" {
  #module source

  #source = "./Modules/WinVMWithCount"
  source = "github.com/dfrappart/Terra-AZBasicWinWithModules//Modules//WinVMWithCount"

  #Module variables

  VMCount             = "1"
  VMName              = "Jump"
  VMLocation          = "${lookup(var.AzureRegion, 0)}"
  VMRG                = "${module.ResourceGroup.Name}"
  VMNICid             = ["${module.NICs_Jump.Ids}"]
  VMSize              = "${lookup(var.VMSize, 1)}"
  ASID                = "${module.AS_Jump.Id}"
  VMStorageTier       = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName         = "${var.VMAdminName}"
  VMAdminPassword     = "${var.VMAdminPassword}"
  DataDiskId          = ["${module.DataDisks_Jump.Ids}"]
  DataDiskName        = ["${module.DataDisks_Jump.Names}"]
  DataDiskSize        = ["${module.DataDisks_Jump.Sizes}"]
  VMPublisherName     = "${lookup(var.PublisherName, 0)}"
  VMOffer             = "${lookup(var.Offer, 0)}"
  VMsku               = "${lookup(var.sku, 0)}"
  DiagnosticDiskURI   = "${module.DiagStorageAccount1.PrimaryBlobEP}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM Agent

#Network Watcher Agent

module "NetworkWatcherAgentForJump" {
  #Module Location
  #source = "./Modules/NetworkWatcherAgentWin"
  source = "github.com/dfrappart/Terra-AZBasicWinWithModules//Modules//NetworkWatcherAgentWin"

  #Module variables
  AgentCount          = "1"
  AgentName           = "NetworkWatcherAgentForJump"
  AgentLocation       = "${lookup(var.AzureRegion, 0)}"
  AgentRG             = "${module.ResourceGroup.Name}"
  VMName              = ["${module.VMs_Jump.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

##############################################################
#This file creates BE servers
##############################################################

#NSG Rules

module "AllowSSHFromInternettoFEAdminIn" {
  #Module source
  #source = "./Modules/08 NSGRule"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName                          = "${module.ResourceGroup.Name}"
  NSGReference                    = "${module.NSG_FEADMIN_Subnet_vNet1.Name}"
  NSGRuleName                     = "AllowSSHFromInternetBastionIn"
  NSGRulePriority                 = 101
  NSGRuleDirection                = "Inbound"
  NSGRuleAccess                   = "Allow"
  NSGRuleProtocol                 = "Tcp"
  NSGRuleSourcePortRange          = "*"
  NSGRuleDestinationPortRange     = 22
  NSGRuleSourceAddressPrefix      = "Internet"
  NSGRuleDestinationAddressPrefix = "${lookup(var.vNet1SubnetAddressRange, 3)}"
}

module "AllowRDPFromInternettoFEAdminIn" {
  #Module source
  #source = "./Modules/08 NSGRule"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName                          = "${module.ResourceGroup.Name}"
  NSGReference                    = "${module.NSG_FEADMIN_Subnet_vNet1.Name}"
  NSGRuleName                     = "AllowRDPFromInternettoFEAdminIn"
  NSGRulePriority                 = 102
  NSGRuleDirection                = "Inbound"
  NSGRuleAccess                   = "Allow"
  NSGRuleProtocol                 = "Tcp"
  NSGRuleSourcePortRange          = "*"
  NSGRuleDestinationPortRange     = 3389
  NSGRuleSourceAddressPrefix      = "Internet"
  NSGRuleDestinationAddressPrefix = "${lookup(var.vNet1SubnetAddressRange, 3)}"
}

#NSG rules for vNet to vNet Connectivity

module "AllowAllFromvNet2toFEAdminIn" {
  #Module source
  source = "./Modules/01 NSGRule_Multiplerange"

  #source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName                          = "${module.ResourceGroup.Name}"
  NSGReference                    = "${module.NSG_FEADMIN_Subnet_vNet1.Name}"
  NSGRuleName                     = "AllowAllFromvNet2toFEAdminIn"
  NSGRulePriority                 = 106
  NSGRuleDirection                = "Inbound"
  NSGRuleAccess                   = "Allow"
  NSGRuleProtocol                 = "*"
  NSGRuleSourcePortRange          = ["*"]
  NSGRuleDestinationPortRange     = ["*"]
  NSGRuleSourceAddressPrefix      = "${var.vNet2IPRange}"
  NSGRuleDestinationAddressPrefix = ["${lookup(var.vNet1SubnetAddressRange, 3)}"]
}

module "AllowAllFromFEAdmintovNet2Out" {
  #Module source
  source = "./Modules/01 NSGRule_Multiplerange"

  #source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName                            = "${module.ResourceGroup.Name}"
  NSGReference                      = "${module.NSG_FEADMIN_Subnet_vNet1.Name}"
  NSGRuleName                       = "AllowAllFromFEAdmintovNet2Out"
  NSGRulePriority                   = 107
  NSGRuleDirection                  = "Outbound"
  NSGRuleAccess                     = "Allow"
  NSGRuleProtocol                   = "*"
  NSGRuleSourcePortRanges           = ["*"]
  NSGRuleDestinationPortRanges      = ["*"]
  NSGRuleSourceAddressPrefixes      = ["${lookup(var.vNet1SubnetAddressRange, 3)}"]
  NSGRuleDestinationAddressPrefixes = "${var.vNet2IPRange}"
}

#Bastion public IP Creation

module "BastionPublicIP" {
  #Module source
  #source = "./Modules/10 PublicIP"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//10 PublicIP"

  #Module variables
  PublicIPCount       = "1"
  PublicIPName        = "bastionpip"
  PublicIPLocation    = "${lookup(var.AzureRegion, 0)}"
  RGName              = "${module.ResourceGroup.Name}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Jump public IP Creation

module "JumpPublicIP" {
  #Module source
  #source = "./Modules/10 PublicIP"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//10 PublicIP"

  #Module variables
  PublicIPCount       = "1"
  PublicIPName        = "jumppip"
  PublicIPLocation    = "${lookup(var.AzureRegion, 0)}"
  RGName              = "${module.ResourceGroup.Name}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Availability set creation

module "AS_Bastion" {
  #Module source

  #source = "./Modules/13 AvailabilitySet"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//13 AvailabilitySet"

  #Module variables
  ASName              = "AS_Bastion"
  RGName              = "${module.ResourceGroup.Name}"
  ASLocation          = "${lookup(var.AzureRegion, 0)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "AS_Jump" {
  #Module source

  #source = "./Modules/13 AvailabilitySet"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//13 AvailabilitySet"

  #Module variables
  ASName              = "AS_Jump"
  RGName              = "${module.ResourceGroup.Name}"
  ASLocation          = "${lookup(var.AzureRegion, 0)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#NIC Creation

module "NICs_Bastion" {
  #module source

  #source = "./Modules/12 NICwithPIPWithCount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//12 NICwithPIPWithCount"

  #Module variables

  NICCount            = "1"
  NICName             = "NIC_Bastion"
  NICLocation         = "${lookup(var.AzureRegion, 0)}"
  RGName              = "${module.ResourceGroup.Name}"
  SubnetId            = "${module.FEADMIN_Subnet_vNet1.Id}"
  PublicIPId          = ["${module.BastionPublicIP.Ids}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "NICs_Jump" {
  #module source

  #source = "./Modules/12 NICwithPIPWithCount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//12 NICwithPIPWithCount"

  #Module variables

  NICCount            = "1"
  NICName             = "NIC_Jump"
  NICLocation         = "${lookup(var.AzureRegion, 0)}"
  RGName              = "${module.ResourceGroup.Name}"
  SubnetId            = "${module.FEADMIN_Subnet_vNet1.Id}"
  PublicIPId          = ["${module.JumpPublicIP.Ids}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "DataDisks_Bastion" {
  #Module source

  #source = "./Modules/06 ManagedDiskswithcount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 ManagedDiskswithcount"

  #Module variables

  Manageddiskcount    = "1"
  ManageddiskName     = "DataDisk_Bastion"
  RGName              = "${module.ResourceGroup.Name}"
  ManagedDiskLocation = "${lookup(var.AzureRegion, 0)}"
  StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
  CreateOption        = "Empty"
  DiskSizeInGB        = "63"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "DataDisks_Jump" {
  #Module source

  #source = "./Modules/06 ManagedDiskswithcount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 ManagedDiskswithcount"

  #Module variables

  Manageddiskcount    = "1"
  ManageddiskName     = "DataDisk_Jump"
  RGName              = "${module.ResourceGroup.Name}"
  ManagedDiskLocation = "${lookup(var.AzureRegion, 0)}"
  StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
  CreateOption        = "Empty"
  DiskSizeInGB        = "63"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM creation

module "VMs_Bastion" {
  #module source

  #source = "./Modules/14 LinuxVMWithCount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//14 LinuxVMWithCount"

  #Module variables

  VMCount           = "1"
  VMName            = "Bastion"
  VMLocation        = "${lookup(var.AzureRegion, 0)}"
  VMRG              = "${module.ResourceGroup.Name}"
  VMNICid           = ["${module.NICs_Bastion.Ids}"]
  VMSize            = "${lookup(var.VMSize, 0)}"
  ASID              = "${module.AS_Bastion.Id}"
  VMStorageTier     = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName       = "${var.VMAdminName}"
  VMAdminPassword   = "${var.VMAdminPassword}"
  DataDiskId        = ["${module.DataDisks_Bastion.Ids}"]
  DataDiskName      = ["${module.DataDisks_Bastion.Names}"]
  DataDiskSize      = ["${module.DataDisks_Bastion.Sizes}"]
  VMPublisherName   = "${lookup(var.PublisherName, 4)}"
  VMOffer           = "${lookup(var.Offer, 4)}"
  VMsku             = "${lookup(var.sku, 4)}"
  DiagnosticDiskURI = "${module.DiagStorageAccount1.PrimaryBlobEP}"
  #BootConfigScriptFileName    = "${lookup(var.BootConfigScriptFileList, 1)}"
  PublicSSHKey        = "${var.AzurePublicSSHKey}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "CustomScriptForBastion" {
  #Module Location
  #source = "./Modules/19 CustomLinuxExtension-Ansible"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//19 CustomLinuxExtension-Ansible"

  #Module variables
  AgentCount          = "1"
  AgentName           = "BastionCustomScript"
  AgentLocation       = "${lookup(var.AzureRegion, 0)}"
  AgentRG             = "${module.ResourceGroup.Name}"
  VMName              = ["${module.VMs_Bastion.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "NetworkWatcherAgentForBastion" {
  #Module Location
  #source = "./Modules/20 LinuxNetworkWatcherAgent"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//20 LinuxNetworkWatcherAgent"

  #Module variables
  AgentCount          = "1"
  AgentName           = "NetworkWatcherAgentForBastion"
  AgentLocation       = "${lookup(var.AzureRegion, 0)}"
  AgentRG             = "${module.ResourceGroup.Name}"
  VMName              = ["${module.VMs_Bastion.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "VMs_Jump" {
  #module source

  #source = "./Modules/WinVMWithCount"
  source = "github.com/dfrappart/Terra-AZBasicWinWithModules//Modules//WinVMWithCount"

  #Module variables

  VMCount             = "1"
  VMName              = "Jump"
  VMLocation          = "${lookup(var.AzureRegion, 0)}"
  VMRG                = "${module.ResourceGroup.Name}"
  VMNICid             = ["${module.NICs_Jump.Ids}"]
  VMSize              = "${lookup(var.VMSize, 1)}"
  ASID                = "${module.AS_Jump.Id}"
  VMStorageTier       = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName         = "${var.VMAdminName}"
  VMAdminPassword     = "${var.VMAdminPassword}"
  DataDiskId          = ["${module.DataDisks_Jump.Ids}"]
  DataDiskName        = ["${module.DataDisks_Jump.Names}"]
  DataDiskSize        = ["${module.DataDisks_Jump.Sizes}"]
  VMPublisherName     = "${lookup(var.PublisherName, 0)}"
  VMOffer             = "${lookup(var.Offer, 0)}"
  VMsku               = "${lookup(var.sku, 0)}"
  DiagnosticDiskURI   = "${module.DiagStorageAccount1.PrimaryBlobEP}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM Agent

#Network Watcher Agent

module "NetworkWatcherAgentForJump" {
  #Module Location
  #source = "./Modules/NetworkWatcherAgentWin"
  source = "github.com/dfrappart/Terra-AZBasicWinWithModules//Modules//NetworkWatcherAgentWin"

  #Module variables
  AgentCount          = "1"
  AgentName           = "NetworkWatcherAgentForJump"
  AgentLocation       = "${lookup(var.AzureRegion, 0)}"
  AgentRG             = "${module.ResourceGroup.Name}"
  VMName              = ["${module.VMs_Jump.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}
