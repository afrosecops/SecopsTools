# Set the Variables

$resourceGroupName = 'SomeRG'
$storageaccount = 'SomeStorAcct'
$keyVaultName = 'SomeKV'

$credential = Get-AutomationPSCredential -Name 'KeyRotate'

Connect-AzureRmAccount -TenantId 'xxxxxxxxxxx' -Credential $credential -ServicePrincipal  | Out-Null

# Regenerate the storage account keys
New-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageaccount -KeyName key1

# Retrieve the storage account Keys

$Keys = Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageaccount
$primaryKey = $Keys.Value[0]
$secondarykey = $Keys.Value[1]

# Get the newly regenerated Keys
Write-Output "Primary Key - " $primaryKey
Write-Output "Secondary Key - " $secondarykey

# Convert the Primary Key & Secondary key to Secure String

$secureValue_PK = ConvertTo-SecureString $primaryKey -AsPlainText -Force
$secureValue_SK = ConvertTo-SecureString $primaryKey -AsPlainText -Force

$credential = Get-AutomationPSCredential -Name 'KeyRotate'
Connect-AzureRmAccount -TenantId 'xxxxxxxxxxxxxxx' -Credential $credential -ServicePrincipal  | Out-Null

# Update the Secret Values in the Key Vault
Set-AzureKeyVaultSecret -VaultName $keyVaultName -Name 'PrimaryKey' -SecretValue $secureValue_PK
Set-AzureKeyVaultSecret -VaultName $keyVaultName -Name 'SecondaryKey' -SecretValue $secureValue_SK
