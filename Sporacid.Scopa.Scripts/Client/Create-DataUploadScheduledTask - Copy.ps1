[CmdletBinding()]
Param(
	[string]$TaskPath="[[DSP_SCOPACLIENT_TASKPATH]]"
)

# Ensure deployment folder
$deploymentPath = "[[DSP_SCOPACLIENT_DEPLOYMENTFOLDER]]"
if(-not(Test-Path($deploymentPath)) 
{
	New-Item -Type Directory -Path $deploymentPath 
}

# Once the folder is ensured, copy upload script and config to the deployment folder
$workingDir = Get-Location
$filesToCopy = Get-ChildItem $workingDir -File -Recurse
foreach($file in $filesToCopy)
{
	Copy-Item $file -Destination $deploymentPath -Force
}

# To finalize the deployment, the scheduled task in charge of gathering the log files is registered
Try
{
	Write-Host "Registering Scopa Scheduled Task... " -NoNewLine
	$taskScript = Join-Path $deploymentPath "Upload-LogsToServer.ps1 -Incremental"
	$taskArgs = "-WindowStyle Hidden -NonInteractive -Executionpolicy unrestricted -File $taskScript"
	$taskAction = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $taskArgs
	$taskTrigger =  New-ScheduledTaskTrigger -Daily -At 8pm

	Register-ScheduledTask -Action $taskAction -Trigger $taskTrigger -TaskName "Scopa Client - Incremental" -TaskPath $TaskPath -Description "Runs a powershell script that bundles development log files daily."
	Write-Host "complete!" -ForeGroundColor Green
} 
Catch
{
	Write-Host "failed!" -ForeGroundColor Red
	Write-Host $_.Exception.Message -ForeGroundColor Red
}