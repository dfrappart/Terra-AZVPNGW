######################################################
# Variables for Template
######################################################

# Variable to define the Azure Region

variable "AzureRegion" {
  type = "map"

  default = {
    "0" = "westeurope"
    "1" = "eastus"
  }
}

# Variable to define the Tag

variable "EnvironmentTag" {
  type    = "string"
  default = "AzureVPN"
}

variable "EnvironmentUsageTag" {
  type    = "string"
  default = "PoC"
}

# Variable to define the Resource Group Name

variable "RGName" {
  type    = "string"
  default = "RG-AZGWTest"
}

#Variable defining the vnet1 ip range and name

variable "vNet1IPRange" {
  type    = "list"
  default = ["10.0.0.0/22"]
}

variable "vNet1Name" {
  type    = "string"
  default = "TestAZGW-vNet1"
}

variable "vNet1SubnetAddressRange" {
  #Note: Subnet must be in range included in the vNET1 Range

  default = {
    "0" = "10.0.0.0/24"
    "1" = "10.0.1.0/24"
    "2" = "10.0.2.0/24"
    "3" = "10.0.3.0/25"
    "4" = "10.0.3.128/25"
  }
}

#Variable defining the vnet2 ip range and name

variable "vNet2IPRange" {
  type    = "list"
  default = ["10.0.4.0/22"]
}

variable "vNet2Name" {
  type    = "string"
  default = "TestAZGW-vNet2"
}

variable "vNet2SubnetAddressRange" {
  #Note: Subnet must be in range included in the vNET1 Range

  default = {
    "0" = "10.0.4.0/24"
    "1" = "10.0.5.0/24"
    "2" = "10.0.6.0/24"
    "3" = "10.0.7.0/25"
    "4" = "10.0.7.128/25"
  }
}

#Variable defining the vnet3 ip range and name

variable "vNet3IPRange" {
  type    = "list"
  default = ["10.0.8.0/22"]
}

variable "vNet3Name" {
  type    = "string"
  default = "TestAZGW-vNet3"
}

variable "vNet3SubnetAddressRange" {
  #Note: Subnet must be in range included in the vNET1 Range

  default = {
    "0" = "10.0.8.0/24"
    "1" = "10.0.9.0/24"
    "2" = "10.0.10.0/24"
    "3" = "10.0.11.0/25"
    "4" = "10.0.11.128/25"
  }
}

variable "SubnetName" {
  default = {
    "0" = "FEApps_Subnet"
    "1" = "BEApps_Subnet"
    "2" = "INFRA_Subnet"
    "3" = "FEADMIN_Subnet"
    "4" = "GatewaySubnet"
  }
}

#variable defining VM size
variable "VMSize" {
  type = "map"

  default = {
    "0" = "Standard_F1S"
    "1" = "Standard_F2s"
    "2" = "Standard_F4S"
    "3" = "Standard_F8S"
  }
}

# variable defining storage account tier

variable "storageaccounttier" {
  default = {
    "0" = "standard"
    "1" = "premium"
  }
}

# variable defining storage replication type

variable "storagereplicationtype" {
  default = {
    "0" = "LRS"
    "1" = "GRS"
    "2" = "RAGRS"
    "3" = "ZRS"
  }
}

# variable defining storage account tier for managed disk

variable "Manageddiskstoragetier" {
  default = {
    "0" = "standard_lrs"
    "1" = "premium_lrs"
  }
}

# variable defining VM image 

# variable defining VM image 

variable "PublisherName" {
  default = {
    "0" = "microsoftwindowsserver"
    "1" = "MicrosoftVisualStudio"
    "2" = "canonical"
    "3" = "credativ"
    "4" = "Openlogic"
    "5" = "RedHat"
  }
}

variable "Offer" {
  default = {
    "0" = "WindowsServer"
    "1" = "Windows"
    "2" = "ubuntuserver"
    "3" = "debian"
    "4" = "CentOS"
    "5" = "RHEL"
  }
}

variable "sku" {
  default = {
    "0" = "2016-Datacenter"
    "1" = "Windows-10-N-x64"
    "2" = "16.04.0-LTS"
    "3" = "9"
    "4" = "7.0"
    "5" = "7.3"
  }
}

#The boot config file name available

variable "BootConfigScriptFileList" {
  type = "map"

  default = {
    "0" = "nginx.sh"
    "1" = "ansible.sh"
    "2" = "docker.sh"
    "3" = "kubernetes.sh"
  }
}

#Standard ports for NSG Rules

variable "AdminPortRange" {
  type    = "list"
  default = ["22", "3389"]
}

variable "WebPorts" {
  type    = "list"
  default = ["80", "443"]
}

variable "AllNetworkPorts" {
  type    = "list"
  default = ["1-65535"]
}

#Variable designating Internet range IP

variable "InternetRange" {
  type    = "list"
  default = ["0.0.0.0/0"]
}
