# Orchestrates the whole deal! To be continued...

[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True)]
	[string]$RawDatasource,
	
	[Parameter(Mandatory=$True)]
	[string]$HiveTableRepository,
	
	[Parameter(Mandatory=$True)]
	[string]$HiveTableName
) 

if(Test-Path($DataSource)) {
	# Creating Hive-ready folder structure and moving data to proper index.
	.\Create-FolderArchitecture.ps1 -Datasource $RawDatasource -Destination $HiveTableRepository -HiveTableName $HiveTableName
	
	# Copying newly created architecture to Azure Blob Container and create external tables.
	.\Upload-HiveTables.ps1 -Datasource $HiveTableRepository -StorageAccountName "nevermore" -StorageContainerName "abbath"
} else {
	Write-Host "Please submit a valid datasource path." -ForeGroundColor Yellow
}

