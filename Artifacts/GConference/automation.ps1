
$storage = Get-AzureRmResource | Where-Object {$_.Name -eq "Scopa Repository"}
$storageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $storage.ResourceGroupName -Name $StorageAccountName).Key1
$blobContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $storageAccountKey

$hivePath = "hive/scripts/createtable.sql"
Set-AzureStorageBlobContent -File "createtable.sql" -Container $StorageContainerName 
							-Blob $hivePath -Context $blobContext -Force 

Write-Host "Creating Hive tables..."

$f="wasbs://$StorageContainerName@$StorageAccountName.blob.core.windows.net" + $hivePath
$jobDef = New-AzureRmHDInsightHiveJobDefinition -File $f

$clusterCredentials = Get-Credential
$hiveJob = Start-AzureRmHDInsightJob –ClusterName $clusterName 
                                     -ClusterCredentials $clusterCredentials 
                                     –JobDefinition $jobDef
									 
Wait-AzureRmHDInsightJob -Job $hiveJob -WaitTimeoutInSeconds 3600

Get-AzureRmHDInsightJobOutput -Cluster $clusterName 
                              -JobId $hiveJob.JobId 
							  -StandardError