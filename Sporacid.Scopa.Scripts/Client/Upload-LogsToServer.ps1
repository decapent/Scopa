<#
    .SYNOPSIS
        Process a local log directory to be uploaded to a remote host.

    .DESCRIPTION
        Process a local log directory, such as SharePoint 2013 or IIS to be uploaded to a remote host.
		The script works in hand with the config.xml located within the same directory. Incremental dataload
		based on date is supported to prevent copying the full directory at each Scopa!
   
    .PARAMETER  Incremental
        For an Incremental Scopa based on the date of the last archiving
        
    .PARAMETER  KeepStaging
        Do not clean up the staging folder after running the script        
        
    .EXAMPLE
        PS C:\Scripts> Upload-LogsToServer.ps1 -Incremental -KeepStaging

    .OUTPUTS
        A processed zip filed containing at least 1 file uploaded to a remote host 
		configured via the config.xml
#>
[CmdletBinding()]
Param (
	[switch]$Incremental,
	[switch]$KeepStaging
)

# Needed for file archiving
[Reflection.Assembly]::LoadWithPartialName( "System.IO.Compression.FileSystem" )

# Archive infos
$hostname = $env:computername
$timestamp = (Get-Date -Format "yyyyMMddhhmmss")

# Scopa Client configuration
$configPath = Resolve-Path ".\config.xml"
[xml]$xml = Get-Content -Path $configPath -Encoding "UTF8"
$lastScopaDate = $xml.Configuration.LastScopaDate
$destination = $xml.Configuration.RemoteHost.Destination
$logs = $xml.Configuration.Logs

Try 
{
	# Processing each type of log files
	foreach($log in $logs.Log) 
	{		
		# Print some fancy header
		$header = [string]::Format("Processing {0} logs @ {1}", $log.Type, $log.LocalPath)
		Write-Host "-------------------------------------------------" -ForegroundColor Cyan
		Write-Host $header -ForegroundColor Cyan
		Write-Host "-------------------------------------------------" -ForegroundColor Cyan

		# Get the files and if Incremental, filter a first shot on the file's last write date.
		$files = Get-ChildItem -Recurse -File -Path $log.LocalPath
		if ($Incremental.IsPresent) 
		{
			Write-Host "WARNING: Incremental parameter detected! Files will be loaded from [$lastScopaDate] up to this day!" -ForegroundColor Yellow
			$files = $files | Where-Object {$_.LastWriteTime -ge $lastScopaDate}
		}
	
        # No need to create anything if there are no files to process after date filtering
        if($files.Count -gt 0)
        {
			# Create a staging folder following [HOSTNAME_LOGTYPE_TIMESTAMP] nomenclature.
			$stagingFolderPath = [string]::Format("{0}\{1}_{2}_{3}", $log.LocalPath, $hostname, $log.Type, $timestamp)
			Write-Host "Creating staging folder [$stagingFolderPath]" -ForegroundColor Yellow
			New-Item -Type Directory -Path $stagingFolderPath -Force

		    # Match the regex pattern on the file name
		    foreach($file in $files)
		    {
				# For matching files, move them to staging folder
			    if($file.Name -match $log.FileNamePattern) 
			    {
				    Write-Host "Moving [$file] to staging folder"
				    Copy-Item -Path $file.FullName -Destination $stagingFolderPath
			    }
		    }

		    # Prepare the staging folder archive with optimal compression level...
		    Write-Host "Preparing the staging folder archive with optimal compression level... " -ForegroundColor Yellow -NoNewline
		    $archivePath = "$stagingFolderPath.zip"
		    $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
		    [System.IO.Compression.ZipFile]::CreateFromDirectory($stagingFolderPath, $archivePath, $compressionLevel, $false)
			Write-Host "Complete!" -ForegroundColor Green
		
		    # Move Zip to Destination on remote host
		    Write-Host "Moving [$archivePath] to [$destination]"
		    Move-Item -Path $archivePath -Destination $destination

			# Remove staging folder if not specified
            if(-not($KeepStaging.IsPresent))
	        {
		        Write-Host "Cleaning staging environment... " -ForegroundColor Yellow -NoNewline
		        Remove-Item -Path $stagingFolderPath -Recurse -Force
				Write-Host "Complete!" -ForegroundColor Green
	        }
	        else
	        {
		        Write-Host "WARNING: Staging environment is still on disk... cleanup will need to be done manually!!" -ForegroundColor Yellow
	        }
        }
        else
        {
            Write-Host "WARNING: No files to process! Either the log directory is EMPTY or the last INCREMENTAL date filters all the files..." -ForegroundColor Yellow
        }
	}
}
Catch
{
	Write-Host $_.Exception.Message -ForegroundColor Red
}
Finally
{
    # Update the last Scopa date for incremental config
	$xml.Configuration.LastScopaDate = (Get-Date).ToString()
	$xml.Save($configPath)
}