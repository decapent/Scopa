
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True)]
	[string]$Datasource,
	
	[Parameter(Mandatory=$True)]
	[string]$Destination,
	
	[Parameter(Mandatory=$True)]
	[string]$HiveTableName
) 

# Creating Root Folder which will hold the folder structure
$hiveTableFolder = New-Item -Path $Destination -Name $HiveTableName -Type Directory

# Only SP2013 log files are supported at the moment
$files = Get-ChildItem -Path $Datasource -Recurse
$pattern = "^([a-zA-z]+)-([\d]{8})-([\d]{4}).log$"

$files | ForEach-Object	{
	
	# See if the file name matches
	Write-Host "Trying to match $_ ..." -NoNewLine
	
	if ($_ -match $pattern)	{
		
		Write-Host " Matches" -ForeGroundColor Green
		
		# a wild magic variable "$matches"
		$machineName = $matches[1];
		$logDate = $matches[2];
		$machineFolderPath = [string]::Format("{0}\MachineName={1}", $hiveTableFolder.FullName, $machineName)
		$logDateFolderPath = [string]::Format("{0}\LogDate={1}", $machineFolderPath, $logDate)
		
		# Already Exists ?
		if(-not(Test-Path($machineFolderPath))) {
			New-Item -Path $machineFolderPath -Type Directory
		}
		
		if(-not (Test-Path($logDateFolderPath))) {
			New-Item -Path $logDateFolderPath -Type Directory
		}
		
		Write-Host "Copying [$_] to $logDateFolderPath"
		Copy-Item -Path $_.FullName -Destination $logDateFolderPath
	} else {
		Write-Host " No Match" -ForeGroundColor Red
	}
	
	# TODO Ajoutez un ptit rapport des fichiers en erreurs.
}