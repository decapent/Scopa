Param (
	[string]$DumpFolder="\\VMSPPLAV\raw",
	
	[switch]$Incremental=$true,
	[switch]$KeepStaging=$true,
	
	[Parameter(Mandatory=$true)]
	[string[]]$RegexPatterns
)

# Needed for file archiving for ease of transfer.
[Reflection.Assembly]::LoadWithPartialName( "System.IO.Compression.FileSystem" )

# Array de client remote
$remotePaths = @("\\VMSPHIL\C$\Logs", "\\VMSPPLAV\C$\Logs")

$remotePaths | ForEach-Object {

	Write-Host "Connecting to [$_]... " -NoNewLine
	if (Test-Path($_)) {
		Write-Host " success!" -ForeGroundColor Green
				
		$uri = New-Object System.Uri($_)
		# Create a staging folder
		$sp2013logPath = $_ + "\SP2013"
		$stagingFolderPath + "\staging"
		New-Item -Type Directory -Path $stagingFolderPath -Force
		
		#If Incremental, filter a first shot by date 
		$files = Get-ChildItem -Recurse -File -Path $sp2013logPath
		if ($Incremental.IsPresent) {
			# TODO: Write a function that fetch the config (config.xml maybe... not sure yet)
			$lastIncrementalDate = "12/15/2015"
			Write-Host "Incremental parameter found, files will be loaded from $lastIncrementalDate up to this day!" -ForeGroundColor Yellow
			$files = $files | Where-Object {$_.CreationTime -ge $lastIncrementalDate}
		}
		
		# Now match the regex pattern
		$files | ForEach-Object {
			foreach($p in $RegexPatterns) {
				# Copy file to staging folder
				if($_.Name -match $p) {
					Write-Host "Moving [$_] to [$stagingFolderPath]"
					Copy-Item -Path $_ -Destination $stagingFolderPath
				}
			}
		}

		# Zip staging folder following [HOSTNAME_LOGTYPE_TIMESTAMP]		
		$zipDestination = [string]::Format("\{0}_{1}_{2}.zip", $uri.Host, "SP2013", (Get-Date -Format "yyyyMMdd_hhmmss"))
		$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
		[System.IO.Compression.ZipFile]::CreateFromDirectory($stagingFolderPath, $zipDestination, $compressionLevel, $false)
			
		if (-not($KeepStaging.IsPresent)) {
			Remove-Item -Path $stagingFolderPath -Recurse -Force
		}
		
		# Move Zip to DumpFolder to be structured afterward and delete staging folder.
		Copy-Item -Path $zipDestination -Destination $DumpFolder
	}
}

function Get-LastScopaIncrementalDate {
	
	
}