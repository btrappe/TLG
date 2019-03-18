<#  Deploy-TLG.ps1
    Kelley Vice 7/11/2018

    This script deploys the TLG (Test Lab Guide) 3 VM Base Configuration to your Azure RM subscription.
    You must have the AzureRM PowerShell module installed on your computer to run this script.
    To install the AzureRM module, execute the following command from an elevated PowerShell prompt:

    Install-Module AzureRM

#>

# Provide parameter values
$subscription = "subscription name"
$resourceGroup = "resource group name"
$location = "location, i.e. West US"

$configName = "" # The name of the deployment, i.e. BaseConfig01. Do not use spaces or special characters other than _ or -. Used to concatenate resource names for the deployment.
$domainName = "" # The FQDN of the new primary AD domain.
$domainName2 = "" # The FQDN of the 2. new primary AD domain.
$deployADC2 = "No" # Yes or No
$domainName3 = "" # The FQDN of the new AD subdomain.
$deployADC3 = "No" # Yes or No
$serverOS = "2019-Datacenter-smalldisk" # The OS of application servers in your deployment, i.e. 2016-Datacenter or 2012-R2-Datacenter.
$adminUserName = "" # The name of (all) the domain administrator account to create, i.e. globaladmin.
$adminPassword = "" # The administrator account password.
$deployAPP2 = "No" # Yes or No
$deployClientVm = "Yes" # Yes or No
$clientVhdUri = "" # The URI of the storage account containing the client VHD. Leave blank if you are not deploying a client VM.
$vmSize = "Standard_B2s" # Select a VM size for all server VMs in your deployment.
$dnsLabelPrefix = "" # DNS label prefix for public IPs. Must be lowercase and match the regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$.
$_artifactsLocation = "https://thinprintbrokerdev.blob.core.windows.net/tls/tlg-base-config_3-vm" # Location of template artifacts.
$_artifactsLocationSasToken = "" # Enter SAS token here if needed.
$templateUri = "$_artifactsLocation/azuredeploy.json"

# Add parameters to array
$parameters = @{}
$parameters.Add("configName",$configName)
$parameters.Add("domainName",$domainName)
$parameters.Add("domainName2",$domainName2)
$parameters.Add("deployADC2",$deployADC2)
$parameters.Add("domainName3",$domainName3)
$parameters.Add("deployADC3",$deployADC3)
$parameters.Add("serverOS",$serverOS)
$parameters.Add("adminUserName",$adminUserName)
$parameters.Add("adminPassword",$adminPassword)
$parameters.Add("deployAPP2",$deployAPP2)
$parameters.Add("deployClientVm",$deployClientVm)
$parameters.Add("clientVhdUri",$clientVhdUri)
$parameters.Add("vmSize",$vmSize)
$parameters.Add("dnsLabelPrefix",$dnsLabelPrefix)
$parameters.Add("_artifactsLocation",$_artifactsLocation)
$parameters.Add("_artifactsLocationSasToken",$_artifactsLocationSasToken)

# Log in to Azure subscription
Connect-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName $subscription

# Deploy resource group
New-AzureRmResourceGroup -Name $resourceGroup -Location $location

# Deploy template
New-AzureRmResourceGroupDeployment -Name $configName -ResourceGroupName $resourceGroup `
  -TemplateUri $templateUri -TemplateParameterObject $parameters -DeploymentDebugLogLevel All