<#
.SYNOPSIS
StartSystemWBBackup.ps1

.DESCRIPTION
Start Windows Server System Backup 

.EXAMPLE
.\StartSystemWBBackup.ps1

#>
# https://docs.microsoft.com/en-us/powershell/module/windowsserverbackup/start-wbbackup

# The first command creates a new backup policy object and stores it in a variable named $Policy.
$Policy = New-WBPolicy
# This command adds the ability to perform a bare-metal recovery to the backup policy in the $Policy variable.
Add-WBBareMetalRecovery $Policy
# This command adds the current system state options to the backup policy in the $Policy variable.
Add-WBSystemState $Policy
# This command stores the volume that has the drive letter C: in the variable named $Volume.
$Volume = Get-WBVolume -VolumePath "C:"
# This command stores the volume in the $Volume variable in the backup policy in the $Policy variable.
Add-WBVolume -Policy $Policy -Volume $Volume
# This command creates a new backup location object that contains the volume that has the drive letter D: and then stores that object in the $BackupLocation variable.
$BackupLocation = New-WBBackupTarget -VolumePath "D:" -PreserveExistingBackups $True
# This command adds the backup target based on the backup policy in the $Policy variable and the backup location in the $BackupLocation variable.
Add-WBBackupTarget -Policy $Policy -Target $BackupLocation
# This command specifies that the backup policy in the $Policy variable uses Volume Shadow Copy Service (VSS) copy backups.
Set-WBVssBackupOptions -Policy $Policy -VssCopyBackup
# This command starts the backup by using the backup policy in the $Policy variable.
Start-WBBackup -Policy $Policy