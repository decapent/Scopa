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

	# Creating folder structure and moving data to proper index
	.\Create-FolderArchitecture.ps1 -Datasource $Datasource -Destination $Destination -HiveTableName $HiveTableName
	
	# Copying newly created architecture to Azure Blob Container
	# .\Magically-MagicalMagic.ps1
} else {
	Write-Host "Please submit a valid datasource path." -ForeGroundColor Yellow
}

