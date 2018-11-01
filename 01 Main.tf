######################################################
# This file deploys the base Azure Resource
# Resource Group + vNets for The tests of Azure GW
######################################################

######################################################################
# Access to Azure
######################################################################

# Configure the Microsoft Azure Provider with Azure provider variable defined in AzureDFProvider.tf

provider "azurerm" {
  subscription_id = "${var.AzureSubscriptionID2}"
  client_id       = "${var.AzureClientID}"
  client_secret   = "${var.AzureClientSecret}"
  tenant_id       = "${var.AzureTenantID}"
}

######################################################################
# Foundations resources, including ResourceGroup and vNET
######################################################################

# Creating the ResourceGroup

module "ResourceGroup" {
  #Module Location
  #source = "./Modules/01 ResourceGroup"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//01 ResourceGroup/"

  #Module variable
  RGName              = "${var.RGName}"
  RGLocation          = "${lookup(var.AzureRegion, 0)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

# Creating vNET

module "vNet1" {
  #Module location
  #source = "./Modules/02 vNet"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//02 vNet/"

  #Module variable
  vNetName            = "${var.vNet1Name}"
  RGName              = "${module.ResourceGroup.Name}"
  vNetLocation        = "${lookup(var.AzureRegion, 0)}"
  vNetAddressSpace    = "${var.vNet1IPRange}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "vNet2" {
  #Module location
  #source = "./Modules/02 vNet"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//02 vNet/"

  #Module variable
  vNetName            = "${var.vNet2Name}"
  RGName              = "${module.ResourceGroup.Name}"
  vNetLocation        = "${lookup(var.AzureRegion, 1)}"
  vNetAddressSpace    = "${var.vNet2IPRange}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "vNet3" {
  #Module location
  #source = "./Modules/02 vNet"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//02 vNet/"

  #Module variable
  vNetName            = "${var.vNet3Name}"
  RGName              = "${module.ResourceGroup.Name}"
  vNetLocation        = "${lookup(var.AzureRegion, 1)}"
  vNetAddressSpace    = "${var.vNet3IPRange}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Creating Storage Account for logs and Diagnostics

module "DiagStorageAccount1" {
  #Module location
  #source = "./Modules/03 StorageAccountGP"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//03 StorageAccountGP/"

  #Module variable
  StorageAccountName     = "diaglogstorage1"
  RGName                 = "${module.ResourceGroup.Name}"
  StorageAccountLocation = "${lookup(var.AzureRegion, 0)}"
  StorageAccountTier     = "${lookup(var.storageaccounttier, 0)}"
  StorageReplicationType = "${lookup(var.storagereplicationtype, 0)}"
  EnvironmentTag         = "${var.EnvironmentTag}"
  EnvironmentUsageTag    = "${var.EnvironmentUsageTag}"
}

module "DiagStorageAccount2" {
  #Module location
  #source = "./Modules/03 StorageAccountGP"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//03 StorageAccountGP/"

  #Module variable
  StorageAccountName     = "diaglogstorage2"
  RGName                 = "${module.ResourceGroup.Name}"
  StorageAccountLocation = "${lookup(var.AzureRegion, 1)}"
  StorageAccountTier     = "${lookup(var.storageaccounttier, 0)}"
  StorageReplicationType = "${lookup(var.storagereplicationtype, 0)}"
  EnvironmentTag         = "${var.EnvironmentTag}"
  EnvironmentUsageTag    = "${var.EnvironmentUsageTag}"
}

#Creating Storage Account for files exchange

module "FilesExchangeStorageAccount1" {
  #Module location
  #source = "./Modules/03 StorageAccountGP"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//03 StorageAccountGP/"

  #Module variable
  StorageAccountName     = "filestorage1"
  RGName                 = "${module.ResourceGroup.Name}"
  StorageAccountLocation = "${lookup(var.AzureRegion, 0)}"
  StorageAccountTier     = "${lookup(var.storageaccounttier, 0)}"
  StorageReplicationType = "${lookup(var.storagereplicationtype, 0)}"
  EnvironmentTag         = "${var.EnvironmentTag}"
  EnvironmentUsageTag    = "${var.EnvironmentUsageTag}"
}

#Creating Storage Share

module "InfraFileShare1" {
  #Module location
  #source = "./Modules/05 StorageAccountShare"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//05 StorageAccountShare"

  #Module variable
  ShareName          = "infrafileshare1"
  RGName             = "${module.ResourceGroup.Name}"
  StorageAccountName = "${module.FilesExchangeStorageAccount1.Name}"
  Quota              = "5120"
}

module "FilesExchangeStorageAccount2" {
  #Module location
  #source = "./Modules/03 StorageAccountGP"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//03 StorageAccountGP/"

  #Module variable
  StorageAccountName     = "filestorage2"
  RGName                 = "${module.ResourceGroup.Name}"
  StorageAccountLocation = "${lookup(var.AzureRegion, 1)}"
  StorageAccountTier     = "${lookup(var.storageaccounttier, 0)}"
  StorageReplicationType = "${lookup(var.storagereplicationtype, 0)}"
  EnvironmentTag         = "${var.EnvironmentTag}"
  EnvironmentUsageTag    = "${var.EnvironmentUsageTag}"
}

#Creating Storage Share

module "InfraFileShare2" {
  #Module location
  #source = "./Modules/05 StorageAccountShare"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//05 StorageAccountShare"

