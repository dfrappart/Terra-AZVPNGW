##############################################################
#This file creates FE servers
##############################################################

#NSG rules for FE servers

module "AllowHTTPFromInternetFESubnet1In" {
  #Module source
  source = "./Modules/01 NSGRule_Multiplerange"

  #source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName           = "${module.ResourceGroup.Name}"
  NSGReference     = "${module.NSG_FEApps_Subnet_vNet1.Name}"
  NSGRuleName      = "AllowHTTPFromInternetFESubnet1In"
  NSGRulePriority  = 101
  NSGRuleDirection = "Inbound"
  NSGRuleAccess    = "Allow"
  NSGRuleProtocol  = "Tcp"
  #NSGRuleSourcePortRanges          = "*"
  NSGRuleDestinationPortRanges      = "${var.WebPorts}"
  NSGRuleSourceAddressPrefixes      = "${var.InternetRange}"
  NSGRuleDestinationAddressPrefixes = ["${lookup(var.vNet1SubnetAddressRange, 0)}"]
}

#NSG rules for vNet to vNet Connectivity

module "AllowAllFromvNet2toFEAppsIn" {
  #Module source
  source = "./Modules/01 NSGRule_Multiplerange"

  #source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName           = "${module.ResourceGroup.Name}"
  NSGReference     = "${module.NSG_FEApps_Subnet_vNet1.Name}"
  NSGRuleName      = "AllowAllFromvNet2toFEAppsIn"
  NSGRulePriority  = 102
  NSGRuleDirection = "Inbound"
  NSGRuleAccess    = "Allow"
  NSGRuleProtocol  = "*"
  #NSGRuleSourcePortRanges           = ["${var.AllNetworkPorts}"]
  NSGRuleDestinationPortRanges      = ["${var.AllNetworkPorts}"]
  NSGRuleSourceAddressPrefixes      = "${var.vNet2IPRange}"
  NSGRuleDestinationAddressPrefixes = ["${lookup(var.vNet1SubnetAddressRange, 0)}"]
}

module "AllowAllFromFEAppstovNet2Out" {
  #Module source
  source = "./Modules/01 NSGRule_Multiplerange"

  #source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName           = "${module.ResourceGroup.Name}"
  NSGReference     = "${module.NSG_FEApps_Subnet_vNet1.Name}"
  NSGRuleName      = "AllowAllFromFEAppstovNet2Out"
  NSGRulePriority  = 103
  NSGRuleDirection = "Outbound"
  NSGRuleAccess    = "Allow"
  NSGRuleProtocol  = "*"
  #NSGRuleSourcePortRanges           = ["${var.AllNetworkPorts}"]
  NSGRuleDestinationPortRanges      = ["${var.AllNetworkPorts}"]
  NSGRuleSourceAddressPrefixes      = ["${lookup(var.vNet1SubnetAddressRange, 0)}"]
  NSGRuleDestinationAddressPrefixes = "${var.vNet2IPRange}"
}

#Azure Load Balancer public IP Creation

module "LBWebPublicIP1" {
  #Module source
  #source = "./Modules/10 PublicIP"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//10 PublicIP"

  #Module variables
  PublicIPCount       = "1"
  PublicIPName        = "lbwebpip1"
  PublicIPLocation    = "${lookup(var.AzureRegion, 0)}"
  RGName              = "${module.ResourceGroup.Name}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "LBWebFE1" {
  #Module source
  #source = "./Modules/15 External LB"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//15 External LB"

  #Module variables
  LBCount           = "1"
  ExtLBName         = "LBWebFE1"
  AzureRegion       = "${lookup(var.AzureRegion, 0)}"
  RGName            = "${module.ResourceGroup.Name}"
  FEConfigName      = "LBWebFEConfig1"
  PublicIPId        = ["${module.LBWebPublicIP1.Ids}"]
  LBBackEndPoolName = "LBWebFE_BEPool1"
  LBProbeName       = "LBWebFE_Probe1"
  LBProbePort       = "80"
  FERuleName        = "LBWebFEHTTPRule1"
  FERuleProtocol    = "tcp"
  FERuleFEPort      = "80"
  FERuleBEPort      = "80"
  TagEnvironment    = "${var.EnvironmentTag}"
  TagUsage          = "${var.EnvironmentUsageTag}"
}

