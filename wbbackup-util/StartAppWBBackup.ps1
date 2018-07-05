<#
.SYNOPSIS
StartAppWBBackup.ps1

.DESCRIPTION
Start Windows Server App Backup 

.EXAMPLE
.\StartAppWBBackup.ps1

#>
# https://docs.microsoft.com/en-us/powershell/module/windowsserverbackup/start-wbbackup
# Get scheduled(predefined) backup policy
# This example starts a backup by using the settings for scheduled backups defined in a backup policy.
# The first command gets the current backup policy and stores it in the variable named $Policy.
# The second command starts the backup. Because the command specifies the Async parameter, the cmdlet returns immediately.+
# The third command gets the backup status and stores it in the variable named $BackupJob. Because the second command includes the Async parameter, you can view the backup status by using the Get-WBJob cmdlet.

$Policy = Get-WBPolicy
# 
Start-WBBackup -Policy $Policy -Async
$BackupJob = Get-WBJob