#requires -version 4

<#
.SYNOPSIS
spark-fwrule.ps1

.DESCRIPTION
Apache Spark Windows Firewall Rule.

.PARAMETER MasterPort
Default Master Port Number is 7077. If you had changed spark.master in spark-defaults.conf or $env:MASTER_PORT you would specify.

.PARAMETER MasterWebUIPort
Default Master Web UI Port Number is 8080. You can speficy $env:SPARK_MASTER_WEBUI_PORT.

.PARAMETER WorkerWebUIPort
Default Worker Web UI Port Number is 8081. You can speficy $env:SPARK_WORKER_WEBUI_PORT.

.EXAMPLE
spark-fwrule.ps1


#>
Param (
    [Parameter()][ValidateRange(1024, 65000)][UInt16]$MasterPort = 7077,
    [Parameter()][ValidateRange(1024, 65000)][UInt16]$MasterWebUIPort = 8080,
    [Parameter()][ValidateRange(1024, 65000)][UInt16]$WorkerWebUIPort = 8081
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
   -Name 'Spark_master' `
   -DisplayName 'Spark_master' `
   -Description 'Spark master port' `
   -Group 'spark' `
   -Enabled True `
   -Profile Any `
   -Direction Inbound `
   -Action Allow `
   -Protocol TCP  `
   -LocalPort $MasterPort

   New-NetFirewallRule `
   -Name 'Spark_master_webui' `
   -DisplayName 'Spark_master_webui' `
   -Description 'Spark master Web UI Port' `
   -Group 'spark' `
   -Enabled True `
   -Profile Any `
   -Direction Inbound `
   -Action Allow `
   -Protocol TCP  `
   -LocalPort $MasterWebUIPort

   New-NetFirewallRule `
   -Name 'Spark_worker_webui' `
   -DisplayName 'Spark_worker_webui' `
   -Description 'Spark worker Web UI Port' `
   -Group 'spark' `
   -Enabled True `
   -Profile Any `
   -Direction Inbound `
   -Action Allow `
   -Protocol TCP  `
   -LocalPort $WorkerWebUIPort
