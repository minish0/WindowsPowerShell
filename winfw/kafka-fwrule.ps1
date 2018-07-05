#requires -version 4

<#
.SYNOPSIS
kafka-fwrule.ps1

.DESCRIPTION
Apache Kafka Windows Firewall Rule.

.PARAMETER Port
Default Port Number is plaintext:9092. If you had changed in listeners in the server.properties, you would specify.


.EXAMPLE
kafka-fwrule.ps1


#>
Param (
    [Parameter()][ValidateRange(1024, 65000)][UInt16]$Port = 9092
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
   -Name 'kafka_listeners' `
   -DisplayName 'kafka_listeners' `
   -Description 'Apache kafka listeners' `
   -Group 'kafka' `
   -Enabled True `
   -Profile Any `
   -Direction Inbound `
   -Action Allow `
   -Protocol TCP  `
   -LocalPort $Port
