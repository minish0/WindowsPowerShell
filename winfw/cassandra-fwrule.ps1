#requires -version 4

<#
.SYNOPSIS
cassandra-fwrule.ps1

.DESCRIPTION
Apache Cassandra Windows Firewall Rule.

.PARAMETER NativeTrnPort
Default Native Port Number is 9042. If you had changed native_transport_port  in the cassandra.yaml, you would specify.

.PARAMETER StoragePort
Default Storage Port Number is 7000. If you had changed storage_port in the cassandra.yaml, you would specify.

.PARAMETER RpcPort
Default Port Number is 9160. If you had changed rpc_port in the cassandra.yaml, you would specify.

.EXAMPLE
cassandra-fwrule.ps1


#>
#[Script Parameters]
Param (
    [Parameter()][ValidateRange(1024, 65000)][UInt16]$NativeTrnPort = 9042,
    [Parameter()][ValidateRange(1024, 65000)][UInt16]$StoragePort = 7000,
    [Parameter()][ValidateRange(1024, 65000)][UInt16]$RpcPort = 9160
)

#[Initialisations]

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#Import Modules & Snap-ins

#[Declarations]

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
   -Name 'cassandra_native_transport' `
   -DisplayName 'cassandra_native_transport' `
   -Description 'Cassandra Native Transport (CQL)' `
   -Group 'cassandra' `
   -Enabled True `
   -Profile Any `
   -Direction Inbound `
   -Action Allow `
   -Protocol TCP  `
   -LocalPort $NativeTrnPort

   New-NetFirewallRule `
   -Name 'cassandra_storage_port' `
   -DisplayName 'cassandra_storage_port' `
   -Description 'Cassandra Storage Port' `
   -Group 'cassandra' `
   -Enabled True `
   -Profile Any `
   -Direction Inbound `
   -Action Allow `
   -Protocol TCP  `
   -LocalPort $StoragePort

   New-NetFirewallRule `
   -Name 'cassandra_rpc_port' `
   -DisplayName 'cassandra_rpc_transport' `
   -Description 'Cassandra Thrift RPC Port' `
   -Group 'cassandra' `
   -Enabled True `
   -Profile Any `
   -Direction Inbound `
   -Action Allow `
   -Protocol TCP  `
   -LocalPort $RpcPort
