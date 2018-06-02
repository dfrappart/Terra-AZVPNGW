######################################################
# This file defines which value are sent to output
######################################################

######################################################
# Resource group info Output

output "ResourceGroupName" {

    value = "${module.ResourceGroup.Name}"
}

output "ResourceGroupId" {

    value = "${module.ResourceGroup.Id}"
}

######################################################
# vNet info Output

output "vNet1Name" {

    value = "${module.vNet1.Name}"
}

output "vNet1Id" {

    value = "${module.vNet1.Id}"
}

output "vNet1AddressSpace" {

    value = "${module.vNet1.AddressSpace}"
}

output "vNet2Name" {

    value = "${module.vNet2.Name}"
}

output "vNet2Id" {

    value = "${module.vNet2.Id}"
}

output "vNet2AddressSpace" {

    value = "${module.vNet2.AddressSpace}"
}

######################################################
# Log&Diag Storage account Info

output "DiagStorageAccount1Name" {

    value = "${module.DiagStorageAccount1.Name}"
}

output "DiagStorageAccount1ID" {

    value = "${module.DiagStorageAccount1.Id}"
}

output "DiagStorageAccount1PrimaryBlobEP" {

    value = "${module.DiagStorageAccount1.PrimaryBlobEP}"
}

output "DiagStorageAccount1PrimaryQueueEP" {

    value = "${module.DiagStorageAccount1.PrimaryQueueEP}"
}

output "DiagStorageAccount1PrimaryTableEP" {

    value = "${module.DiagStorageAccount1.PrimaryTableEP}"
}

output "DiagStorageAccount1PrimaryFileEP" {

    value = "${module.DiagStorageAccount1.PrimaryFileEP}"
}

output "DiagStorageAccount1PrimaryAccessKey" {

    value = "${module.DiagStorageAccount1.PrimaryAccessKey}"
}

output "DiagStorageAccount1SecondaryAccessKey" {

    value = "${module.DiagStorageAccount1.SecondaryAccessKey}"
}




output "DiagStorageAccount2Name" {

    value = "${module.DiagStorageAccount2.Name}"
}

output "DiagStorageAccount2ID" {

    value = "${module.DiagStorageAccount2.Id}"
}

output "DiagStorageAccount2PrimaryBlobEP" {

    value = "${module.DiagStorageAccount2.PrimaryBlobEP}"
}

output "DiagStorageAccount2PrimaryQueueEP" {

    value = "${module.DiagStorageAccount2.PrimaryQueueEP}"
}

output "DiagStorageAccount2PrimaryTableEP" {

    value = "${module.DiagStorageAccount2.PrimaryTableEP}"
}

output "DiagStorageAccount2PrimaryFileEP" {

    value = "${module.DiagStorageAccount2.PrimaryFileEP}"
}

output "DiagStorageAccount2PrimaryAccessKey" {

    value = "${module.DiagStorageAccount2.PrimaryAccessKey}"
}

output "DiagStorageAccount2SecondaryAccessKey" {

    value = "${module.DiagStorageAccount2.SecondaryAccessKey}"
}


######################################################
# Files Storage account Info

output "FilesExchangeStorageAccount1Name" {

    value = "${module.FilesExchangeStorageAccount1.Name}"
}

output "FilesExchangeStorageAccount1ID" {

    value = "${module.FilesExchangeStorageAccount1.Id}"
}

output "FilesExchangeStorageAccount1PrimaryBlobEP" {

    value = "${module.FilesExchangeStorageAccount1.PrimaryBlobEP}"
}

output "FilesExchangeStorageAccount1PrimaryQueueEP" {

    value = "${module.FilesExchangeStorageAccount1.PrimaryQueueEP}"
}

output "FilesExchangeStorageAccount1PrimaryTableEP" {

    value = "${module.FilesExchangeStorageAccount1.PrimaryTableEP}"
}

output "FilesExchangeStorageAccount1PrimaryFileEP" {

    value = "${module.FilesExchangeStorageAccount1.PrimaryFileEP}"
}

output "FilesExchangeStorageAccount1PrimaryAccessKey" {

    value = "${module.FilesExchangeStorageAccount1.PrimaryAccessKey}"
}

output "FilesExchangeStorageAccount1SecondaryAccessKey" {

    value = "${module.FilesExchangeStorageAccount1.SecondaryAccessKey}"
}

output "FilesExchangeStorageAccount2Name" {

    value = "${module.FilesExchangeStorageAccount2.Name}"
}

output "FilesExchangeStorageAccount2ID" {

    value = "${module.FilesExchangeStorageAccount2.Id}"
}

