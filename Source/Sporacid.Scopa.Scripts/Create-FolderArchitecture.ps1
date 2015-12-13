
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
$patterns = @("^([a-zA-z]+)-([\d]{8})-([\d]{4}).log$", "^([a-zA-z]+)-([a-zA-z]+)-([\d]{8})-([\d]{4}).log$")

$files | ForEach-Object	{
	
	foreach ($pattern in $patterns) {
		if ($_ -match $pattern)	{
			
			# a wild magic variable "$matches"
			$machineName = $matches[1];
			$logDate = $matches[2];
			if ($matches.Count -gt 4) {
				$machineName = [string]::Format("{0}-{1}", $matches[1], $matches[2]);
				$logDate = $matches[3];
			}
			
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
		}
	}	
}