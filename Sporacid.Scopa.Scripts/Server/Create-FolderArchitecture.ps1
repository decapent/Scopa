
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
$hiveTableFolder = Join-Path -Path $Destination -ChildPath $HiveTableName
if(-not(Test-Path($hiveTableFolder))) {
	$hiveTableFolder = New-Item -Path $Destination -Name $HiveTableName -Type Directory
}

# Regex patterns matching a sharepoint's log file name
# The only case the first pattern doesn't match the file name
# is if the host name contains the '-' caracter.
# As a workaround the second pattern was introduced.
$patterns = @("^([\w0-9]+)-([\d]{8})-[\d]{4}.log$"
			 ,"^([\w0-9]+)-([\w0-9]+)-([\d]{8})-[\d]{4}.log$")
			 
$files = Get-ChildItem -Path $Datasource -Recurse

$files | ForEach-Object	{
	foreach($pattern in $patterns) {
		if ($_ -match $pattern)	{
			
			# a wild magic variable "$matches"
			$hostName = $matches[1];
			$logDate = $matches[2];
			if ($matches.Count -gt 3) {
				$hostName = [string]::Format("{0}-{1}", $matches[1], $matches[2]);
				$logDate = $matches[3];
			}
			
			$hostFolderPath = [string]::Format("{0}\hostname={1}", $hiveTableFolder.FullName, $hostName)
			$logDateFolderPath = [string]::Format("{0}\logdate={1}", $hostFolderPath, $logDate)
			
			# Create indexed ready folders ?
			if(-not(Test-Path($hostFolderPath))) {
				New-Item -Path $hostFolderPath -Type Directory
			}
			
			if(-not (Test-Path($logDateFolderPath))) {
				New-Item -Path $logDateFolderPath -Type Directory
			}
			
			Write-Host "Copying [$_] to $logDateFolderPath"
			Copy-Item -Path $_.FullName -Destination $logDateFolderPath
		}
	}
}