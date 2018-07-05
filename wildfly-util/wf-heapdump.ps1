#requires -version 4

<#
.SYNOPSIS
  WildFly Java Heap Dump Utility

.DESCRIPTION
  Start WildFly Java Heap Dump on demand

.PARAMETER <Parameter_Name>
  <Brief description of parameter input required. Repeat this attribute if required>

.INPUTS
  <Inputs if any, otherwise state None>

.OUTPUTS
  <Outputs if any, otherwise state None>

.NOTES
  Version:        1.0
  Author:         <Name>
  Creation Date:  <Date>
  Purpose/Change: Initial script development

.EXAMPLE
  <Example explanation goes here>
  
  <Example goes here. Repeat this attribute for more than one example>
#>

#[Script Parameters]

Param (
    [Parameter()][String]$Dir = $(Get-Location)
)

#[Initialisations]

#Set Error Action to Silently Continue
# $ErrorActionPreference = 'SilentlyContinue'

#Import Modules & Snap-ins

#-[Declarations]-

#Any Global Declarations go here

#[Functions]

<#

Function <FunctionName> {
  Param ()

  Begin {
    Write-Host '<description of what is going on>...'
  }

  Process {
    Try {
      <code goes here>
    }

    Catch {
      Write-Host -BackgroundColor Red "Error: $($_.Exception)"
      Break
    }
  }

  End {
    If ($?) {
      Write-Host 'Completed Successfully.'
      Write-Host ' '
    }
  }
}

#>

#[Execution]

#Script Execution goes here
$wfProcess = get-wmiobject -class win32_process -Filter 'name = "java.exe" and commandline like "%wildfly%"' | select-object 'Name','ProcessID','CommandLine'
if ($PSVersionTable.PSVersion.Major -eq '4') {
    $javaHome = $(Get-ItemProperty -Path 'HKLM:\SOFTWARE\JavaSoft\Java Development Kit\1.8').JavaHome
} else {
    $javaHome = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\JavaSoft\Java Development Kit\1.8' -Name JavaHome
}
$jcmd = Join-Path -Path "$javaHome" -ChildPath 'bin\jcmd.exe'
$jhdPrefix = "heapdump_WildFly-$env:COMPUTERNAME"
$jhdList = Get-ChildItem "${Dir}\${jhdPrefix}*"
$jhdIndex = $jhdList.count + 1
$jhdName = "${Dir}\${jhdPrefix}_${jhdIndex}.hprof"

#& "$jcmd" $wfProcess.ProcessID JFR.start duration="$Duration" filename="$jfrName"
& "$jcmd" $wfProcess.ProcessID GC.heap_dump -all=true "$jhdName"