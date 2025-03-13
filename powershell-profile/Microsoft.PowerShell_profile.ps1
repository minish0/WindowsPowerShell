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
New-Variable -Name CurrentHistoryId -Scope 'global' -description 'Current History Number'
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
	if ($PSVersionTable.Platform -eq 'Unix') {
		$windowTitleStr = $env:USER.ToLower() + '@' + $(uname -n) + ' : ' + $(Get-Location)
		$Host.UI.RawUI.WindowTitle = $windowTitleStr
	} else {
		$windowTitleStr = $env:USERNAME.ToLower() + '@' + $env:COMPUTERNAME.ToLower() + ' : ' + $(Get-Location)
		$Host.UI.RawUI.set_WindowTitle($windowTitleStr)
	}
}
##
## Push-DirStack is the function with a little modification for pushd on Unix/Linux.
## function for 'cd'
##
function Push-DirStack {
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
## Pop-DirStack is the function for popd in Unix/Linux.
##
function Pop-DirStack {
	Param(
		[Parameter(Mandatory=$False,Position=1)]
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
		if ($PSVersionTable.Platform -eq 'Unix') {
			$(uname -n) + '[' + $CurrentHistoryId + ']% '
		} else {
			$env:computername.ToLower() + '[' + $CurrentHistoryId + ']% '
		}
	} else {
		# following line is PS2 variable definition in UNIX sh
		'> ' * ($nestedpPomptLevel + 1)

	}
}
##
## Get-DirStack is the fuction for dirs on Unix/Linux.
##
function Get-DirStack {
  Param(
		[Parameter(Mandatory=$False,Position=1)]
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
function Export-History {
	Get-History -Count $SaveHistoryCount | Export-Clixml -Path $HistoryXml
}
###
### PowerShell profile initialization
###
#
# Remove original 'cd' alias, and set new one
#
Remove-Item alias:\cd
Set-Alias -Name cd -Value Push-DirStack
Set-Alias -Name dirs -Value Get-DirStack
Set-Alias -Name back -Value Pop-DirStack
# PowerTab: Tab expansion module
# http://powertab.codeplex.com/
<############### Start of PowerTab Initialization Code ########################
    Added to profile by PowerTab setup for loading of custom tab expansion.
    Import other modules after this, they may contain PowerTab integration.
#>
# Import-Module "PowerTab" -ArgumentList $PowerTabConfig
# Import-TabExpansionTheme "Blue"
################ End of PowerTab Initialization Code ##########################
if ("$env:USERPROFILE") {
	$DocumentsPath = $(Join-Path $env:USERPROFILE -ChildPath Documents)
} elseif ("$env:HOME") {
	$DocumentsPath = "$env:HOME"
}
if ("$DocumentsPath") {
	Push-DirStack $DocumentsPath
}
Register-EngineEvent PowerShell.Exiting -Action { Export-History }
If ($(Test-Path $HistoryXml)) {
	Import-Clixml -Path $HistoryXml | Add-History
}