#Availability set creation

module "AS_FEGR1" {
  #Module source

  #source = "./Modules/13 AvailabilitySet"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//13 AvailabilitySet"

  #Module variables
  ASName              = "AS_FEGR1"
  RGName              = "${module.ResourceGroup.Name}"
  ASLocation          = "${lookup(var.AzureRegion, 0)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#NIC Creation

module "NICs_FEGR1" {
  #module source

  #source = "./Modules/09 NICWithoutPIPWithCount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//09 NICWithoutPIPWithCount"

  #Module variables

  NICcount            = "1"
  NICName             = "NIC_FEGR1"
  NICLocation         = "${lookup(var.AzureRegion, 0)}"
  RGName              = "${module.ResourceGroup.Name}"
  SubnetId            = "${module.FEApps_Subnet_vNet1.Id}"
  IsLoadBalanced      = "1"
  LBBackEndPoolid     = ["${module.LBWebFE1.LBBackendPoolIds}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "DataDisks_FEGR1" {
  #Module source

  #source = "./Modules/06 ManagedDiskswithcount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 ManagedDiskswithcount"

  #Module variables

  Manageddiskcount    = "1"
  ManageddiskName     = "DataDisk_FEGR1"
  RGName              = "${module.ResourceGroup.Name}"
  ManagedDiskLocation = "${lookup(var.AzureRegion, 0)}"
  StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
  CreateOption        = "Empty"
  DiskSizeInGB        = "63"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM creation

module "VMs_FEGR1" {
  #module source

  #source = "./Modules/14 LinuxVMWithCount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//14 LinuxVMWithCount"

  #Module variables

  VMCount           = "1"
  VMName            = "GR1-FE"
  VMLocation        = "${lookup(var.AzureRegion, 0)}"
  VMRG              = "${module.ResourceGroup.Name}"
  VMNICid           = ["${module.NICs_FEGR1.LBIds}"]
  VMSize            = "${lookup(var.VMSize, 0)}"
  ASID              = "${module.AS_FEGR1.Id}"
  VMStorageTier     = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName       = "${var.VMAdminName}"
  VMAdminPassword   = "${var.VMAdminPassword}"
  DataDiskId        = ["${module.DataDisks_FEGR1.Ids}"]
  DataDiskName      = ["${module.DataDisks_FEGR1.Names}"]
  DataDiskSize      = ["${module.DataDisks_FEGR1.Sizes}"]
  VMPublisherName   = "${lookup(var.PublisherName, 4)}"
  VMOffer           = "${lookup(var.Offer, 4)}"
  VMsku             = "${lookup(var.sku, 4)}"
  DiagnosticDiskURI = "${module.DiagStorageAccount1.PrimaryBlobEP}"
  #BootConfigScriptFileName    = "${lookup(var.BootConfigScriptFileList, 2)}"
  PublicSSHKey        = "${var.AzurePublicSSHKey}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM Agent

module "CustomScriptForFEGR1" {
  #Module Location
  #source = "./Modules/19 CustomLinuxExtension-Ansible"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//22 CustomLinuxExtensionScript-Nginx"

  #Module variables
  AgentCount          = "1"
  AgentName           = "FEGR1CustomScript"
  AgentLocation       = "${lookup(var.AzureRegion, 0)}"
  AgentRG             = "${module.ResourceGroup.Name}"
  VMName              = ["${module.VMs_FEGR1.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Network Watcher Agent

module "NetworkWatcherAgentForFEGR1" {
  #Module Location
  #source = "./Modules/20 LinuxNetworkWatcherAgent"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//20 LinuxNetworkWatcherAgent"

  #Module variables
  AgentCount          = "1"
  AgentName           = "NetworkWatcherAgentForFEGR1"
  AgentLocation       = "${lookup(var.AzureRegion, 0)}"
  AgentRG             = "${module.ResourceGroup.Name}"
  VMName              = ["${module.VMs_FEGR1.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}
##############################################################
#This file creates FE servers
##############################################################

#NSG rules for FE servers

module "AllowHTTPFromInternetFESubnet1In" {
  #Module source
  source = "./Modules/01 NSGRule_Multiplerange"

  #source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName           = "${module.ResourceGroup.Name}"
  NSGReference     = "${module.NSG_FEApps_Subnet_vNet1.Name}"
  NSGRuleName      = "AllowHTTPFromInternetFESubnet1In"
  NSGRulePriority  = 101
  NSGRuleDirection = "Inbound"
  NSGRuleAccess    = "Allow"
  NSGRuleProtocol  = "Tcp"
  #NSGRuleSourcePortRanges          = "*"
  NSGRuleDestinationPortRanges      = "${var.WebPorts}"
  NSGRuleSourceAddressPrefixes      = "${var.InternetRange}"
  NSGRuleDestinationAddressPrefixes = ["${lookup(var.vNet1SubnetAddressRange, 0)}"]
}

#NSG rules for vNet to vNet Connectivity

module "AllowAllFromvNet2toFEAppsIn" {
  #Module source
  source = "./Modules/01 NSGRule_Multiplerange"

  #source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName           = "${module.ResourceGroup.Name}"
  NSGReference     = "${module.NSG_FEApps_Subnet_vNet1.Name}"
  NSGRuleName      = "AllowAllFromvNet2toFEAppsIn"
  NSGRulePriority  = 102
  NSGRuleDirection = "Inbound"
  NSGRuleAccess    = "Allow"
  NSGRuleProtocol  = "*"
  #NSGRuleSourcePortRanges           = ["${var.AllNetworkPorts}"]
  NSGRuleDestinationPortRanges      = ["${var.AllNetworkPorts}"]
  NSGRuleSourceAddressPrefixes      = "${var.vNet2IPRange}"
  NSGRuleDestinationAddressPrefixes = ["${lookup(var.vNet1SubnetAddressRange, 0)}"]
}

module "AllowAllFromFEAppstovNet2Out" {
  #Module source
  source = "./Modules/01 NSGRule_Multiplerange"

  #source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//08 NSGRule"

  #Module variable
  RGName           = "${module.ResourceGroup.Name}"
  NSGReference     = "${module.NSG_FEApps_Subnet_vNet1.Name}"
  NSGRuleName      = "AllowAllFromFEAppstovNet2Out"
  NSGRulePriority  = 103
  NSGRuleDirection = "Outbound"
  NSGRuleAccess    = "Allow"
  NSGRuleProtocol  = "*"
  #NSGRuleSourcePortRanges           = ["${var.AllNetworkPorts}"]
  NSGRuleDestinationPortRanges      = ["${var.AllNetworkPorts}"]
  NSGRuleSourceAddressPrefixes      = ["${lookup(var.vNet1SubnetAddressRange, 0)}"]
  NSGRuleDestinationAddressPrefixes = "${var.vNet2IPRange}"
}

#Azure Load Balancer public IP Creation

module "LBWebPublicIP1" {
  #Module source
  #source = "./Modules/10 PublicIP"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//10 PublicIP"

  #Module variables
  PublicIPCount       = "1"
  PublicIPName        = "lbwebpip1"
  PublicIPLocation    = "${lookup(var.AzureRegion, 0)}"
  RGName              = "${module.ResourceGroup.Name}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "LBWebFE1" {
  #Module source
  #source = "./Modules/15 External LB"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//15 External LB"

  #Module variables
  LBCount           = "1"
  ExtLBName         = "LBWebFE1"
  AzureRegion       = "${lookup(var.AzureRegion, 0)}"
  RGName            = "${module.ResourceGroup.Name}"
  FEConfigName      = "LBWebFEConfig1"
  PublicIPId        = ["${module.LBWebPublicIP1.Ids}"]
  LBBackEndPoolName = "LBWebFE_BEPool1"
  LBProbeName       = "LBWebFE_Probe1"
  LBProbePort       = "80"
  FERuleName        = "LBWebFEHTTPRule1"
  FERuleProtocol    = "tcp"
  FERuleFEPort      = "80"
  FERuleBEPort      = "80"
  TagEnvironment    = "${var.EnvironmentTag}"
  TagUsage          = "${var.EnvironmentUsageTag}"
}

#Availability set creation

module "AS_FEGR1" {
  #Module source

  #source = "./Modules/13 AvailabilitySet"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//13 AvailabilitySet"

  #Module variables
  ASName              = "AS_FEGR1"
  RGName              = "${module.ResourceGroup.Name}"
  ASLocation          = "${lookup(var.AzureRegion, 0)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#NIC Creation

module "NICs_FEGR1" {
  #module source

  #source = "./Modules/09 NICWithoutPIPWithCount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//09 NICWithoutPIPWithCount"

  #Module variables

  NICcount            = "1"
  NICName             = "NIC_FEGR1"
  NICLocation         = "${lookup(var.AzureRegion, 0)}"
  RGName              = "${module.ResourceGroup.Name}"
  SubnetId            = "${module.FEApps_Subnet_vNet1.Id}"
  IsLoadBalanced      = "1"
  LBBackEndPoolid     = ["${module.LBWebFE1.LBBackendPoolIds}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "DataDisks_FEGR1" {
  #Module source

  #source = "./Modules/06 ManagedDiskswithcount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 ManagedDiskswithcount"

  #Module variables

  Manageddiskcount    = "1"
  ManageddiskName     = "DataDisk_FEGR1"
  RGName              = "${module.ResourceGroup.Name}"
  ManagedDiskLocation = "${lookup(var.AzureRegion, 0)}"
  StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
  CreateOption        = "Empty"
  DiskSizeInGB        = "63"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM creation

module "VMs_FEGR1" {
  #module source

  #source = "./Modules/14 LinuxVMWithCount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//14 LinuxVMWithCount"

  #Module variables

  VMCount           = "1"
  VMName            = "GR1-FE"
  VMLocation        = "${lookup(var.AzureRegion, 0)}"
  VMRG              = "${module.ResourceGroup.Name}"
  VMNICid           = ["${module.NICs_FEGR1.LBIds}"]
  VMSize            = "${lookup(var.VMSize, 0)}"
  ASID              = "${module.AS_FEGR1.Id}"
  VMStorageTier     = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName       = "${var.VMAdminName}"
  VMAdminPassword   = "${var.VMAdminPassword}"
  DataDiskId        = ["${module.DataDisks_FEGR1.Ids}"]
  DataDiskName      = ["${module.DataDisks_FEGR1.Names}"]
  DataDiskSize      = ["${module.DataDisks_FEGR1.Sizes}"]
  VMPublisherName   = "${lookup(var.PublisherName, 4)}"
  VMOffer           = "${lookup(var.Offer, 4)}"
  VMsku             = "${lookup(var.sku, 4)}"
  DiagnosticDiskURI = "${module.DiagStorageAccount1.PrimaryBlobEP}"
  #BootConfigScriptFileName    = "${lookup(var.BootConfigScriptFileList, 2)}"
  PublicSSHKey        = "${var.AzurePublicSSHKey}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM Agent

module "CustomScriptForFEGR1" {
  #Module Location
  #source = "./Modules/19 CustomLinuxExtension-Ansible"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//22 CustomLinuxExtensionScript-Nginx"

  #Module variables
  AgentCount          = "1"
  AgentName           = "FEGR1CustomScript"
  AgentLocation       = "${lookup(var.AzureRegion, 0)}"
  AgentRG             = "${module.ResourceGroup.Name}"
  VMName              = ["${module.VMs_FEGR1.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Network Watcher Agent

module "NetworkWatcherAgentForFEGR1" {
  #Module Location
  #source = "./Modules/20 LinuxNetworkWatcherAgent"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//20 LinuxNetworkWatcherAgent"

  #Module variables
  AgentCount          = "1"
  AgentName           = "NetworkWatcherAgentForFEGR1"
  AgentLocation       = "${lookup(var.AzureRegion, 0)}"
  AgentRG             = "${module.ResourceGroup.Name}"
  VMName              = ["${module.VMs_FEGR1.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}
