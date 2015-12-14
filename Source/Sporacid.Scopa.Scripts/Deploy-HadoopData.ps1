# Orchestrates the whole deal! To be continued...

[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True)]
	[string]$Datasource,
	
	[Parameter(Mandatory=$True)]
	[string]$Destination,
	
	[Parameter(Mandatory=$True)]
	[string]$HiveTableName
) 

if(Test-Path($DataSource)) {
	# Creating Hive-ready folder structure and moving data to proper index
	.\Create-FolderArchitecture.ps1 -Datasource $Datasource -Destination $Destination -HiveTableName $HiveTableName
	
	# Copying newly created architecture to Azure Blob Container
		# Copying the files to destination
		# Run Hive Job for Tables creation
	# .\Magically-MagicalMagic.ps1
} else {
	Write-Host "Please submit a valid datasource path." -ForeGroundColor Yellow
}

