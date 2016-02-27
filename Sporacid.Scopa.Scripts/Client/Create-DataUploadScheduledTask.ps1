
Param(
	[string]$TaskName="Scopa",
	[string]$TaskPath="\Sporacid"
)
# Use this to create a scheduled task that executes powershell on local computer
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -command "& {C:\Scopa\Upload-LogsToServer.ps1 -IsIncremental}"'
$trigger =  New-ScheduledTaskTrigger -Daily -At 8pm
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TaskName -TaskPath $TaskPath -Description "Runs a powershell script that bundles development log files daily."