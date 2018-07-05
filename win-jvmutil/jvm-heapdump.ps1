#requires -version 4

<#
.SYNOPSIS
  Java Heap Dump Utility

.DESCRIPTION
  Java Heap Dump on demand

.PARAMETER Name
  JVM class name or JAR archive for identify

.PARAMETER Dir
  Directory for heap dump

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
    [Parameter(Position=0,Mandatory)][String]$Name,
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
$jvmProcess = get-wmiobject -class win32_process -Filter "commandline like '%$Name%'" | select-object 'Name','ProcessID','CommandLine'
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

#& "$jcmd" $jvmProcess.ProcessID JFR.start duration="$Duration" filename="$jfrName"
& "$jcmd" $jvmProcess.ProcessID GC.heap_dump -all=true "$jhdName"