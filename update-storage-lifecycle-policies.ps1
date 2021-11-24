# This script takes a storage account with a policy applied (the source), and applies it onto another storage account (the target)
# This WILL re-enable rules which are disabled if they are enabled on the source account!
# Optionally sets access time tracking to true

# Config
$subscription = "<azure-subscription-id>" # azure subscription
$sourcePolicyStorageAccountResourceGroup = "<resource-group-name>" # resource group with the policy to copy applied
$sourcePolicyStorageAccountName = "<storage-account-name>" # storage account name which has the policy to copy applied
$setAccessTimeTrackingToEnabled = $true

try {
    Connect-AzAccount -Subscription $subscription -Credential (Get-Credential)
}
catch {
    Write-Host -ForegroundColor Red "Something went wrong when trying to connect"
}

try {
    $outputPolicy = Get-AzStorageAccountManagementPolicy -ResourceGroupName $sourcePolicyStorageAccountResourceGroup -AccountName $sourcePolicyStorageAccountName
}
catch {
    Write-Host -ForegroundColor Red "There was an error fetching the output policy"
}

$rgName = "<resource-group-name>"
$accountName = "<target-policy-container>"

if ($setAccessTimeTrackingToEnabled) {
    #https://docs.microsoft.com/en-us/azure/storage/blobs/lifecycle-management-policy-configure?tabs=azure-powershell#optionally-enable-access-time-tracking
    Enable-AzStorageBlobLastAccessTimeTracking  -ResourceGroupName $rgName `
        -StorageAccountName $accountName `
        -PassThru
}
    
# https://docs.microsoft.com/en-us/powershell/module/az.storage/set-azstorageaccountmanagementpolicy?view=azps-6.6.0#example-3--get-the-management-policy-from-a-storage-account--then-set-it-to-another-storage-account-
$outputPolicy | Set-AzStorageAccountManagementPolicy -ResourceGroupName $rgName -AccountName $accountName