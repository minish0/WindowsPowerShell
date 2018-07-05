<#
.SYNOPSIS
SetAppWBBackupSched.ps1

.DESCRIPTION
Set Windows Server App Backup Schedule 

.PARAMETER Schedule
Specifies the times of day to create a backup. Time values are formatted as HH:MM and separated by a comma.

.EXAMPLE
.\SetAppWBBackupSched.ps1

#>
# https://docs.microsoft.com/en-us/powershell/module/windowsserverbackup/start-wbbackup
# https://docs.microsoft.com/en-us/powershell/module/windowsserverbackup/set-wbschedule

Param (
    [parameter(Position=0)][Datetime[]] $Schedule = '23:00'
)
# The first command creates a new backup policy object and stores it in a variable named $Policy.
$Policy = New-WBPolicy
# This command adds the ability to perform a bare-metal recovery to the backup policy in the $Policy variable.
# Add-WBBareMetalRecovery $Policy
# This command adds the current system state options to the backup policy in the $Policy variable.
# Add-WBSystemState $Policy
# This command stores the volume that has the drive letter D: in the variable named $Volume.
# $Volume = Get-WBVolume -VolumePath "D:"
# This command stores the volume in the $Volume variable in the backup policy in the $Policy variable.
# Add-WBVolume -Policy $Policy -Volume $Volume
####
### D:\app
# The next command creates a backup source, adds the file named D:\app to the backup source, and stores the backup source in a variable named $appFileSpec.
$AppFileSpec = New-WBFileSpec -FileSpec "D:\app"
# This command associates the backup source in the $appFileSpec variable with the backup policy in the $Policy variable.
Add-WBFileSpec -Policy $Policy -FileSpec $AppFileSpec
### D:\data
# The next command creates a backup source, adds the file named D:\data to the backup source, and stores the backup source in a variable named $dataFileSpec.
$dataFileSpec = New-WBFileSpec -FileSpec "D:\data"
# This command associates the backup source in the $dataFileSpec variable with the backup policy in the $Policy variable.
Add-WBFileSpec -Policy $Policy -FileSpec $dataFileSpec
# This command creates an exclusion file specification for .deleted files in the D:\data folder. The backup excludes MP3 files in C:\Sample and its subfolders and stores it in the variable named $deletedFilespec.
$deletedFilespec = New-WBFileSpec -FileSpec "D:\data\kafka\*.deleted" -Exclude
# This command associates the backup source in the $deletedFileSpec variable with the backup policy in the $Policy variable.
Add-WBFileSpec -Policy $Policy -FileSpec $deletedFileSpec
# This command creates an exclusion file specification for .index files in the D:\data folder. The backup excludes MP3 files in C:\Sample and its subfolders and stores it in the variable named $indexFilespec.
$indexFilespec = New-WBFileSpec -FileSpec "D:\data\kafka\*.index" -Exclude
# This command associates the backup source in the $deletedFileSpec variable with the backup policy in the $Policy variable.
Add-WBFileSpec -Policy $Policy -FileSpec $indexFileSpec
### D:\logs
# The next command creates a backup source, adds the file named D:\logs to the backup source, and stores the backup source in a variable named $FileSpec.
$logsFileSpec = New-WBFileSpec -FileSpec "D:\logs"
# This command associates the backup source in the $FileSpec variable with the backup policy in the $Policy variable.
Add-WBFileSpec -Policy $Policy -FileSpec $logsFileSpec
####
# This command creates a new backup location object that contains the volume that has the drive letter D: and then stores that object in the $BackupLocation variable.
$BackupLocation = New-WBBackupTarget -VolumePath "E:"
# This command adds the backup target based on the backup policy in the $Policy variable and the backup location in the $BackupLocation variable.
Add-WBBackupTarget -Policy $Policy -Target $BackupLocation
# This command specifies that the backup policy in the $Policy variable uses Volume Shadow Copy Service (VSS) copy backups.
Set-WBVssBackupOptions -Policy $Policy -VssCopyBackup
###
###
###
Get-WBPolicy -Policy $Policy
# This command starts the backup by using the backup policy in the $Policy variable.
# Start-WBBackup -Policy $Policy
#Set-WBSchedule -Policy $Policy -Schedule $Schedule