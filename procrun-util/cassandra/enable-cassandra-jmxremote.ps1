#requires -version 4

<#
.SYNOPSIS
  Enables Apache Cassandra Service with JMX Remote (plain text) configuration

.DESCRIPTION
  <Brief description of script>

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
  [Parameter()][ValidateRange(1024, 65000)][UInt16]$Port = 7199,
  [Parameter()][Switch]$DisableSSL,
  [Parameter()][Switch]$DisabbleAuth
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


& $(Join-Path $env:CASSANDRA_HOME -ChildPath "\bin\daemon\prunsrv.exe") //US/cassandra `
 ++JvmOptions="-Dcassandra.jmx.remote.port=$Port" `
 ++JvmOptions="-Dcom.sun.management.jmxremote" `
 ++JvmOptions="-Dcom.sun.management.jmxremote.port=$Port" `
 ++JvmOptions="-Dcom.sun.management.jmxremote.rmi.port=$Port" `
 ++JvmOptions="-Dcom.sun.management.jmxremote.ssl=false" `
 ++JvmOptions="-Dcom.sun.management.jmxremote.authenticate=false"
