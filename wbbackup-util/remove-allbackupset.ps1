$wbpolicy = GetWBPolicy
$wbtarget = GetWBBackupTarget -Policy $wbpolicy
$wbbackupset = Get-WBBackupSet -BackupTarget $wbtarget
Remove-WBBackupSet $wbbackupset

