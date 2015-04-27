# Import Azure Module
Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
 
# Authenticate to Azure
Add-AzureAccount

# Select Azure Subscription
$subscriptionName = "Visual Studio Ultimate with MSDN"
Select-AzureSubscription `
  -SubscriptionName $subscriptionName

# Switch mode from Azure Service Management to Azure Resource Manager
Switch-AzureMode -Name AzureResourceManager

# Select Visual Studio 2013 Ultimate Template
$templateIdentity = "Microsoft.VisualStudioUltimate2013.0.2.56-preview"

# Define unique name for new Resource Group
# These names are really finicky ...
$randomString = ([char[]]([char]'a'..[char]'z') + 0..9 | sort {get-random})[0..5] -join ''
$resourceGroupName = "dev" + $randomString

# Specify Azure Datacenter region
$location = "East US"

# Define names & value for Storage and vNet
$storageAccountName = $resourceGroupName + "storage"
$vNetName = $resourceGroupName + "net"
$vNetAddressSpace = "10.1.0.0/16"

# Define VM Size to provision
$vmSize = "Medium" # A2 2 Cores 3.5G

# Define Cloud Service and VM Names
$cloudServiceName = $resourceGroupName + "dev"
$vmHostName = $resourceGroupName + "dev01"

# This will prompt you for the name and password for the 
#  vm being created in the cloud
$creds = Get-Credential `
  -Message "Enter new Admin credentials for VM"

# Provision new Resource Group
New-AzureResourceGroup `
  -Name $resourceGroupName `
  -Location $location `
  -GalleryTemplateIdentity $templateIdentity `
  -newStorageAccountName $storageAccountName `
  -newDomainName $cloudServiceName `
  -newVirtualNetworkName $vNetName `
  -vnetAddressSpace $vNetAddressSpace `
  -hostName $vmHostName `
  -userName $creds.UserName `
  -password $creds.GetNetworkCredential().SecurePassword `
  -hardwareSize $vmSize `
  -locationFromTemplate $location `
  -Force

# Get the resources for a Resource Group
Get-AzureResourceGroup `
  -Name $resourceGroupName

# You should be able to go to portal.azure.com and
#  see the resource group now if it worked.
