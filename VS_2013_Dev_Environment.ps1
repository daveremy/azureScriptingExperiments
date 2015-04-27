# Import Azure Module
Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
 
# Check Azure Module version - needs to be V0.8.0 or later
Get-Module -Name Azure

# Authenticate to Azure
Add-AzureAccount

# List active Azure subscriptions
(Get-AzureSubscription).SubscriptionName
 
# Select Azure Subscription
$subscriptionName = "Visual Studio Ultimate with MSDN"
Select-AzureSubscription `
  -SubscriptionName $subscriptionName

# Switch mode from Azure Service Management to Azure Resource Manager
Switch-AzureMode -Name AzureResourceManager

# Select Azure Resource Group Gallery Template
$templateIdentity =
  (Get-AzureResourceGroupGalleryTemplate |
  Out-GridView -OutputMode Single).Identity

# Select Visual Studio 2013 Ultimate Template
$templateIdentity = "Microsoft.VisualStudioUltimate2013.0.2.56-preview"

# Define unique name for new Resource Group
$randomString = ([char[]]([char]'a'..[char]'z') + 0..9 | sort {get-random})[0..5] -join ''
$resourceGroupName = "dev" + $randomString

# Specify Azure Datacenter region
$location = "East US"

# Define names & value for Storage and vNet
$storageAccountName = $resourceGroupName + "storage"
$vNetName = $resourceGroupName + "net"
$vNetAddressSpace = "10.1.0.0/16"

# Define VM Size to provision
$vmSize = "Medium" 

# Define Cloud Service and VM Names
$cloudServiceName = $resourceGroupName + "web"
$vmHostName = $resourceGroupName + "web01"

# Enter local Admin user & pwd for new VMs
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
