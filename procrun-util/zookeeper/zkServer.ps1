#requires -version 4

<#
.SYNOPSIS
  Zookeeper Server invocation Script

.DESCRIPTION
  Run foreground Zookeeper on PowerShell console

.PARAMETER ZkLogDir
  Zookeeper Log Directory. If not specified, log under $env:ZOOKEEPER_HOME .

.PARAMETER ZkConfig
  Zookeeper Configuration File. If not specified, conf\zoo.cfg under $env:ZOOKEEPER_HOME .  

.PARAMETER ZkLog4JProp
  Zookeeper Log4J Property. default: 'INFO,CONSOLE'

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
  zkServer.ps1

.EXAMPLE
  zkServer.ps1 -ZkConfig C:\etc\zoo.cfg

  
#>

#[Script Parameters]

Param (
  #Script parameters go here
  [String]$ZkLogDir,
  [String]$ZkConfig,
  [String]$ZkLog4JProp = 'INFO,CONSOLE'
)

#[Initialisations]

#Set Error Action: Stop,Inquire,Continue,Suspend,SilentlyContinue
$ErrorActionPreference = 'Stop'

#Import Modules & Snap-ins

#-[Declarations]-

#Any Global Declarations go here
$zooMain = 'org.apache.zookeeper.server.quorum.QuorumPeerMain'
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
if ($env:ZOOKEEPER_HOME) {
    $zkHome = $env:ZOOKEEPER_HOME
} else {
    $zkHome = Split-Path -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent) -Parent
}

if (!$ZkLogDir) {
    $logPath = Join-Path -Path "$zkHome" -ChildPath 'logs'
}

$logDirProp = $logPath -Replace '\\','/'
if (!$ZkConfig) {
    $ZkConfig = Join-Path -Path "$zkHome" -ChildPath "conf\zoo.cfg"
}
$zkConfigDir = Split-Path -Path "$ZkConfig" -Parent
$zkLibDir = Join-Path -Path "$zkHome" -ChildPath "lib"
$zkClassPath = "$zkHome\\*","$zkLibDir\\*","$zkConfigDir" -Join ';'
$javaCmd = Join-Path -Path "$env:JAVA_HOME" -ChildPath "bin\java.exe"
$host.ui.RawUI.WindowTitle = "Zookeeper"
Write-Host "$zkHome"
Write-Host "$logDirProp"
Write-Host "$zkClassPath"
Write-Host "$ZkConfig"
& $javaCmd "-Dzookeeper.log.dir=$logDirProp" "-Dzookeeper.root.logger='$ZkLog4JProp'" "-XX:+HeapDumpOnOutOfMemoryError" -cp "$zkClassPath" "$zooMain" "$ZkConfig"
