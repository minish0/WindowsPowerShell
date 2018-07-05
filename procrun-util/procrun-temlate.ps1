#requires -version 4

<#
.SYNOPSIS
  procrun template for jvm.dll mode

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
  #Script parameters go here
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
$logPath = Join-Path -Path $env:APPLICATION_HOME -ChildPath 'log'
$logProp = $logPath -Replace '\\','/'
$prunsrv = Join-Path $env:ZOOKEEPER_HOME -ChildPath "\bin\daemon\application.exe"
if (!$(Test-Path -Path "$prunsrv")) {
    $prunsrv = Join-Path $env:SPARK_HOME -ChildPath "\bin\daemon\prunsrv.exe"
}


& $prunsrv "//IS//java_application" `
        --DisplayName="java_application" `
        --Description="Java Application Service" `
        --Startup=manual --StartMode=jvm `
        --Classpath="$env:APPLICATION_HOME\*;$env:APPLICATION_HOME\lib\*;$env:APPLICATION_HOME\conf" `
        --StartClass="java.lang.Object.java_application" `
        ++StartParams="$env:APPLICATION_HOME\conf\java_appllication.properties" `
        ++JvmOptions="-Dfoo=bar" `
        --StopMode=jvm `
        --StopTimeout=5 `
        --StopClass="java.lang.System" `
        --StopMethod="exit" `
        --LogPath="$logPath" `
        --LogPrefix=java_application-wrapper `
        --PidFile=java_application.pid `
        --LogLevel=Info `
        --StdOutput=auto `
        --StdError=auto