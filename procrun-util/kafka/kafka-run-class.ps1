# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#requires -version 4

<#
.SYNOPSIS
  kafka-run-class.ps1

.DESCRIPTION
  kafka class launcher for PowerShell.
  Ported from kafka-run-class.bat.

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
  kafka-run-class.ps1 'kafka.Kafka' server.properties
  
  <Example goes here. Repeat this attribute for more than one example>
#>

#[Script Parameters]

Param (
  #Script parameters go here
)

#[Initialisations]

#Set Error Action: Stop,Inquire,Continue,Suspend,SilentlyContinue
$ErrorActionPreference = 'SilentlyContinue'

#Import Modules & Snap-ins

#-[Declarations]-
#Any Global Declarations go here
New-Variable -Name scala_version -Value '2.11.12'

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
$scalaVersionArray = $scala_version -split '\.'
$scalaBinaryVersion = "$scalaVersionArray[0]" + '.' + "$scalaVersionArray[1]"
# $javaCmd retrieves Environment JAVA_HOME
$javaCmd = Join-Path -Path "$env:JAVA_HOME" -ChildPath "bin\java.exe"
if ($env:KAFKA_HOME) {
    $kafkaHome = $env:KAFKA_HOME
} else {
    $kafkaHome = Split-Path -Path $(Split-Path -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent) -Parent) -Parent
}

# $kafkaHeapOpts
$kafkaHeapOpts = '-Xmx256M'
# $kafkaJvmPerfOpts
$kafkaJvmPerfOpts = '-server','-XX:+UseG1GC','-XX:MaxGCPauseMillis=20','-XX:InitiatingHeapOccupancyPercent=35','-XX:+ExplicitGCInvokesConcurrent','-Djava.awt.headless=true'
# $kafkaJmxOpts
$kafkaJmxOpts = '-Dcom.sun.management.jmxremote','-Dcom.sun.management.jmxremote.authenticate=false','-Dcom.sun.management.jmxremote.ssl=false'
if ("x$kafkaJmxPort" -ne "x") {
    $kafkaJmxOpts += "-Dcom.sun.management.jmxremote.port=$kafkaJmxPort"
}
# $kafkaLog4JOpts
if ("x$kafkaLog4JOpts" -eq "x") {
  $kafkaLog4JOpts = "-Dlog4j.configuration='$kafkaHome\\config\\tools-log4j.properties'","-Dkafka.logs.dir='$kafkaHome\\logs'"
}
# $kafkaClassPath
$kafkaClassPath = Join-Path -Path "$kafkaHome" -ChildPath 'libs\*'
# $kafkaOpts
& $javaCmd "$kafkaHeapOpts" $kafkaJvmPerfOpts $kafkaJmxOpts  $kafkaLog4JOpts -cp "$kafkaClassPath" $args
