Param (
	[switch]$IsIncremental
)

# Needed for file archiving. Ease of transfer ++
[Reflection.Assembly]::LoadWithPartialName( "System.IO.Compression.FileSystem" )

# Archive infos
$hostname = $env:computername
$timestamp = (Get-Date -Format "yyyyMMdd_hhmmss")

# Scopa Client configuration
[xml]$xml = Get-Content -Path ".\config.xml" -Encoding "UTF8"
$lastScopaDate = $xml.Configuration.LastScopaDate
$logs = $xml.Configuration.Logs
$remotehost = $xml.Configuration.RemoteHost

foreach($log in $logs) {	
	# Create a staging folder for file transfer and ultimately zip purposes
	# following [HOSTNAME_LOGTYPE_TIMESTAMP] nomenclature.
	$stagingFolder = [string]::Format("{0}_{1}_{2}", $hostname, $log.Type, $timestamp)
	New-Item -Type Directory -Path $stagingFolder -Force
	
	# Get the files and if IsIncremental, filter a first shot on the last write date.
	$files = Get-ChildItem -Recurse -File -Path $log.LocalPath
	if ($IsIncremental.IsPresent) {
		Write-Host "Incremental detected! File will be loaded from [$lastScopaDate] to this day!"
		$files = $files | Where-Object {$_.LastWriteDate -ge $lastScopaDate}
	}
	
	# Now match the regex pattern on the file name
	$files | ForEach-Object {
		if($_.Name -match $log.FileNamePattern) {
			Write-Host "Moving [$_] to [$stagingFolder]"
			Copy-Item -Path $_ -Destination $stagingFolder
		}
	}

	$zipDestination = [string]::Format(".\{0}.zip", $stagingFolder)
	$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
	[System.IO.Compression.ZipFile]::CreateFromDirectory($stagingFolder, $zipDestination, $compressionLevel, $false)
		
	# Move Zip to Destination on remote host
	Move-Item -Path $zipDestination -Destination $remoteHost.Destination

	# Remove staging folder
	Remove-Item -Path $stagingFolderPath -Recurse -Force

	# Finally, update the last Scopa date for next run
	$xml.Configuration.LastScopaDate = (Get-Date).ToString()
	$configFilePath = Resolve-Path ".\config.xml"
	$xml.Save($configFilePath)
}