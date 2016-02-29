Param (
	[switch]$IsIncremental
)

# Needed for file archiving. Ease of transfer ++
[Reflection.Assembly]::LoadWithPartialName( "System.IO.Compression.FileSystem" )

# Archive infos
$hostname = $env:computername
$timestamp = (Get-Date -Format "yyyyMMddhhmmss")

# Scopa Client configuration
$configPath = Resolve-Path ".\config.xml"
[xml]$xml = Get-Content -Path $configPath -Encoding "UTF8"
$lastScopaDate = $xml.Configuration.LastScopaDate
$logs = $xml.Configuration.Logs
$remotehost = $xml.Configuration.RemoteHost

Try 
{
	foreach($log in $logs.Log) 
	{	
		# Create a staging folder for file transfer and ultimately zip purposes
		# following [HOSTNAME_LOGTYPE_TIMESTAMP] nomenclature.
		$stagingFolder = [string]::Format("{0}_{1}_{2}", $hostname, $log.Type, $timestamp)
		New-Item -Type Directory -Path $stagingFolder -Force
	
		# Get the files and if IsIncremental, filter a first shot on the last write date.
		$files = Get-ChildItem -Recurse -File -Path $log.LocalPath
		if ($IsIncremental.IsPresent) 
		{
			Write-Host "Incremental parameter detected! File will be loaded from [$lastScopaDate] up to this day!"
			$files = $files | Where-Object {$_.LastWriteDate.ToString() -ge $lastScopaDate}
		}
	
		# Now match the regex pattern on the file name
		foreach($file in $files)
		{
			if($file.Name -match $log.FileNamePattern) 
			{
				Write-Host "Moving [$file] to [$stagingFolder]"
				Copy-Item -Path $file.FullName -Destination $stagingFolder
			}
		}

		# Need to deal with absolute path
		$zipFileName = [string]::Format(".\{0}.zip", $stagingFolder)
		$zipDestination = Resolve-Path $zipFileName
		$stagingFolderPath = Resolve-Path ".\$stagingFolder"
		$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
		[System.IO.Compression.ZipFile]::CreateFromDirectory($stagingFolderPath, $zipDestination, $compressionLevel, $false)
		
		# Move Zip to Destination on remote host
		Move-Item -Path $zipDestination -Destination $remoteHost.Destination

		# Remove staging folder
		Remove-Item -Path $stagingFolderPath -Recurse -Force

		# Finally, update the last Scopa date for next run
		$xml.Configuration.LastScopaDate = (Get-Date).ToString()
		$configFilePath = Resolve-Path ".\config.xml"
		$xml.Save($configFilePath)
	}
}
Catch
{
	$errorMessage = $_.Exception.Message
	Write-Host "Something went wong... [$errorMessage]"
}