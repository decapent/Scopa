# Orchestrates the whole deal! To be continued...

[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True)]
	[string]$RawDatasource,
	
	[Parameter(Mandatory=$True)]
	[string]$HiveTableRepository,
	
	[Parameter(Mandatory=$True)]
	[string]$HiveTableName
	
	[switch]$FetchRemote
) 

$patterns = "[[SP2013_LOGFILE_REGEX_PATTERNS]]"

if ($FetchRemote.IsPresent) {
	# Fetching logs remotely in target hosts... Incremental switch is used to fetch logs from a certain point in time.
	# That point is saved in the config.xml file.
	Write-Host "Looking on remote hosts for latests log files."
	.\Fetch-RemoteLogs.ps1 -DumpFolder $RawDataSource -Incremental -RegexPatterns 
}

if(Test-Path($RawDataSource)) {
	# Creating Hive-ready folder structure and moving data to proper index.
	.\Create-FolderArchitecture.ps1 -Datasource $RawDatasource -Destination $HiveTableRepository -HiveTableName $HiveTableName

	# Copying newly created architecture to Azure Blob Container and create external tables.
	.\Upload-HiveTables.ps1 -Datasource $HiveTableRepository -StorageAccountName "[[AZURE_STORAGE_ACCOUNT_NAME]]" -StorageContainerName "[[AZURE_STORAGE_CONTAINER_NAME]]"
} else {
	Write-Host "Please submit a valid datasource path." -ForeGroundColor Yellow
}