  #Module variable
  ShareName          = "infrafileshare2"
  RGName             = "${module.ResourceGroup.Name}"
  StorageAccountName = "${module.FilesExchangeStorageAccount2.Name}"
  Quota              = "0"
}
######################################################
# This file deploys the base Azure Resource
# Resource Group + vNets for The tests of Azure GW
######################################################

######################################################################
# Access to Azure
######################################################################

# Configure the Microsoft Azure Provider with Azure provider variable defined in AzureDFProvider.tf

provider "azurerm" {
  subscription_id = "${var.AzureSubscriptionID}"
  client_id       = "${var.AzureClientID}"
  client_secret   = "${var.AzureClientSecret}"
  tenant_id       = "${var.AzureTenantID}"
}

######################################################################
# Foundations resources, including ResourceGroup and vNET
######################################################################

# Creating the ResourceGroup

module "ResourceGroup" {
  #Module Location
  #source = "./Modules/01 ResourceGroup"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//01 ResourceGroup/"

  #Module variable
  RGName              = "${var.RGName}"
  RGLocation          = "${lookup(var.AzureRegion, 0)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

# Creating vNET

module "vNet1" {
  #Module location
  #source = "./Modules/02 vNet"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//02 vNet/"

  #Module variable
  vNetName            = "${var.vNet1Name}"
  RGName              = "${module.ResourceGroup.Name}"
  vNetLocation        = "${lookup(var.AzureRegion, 0)}"
  vNetAddressSpace    = "${var.vNet1IPRange}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "vNet2" {
  #Module location
  #source = "./Modules/02 vNet"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//02 vNet/"

  #Module variable
  vNetName            = "${var.vNet2Name}"
  RGName              = "${module.ResourceGroup.Name}"
  vNetLocation        = "${lookup(var.AzureRegion, 1)}"
  vNetAddressSpace    = "${var.vNet2IPRange}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "vNet3" {
  #Module location
  #source = "./Modules/02 vNet"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//02 vNet/"

  #Module variable
  vNetName            = "${var.vNet3Name}"
  RGName              = "${module.ResourceGroup.Name}"
  vNetLocation        = "${lookup(var.AzureRegion, 1)}"
  vNetAddressSpace    = "${var.vNet3IPRange}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Creating Storage Account for logs and Diagnostics

module "DiagStorageAccount1" {
  #Module location
  #source = "./Modules/03 StorageAccountGP"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//03 StorageAccountGP/"

  #Module variable
  StorageAccountName     = "diaglogstorage1"
  RGName                 = "${module.ResourceGroup.Name}"
  StorageAccountLocation = "${lookup(var.AzureRegion, 0)}"
  StorageAccountTier     = "${lookup(var.storageaccounttier, 0)}"
  StorageReplicationType = "${lookup(var.storagereplicationtype, 0)}"
  EnvironmentTag         = "${var.EnvironmentTag}"
  EnvironmentUsageTag    = "${var.EnvironmentUsageTag}"
}

module "DiagStorageAccount2" {
  #Module location
  #source = "./Modules/03 StorageAccountGP"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//03 StorageAccountGP/"

  #Module variable
  StorageAccountName     = "diaglogstorage2"
  RGName                 = "${module.ResourceGroup.Name}"
  StorageAccountLocation = "${lookup(var.AzureRegion, 1)}"
  StorageAccountTier     = "${lookup(var.storageaccounttier, 0)}"
  StorageReplicationType = "${lookup(var.storagereplicationtype, 0)}"
  EnvironmentTag         = "${var.EnvironmentTag}"
  EnvironmentUsageTag    = "${var.EnvironmentUsageTag}"
}

#Creating Storage Account for files exchange

module "FilesExchangeStorageAccount1" {
  #Module location
  #source = "./Modules/03 StorageAccountGP"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//03 StorageAccountGP/"

  #Module variable
  StorageAccountName     = "filestorage1"
  RGName                 = "${module.ResourceGroup.Name}"
  StorageAccountLocation = "${lookup(var.AzureRegion, 0)}"
  StorageAccountTier     = "${lookup(var.storageaccounttier, 0)}"
  StorageReplicationType = "${lookup(var.storagereplicationtype, 0)}"
  EnvironmentTag         = "${var.EnvironmentTag}"
  EnvironmentUsageTag    = "${var.EnvironmentUsageTag}"
}

#Creating Storage Share

module "InfraFileShare1" {
  #Module location
  #source = "./Modules/05 StorageAccountShare"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//05 StorageAccountShare"

  #Module variable
  ShareName          = "infrafileshare1"
  RGName             = "${module.ResourceGroup.Name}"
  StorageAccountName = "${module.FilesExchangeStorageAccount1.Name}"
  Quota              = "0"
}

module "FilesExchangeStorageAccount2" {
  #Module location
  #source = "./Modules/03 StorageAccountGP"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//03 StorageAccountGP/"

  #Module variable
  StorageAccountName     = "filestorage2"
  RGName                 = "${module.ResourceGroup.Name}"
  StorageAccountLocation = "${lookup(var.AzureRegion, 1)}"
  StorageAccountTier     = "${lookup(var.storageaccounttier, 0)}"
  StorageReplicationType = "${lookup(var.storagereplicationtype, 0)}"
  EnvironmentTag         = "${var.EnvironmentTag}"
  EnvironmentUsageTag    = "${var.EnvironmentUsageTag}"
}

#Creating Storage Share

module "InfraFileShare2" {
  #Module location
  #source = "./Modules/05 StorageAccountShare"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//05 StorageAccountShare"

  #Module variable
  ShareName          = "infrafileshare2"
  RGName             = "${module.ResourceGroup.Name}"
  StorageAccountName = "${module.FilesExchangeStorageAccount2.Name}"
  Quota              = "0"
}
