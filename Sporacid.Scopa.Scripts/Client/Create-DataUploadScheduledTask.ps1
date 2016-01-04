
Param(
	[string]$TaskName="Scopa",
	[string]$TaskPath="\Sporacid",
)
# Use this to create a scheduled task that executes powershell on local computer
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -command "& {get-eventlog -logname Application -After ((get-date).AddDays(-1)) | Export-Csv -Path c:\fso\applog.csv -Force -NoTypeInformation}"'
$trigger =  New-ScheduledTaskTrigger -Daily -At 9am
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TaskName -TaskPath $TaskPath -Description "Runs a powershell script that bundles daily sharepoint's log files."

# Now to figure out a way to push that remotely to a bunch of machines.
# An array of UNC paths in an xml config will contains all the config for the job.