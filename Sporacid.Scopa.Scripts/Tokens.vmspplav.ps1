# =============================
# Scopa Client Deployment
# =============================
$DSP_SCOPACLIENT_TASKPATH = "\Sporacid\Scopa"
$DSP_SCOPACLIENT_DEPLOYMENTFOLDER = "C:\ScopaClient"

# ============================
# Remote host configuration
# ============================
$DSP_RemoteHostName = "VMSPPLAV"
$DSP_RemoteHostDestination = "\\VMSPPLAV\raw"
$DSP_LastScopaDate = "01/01/1970 12:00:00 PM"

# ========================
# Logs configuration
# ========================

# SharePoint 2013 Logs
$DSP_SP2013_LogsLocalPath = "C:\Logs\SP2013"
$DSP_SP2013_LogsFileNamePattern = "^([\w0-9]+)-([\d]{8})-[\d]{4}.log$"

# IIS Logs
$DSP_IIS_LogsLocalPath = "C:\Logs\IIS"
$DSP_IIS_LogsFileNamePattern = "^u_ex([\d]{6}).log$"