Param (
	[Parameter(Mandatory=$True)]
	[string]$DataSource,
	
	[Parameter(Mandatory=$True)]
	[string]$StorageAccountName,
	
	[Parameter(Mandatory=$True)]
	[string]$StorageContainerName
)

# Azure subscription-specific variables.
$clusterName = "abbath"

# Pops azure login screen
Login-AzureRmAccount
$storage = Get-AzureRmResource | Where-Object {$_.Name = $StorageAccountName}
# Grab the first access key out of 2.
$storageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $storage.ResourceGroupName -Name $StorageAccountName).Key1
$blobContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $storageAccountKey

# Current working directory
$workingDir = Get-Location

# Upload Hive table creation scripts
$scriptsFolder = "$workingDir\database"
$destfolder = "hive/scripts"
$files = Get-ChildItem $scriptsFolder -Recurse
$files | ForEach-Object {
  $fileName = "$scriptsFolder\$_"   
  $blobName = "$destfolder/$_"   
  Write-Host "copying $fileName to $blobName"   
  Set-AzureStorageBlobContent -File $filename -Container $StorageContainerName -Blob $blobName -Context $blobContext -Force  
}
Write-Host "All files in $scriptsFolder uploaded to $StorageContainerName!"

# Upload Hadoop-Ready folder architecture to HDFS.
$scriptsFolder = $DataSource
$destfolder = "hive/warehouse/"
$files = Get-ChildItem $scriptsFolder -Recurse
foreach($file in $files)
{
  $fileName = "$scriptsFolder\$file"   
  $blobName = "$destfolder/$file"   
  Write-Host "copying $fileName to $blobName"   
  Set-AzureStorageBlobContent -File $filename -Container $StorageContainerName -Blob $blobName -Context $blobContext -Force
}
Write-Host "All files in $scriptsFolder uploaded to $StorageContainerName!"

# Run scripts to create Hive tables.
Write-Host "Creating Hive tables..."
$jobDef = New-AzureRmHDInsightHiveJobDefinition -File "wasbs://$StorageContainerName@$StorageAccountName.blob.core.windows.net/hive/scripts/Create-HiveExternalTables.sql"

$clusterCredentials = Get-Credential
$hiveJob = Start-AzureRmHDInsightJob –ClusterName $clusterName -ClusterCredentials $clusterCredential –JobDefinition $jobDef
Wait-AzureRmHDInsightJob -Job $hiveJob -WaitTimeoutInSeconds 3600
Get-AzureRmHDInsightJobOutput -Cluster $clusterName -JobId $hiveJob.JobId -StandardError

# All done!
Write-Host "Finished!"