output "FilesExchangeStorageAccount2PrimaryBlobEP" {

    value = "${module.FilesExchangeStorageAccount2.PrimaryBlobEP}"
}

output "FilesExchangeStorageAccount2PrimaryQueueEP" {

    value = "${module.FilesExchangeStorageAccount2.PrimaryQueueEP}"
}

output "FilesExchangeStorageAccount2PrimaryTableEP" {

    value = "${module.FilesExchangeStorageAccount2.PrimaryTableEP}"
}

output "FilesExchangeStorageAccount2PrimaryFileEP" {

    value = "${module.FilesExchangeStorageAccount2.PrimaryFileEP}"
}

output "FilesExchangeStorageAccount2PrimaryAccessKey" {

    value = "${module.FilesExchangeStorageAccount2.PrimaryAccessKey}"
}

output "FilesExchangeStorageAccount2SecondaryAccessKey" {

    value = "${module.FilesExchangeStorageAccount2.SecondaryAccessKey}"
}

######################################################
# Subnet info Output
######################################################

######################################################
#FEApps_Subnet_vNet1

output "FEApps_Subnet_vNet1Name" {

    value = "${module.FEApps_Subnet_vNet1.Name}"
}

output "FEApps_Subnet_vNet1Id" {

    value = "${module.FEApps_Subnet_vNet1.Id}"
}

output "FEApps_Subnet_vNet1AddressPrefix" {

    value = "${module.FEApps_Subnet_vNet1.AddressPrefix}"
}


######################################################
#BEApps_Subnet_vNet1

output "BEApps_Subnet_vNet1Name" {

    value = "${module.BEApps_Subnet_vNet1.Name}"
}

output "BEApps_Subnet_vNet1Id" {

    value = "${module.BEApps_Subnet_vNet1.Id}"
}

output "BEApps_Subnet_vNet1AddressPrefix" {

    value = "${module.BEApps_Subnet_vNet1.AddressPrefix}"
}
######################################################
#FEADMIN_Subnet_vNet1

output "FEADMIN_Subnet_vNet1Name" {

    value = "${module.FEADMIN_Subnet_vNet1.Name}"
}

output "FEADMIN_Subnet_vNet1Id" {

    value = "${module.FEADMIN_Subnet_vNet1.Id}"
}

output "FEADMIN_Subnet_vNet1AddressPrefix" {

    value = "${module.FEADMIN_Subnet_vNet1.AddressPrefix}"
}


######################################################
#FEApps_Subnet_vNet2

output "FEApps_Subnet_vNet2Name" {

    value = "${module.FEApps_Subnet_vNet2.Name}"
}

output "FEApps_Subnet_vNet2Id" {

    value = "${module.FEApps_Subnet_vNet2.Id}"
}

output "FEApps_Subnet_vNet2AddressPrefix" {

    value = "${module.FEApps_Subnet_vNet2.AddressPrefix}"
}


######################################################
#BEApps_Subnet_vNet2

output "BEApps_Subnet_vNet2Name" {

    value = "${module.BEApps_Subnet_vNet2.Name}"
}

output "BEApps_Subnet_vNet2Id" {

    value = "${module.BEApps_Subnet_vNet2.Id}"
}

output "BEApps_Subnet_vNet2AddressPrefix" {

    value = "${module.BEApps_Subnet_vNet2.AddressPrefix}"
}
######################################################
#FEADMIN_Subnet_vNet2

output "FEADMIN_Subnet_vNet2Name" {

    value = "${module.FEADMIN_Subnet_vNet2.Name}"
}

output "FEADMIN_Subnet_vNet2Id" {

    value = "${module.FEADMIN_Subnet_vNet2.Id}"
}

output "FEADMIN_Subnet_vNet2AddressPrefix" {

    value = "${module.FEADMIN_Subnet_vNet2.AddressPrefix}"
}

######################################################
#Bastion Output

output "Bastionfqdn" {

    value = ["${module.BastionPublicIP.fqdns}"]
}

output "BastionpublicIPAddress" {

    value = ["${module.BastionPublicIP.IPAddresses}"]
}

#Jump Output

output "Jumpfqdn" {

    value = ["${module.JumpPublicIP.fqdns}"]
}

output "JumpublicIPAddress" {

    value = ["${module.JumpPublicIP.IPAddresses}"]
}

######################################################
#Azure Web LB Output

output "LBWebPublicIPfqdn" {

    value = ["${module.LBWebPublicIP1.fqdns}"]
}

output "LBWebPublicIPpublicIPAddress" {

    value = ["${module.LBWebPublicIP1.IPAddresses}"]
}