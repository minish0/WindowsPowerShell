<#
.SYNOPSIS
zk-fwrule.ps1

.DESCRIPTION
Apache Zookeeper Windows Firewall Rule.

.PARAMETER Port
Default Native Port Number is 2181. If you had changed clientport  in the zoo.cfg, you would specify.

.PARAMETER QuorumPort
Default Storage Port Number is 2888. If you had changed in the zoo.cfg, you would specify.

.PARAMETER ElectionPort
Default Port Number is 3888. If you had changed in the zoo.cfg, you would specify.

.EXAMPLE
.\zk-fwrule.ps1


#>
Param (
    [Parameter()][ValidateRange(1024, 65000)][UInt16]$Port = 2181,
    [Parameter()][ValidateRange(1024, 65000)][UInt16]$QuorumPort = 2888,
    [Parameter()][ValidateRange(1024, 65000)][UInt16]$ElectionPort = 3888
)

#[Initialisations]

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

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

New-NetFirewallRule `
   -Name 'Zookeeper' `
   -DisplayName 'Zookeeper' `
   -Description 'Zookeeper clientport' `
   -Group 'zookeeper' `
   -Enabled True `
   -Profile Any `
   -Direction Inbound `
   -Action Allow `
   -Protocol TCP  `
   -LocalPort $Port

   New-NetFirewallRule `
   -Name 'Zookeeper_quorum' `
   -DisplayName 'Zookeeper_quorum' `
   -Description 'Zookeeper Quorum Port' `
   -Group 'zookeeper' `
   -Enabled True `
   -Profile Any `
   -Direction Inbound `
   -Action Allow `
   -Protocol TCP  `
   -LocalPort $QuorumPort

   New-NetFirewallRule `
   -Name 'Zookeeper_election' `
   -DisplayName 'Zookeeper_election' `
   -Description 'Zookeeper Leader Election Port' `
   -Group 'zookeeper' `
   -Enabled True `
   -Profile Any `
   -Direction Inbound `
   -Action Allow `
   -Protocol TCP  `
   -LocalPort $ElectionPort
