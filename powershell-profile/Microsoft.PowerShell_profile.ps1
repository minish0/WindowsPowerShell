###
### Microsoft.PowerShell_profile.ps1: PowerShell customization
###
###
### Global Variables(must define with description)
###
##
## PSProfileRev: PowerShell Profile Revision
##
New-Variable -Name PSProfileRev -Value '$Revision$' -Scope 'global' -description 'PowerShell profile Revision' -Option 'Constant'
##
## CurrentHistoryId: current history number
##
New-Variable -Name CurrrentHistoryId -Scope 'global' -description 'Current History Number'
##
## PowerTabConfig: PowerTab Configration
##
# New-Variable -Name PowerTabConfig -Value $(Join-Path $env:USERPROFILE -ChildPath Documents\WindowsPowerShell\PowerTabConfig.xml) -Scope 'global' -description 'PowerTab Configuration File'
##
## HistoryXml: exported history XML file
##
New-Variable -Name HistoryXml -Scope 'global' -description 'exported history XML file' -Value $(Join-Path -Path $(Split-Path -Path $profile) -ChildPath 'history.xml')
New-Variable -Name SaveHistoryCount -Scope 'global' -description 'maximum exported history count' -Value 100
###
### Functions
###
##
##
##
## Get-Current-History-Id()
##
function Get-Current-History-Id {
	$prevcount = Get-History -Count 1
	if ($prevcount) {
		$prevcount.get_Id() + 1
	} else {
		1
	}
}
##
## Set-WindowTitle
## display current user and directory PowerShell window title
##
function Set-WindowTitle {
	$Host.UI.RawUI.set_WindowTitle($env:USERNAME.ToLower() + '@' + $env:COMPUTERNAME.ToLower() + ' : ' + $(Get-Location))
}
##
## Change-Directory-Function
## function for 'cd'
##
function Change-Directory-Function {
	Param(
		[Parameter(Mandatory=$False,Position=1)]
		[string] $Destination = $env:USERPROFILE,

		[Parameter(Mandatory=$False,Position=2)]
		[string] $StackName
	)
	#Set-Location $destination
	if ($StackName) {
		Push-Location $destination -StackName $StackName
	} else {
		Push-Location $destination
	}
	if ($?) {
		Write-Host $(Get-Location)
		Set-WindowTitle
	}
}
##
## function for back location
##
function Back-Directory-Function {
	Param(
		[string] $StackName
	)
	if ($StackName) {
		Pop-Location -StackName $StackName
	} else {
		Pop-Location
	}
	if ($?) {
		Write-Host $(Get-Location)
		Set-WindowTitle
	}
}
##
## prompt()
## Customize PowerShell prompt
##
function prompt {
	# In PowerShell, prompt definition is function.
	# If you want to configure UNIX sh style prompt,
	# you can define following templates.
	if ($nestedpromptlevel -lt 1) {
		# following line is like UNIX style
		# '[ ' + $env:username.ToLower() + '@' + $env:computername.ToLower() + ' : ' +
		# $(Get-Location) + ' ]% '
		$CurrentHistoryId = $(Get-Current-History-Id)
		$env:computername.ToLower() + '[' + $CurrentHistoryId + ']% '
	} else {
		# following line is PS2 variable definition in UNIX sh
		'> ' * ($nestedpPomptLevel + 1)

	}
}
##
## Dirs-Function
##
function Dirs-Function {
  Param(
	[string] $StackName
  )
  if ($StackName) {
	Get-Location -Stack -StackName $StackName
  } else {
	Get-Location -Stack
  }
}
##
## ExportHistory
##
function ExportHistory {
	Get-History -Count $SaveHistoryCount | Export-Clixml -Path $HistoryXml
}
###
### PowerShell profile initialization
###
#
# Remove original 'cd' alias, and set new one
#
Remove-Item alias:\cd
Set-Alias -Name cd -Value Change-Directory-Function
Set-Alias -Name dirs -Value Dirs-Function
Set-Alias -Name back -Value Back-Directory-Function
# PowerTab: Tab expansion module
# http://powertab.codeplex.com/
<############### Start of PowerTab Initialization Code ########################
    Added to profile by PowerTab setup for loading of custom tab expansion.
    Import other modules after this, they may contain PowerTab integration.
#>
# Import-Module "PowerTab" -ArgumentList $PowerTabConfig
# Import-TabExpansionTheme "Blue"
################ End of PowerTab Initialization Code ##########################
$DocumentsPath = $(Join-Path $env:USERPROFILE -ChildPath Documents)
Register-EngineEvent PowerShell.Exiting -Action { ExportHistory }
cd $DocumentsPath
If ($(Test-Path $HistoryXml)) {
	Import-Clixml -Path $HistoryXml | Add-History
}
