<#
.SYNOPSIS
spark-class.ps1

.DESCRIPTION
Apache Spark Launcher

.PARAMETER deployClass
A part of deploy class (one of master, worker, history).
If no class was specified, get class from script name.

.EXAMPLE
.\spark-class.ps1 'master' # invoke Spark master

.EXAMPLE
Copy-Item .\spark-class.ps1 .\spark-worker.ps1 ; .\spark-worker.ps1 

#>
Param (
    [parameter(Position=0)][String]$deployClass = $MyInvocation.MyCommand.Definition,
    [parameter(Position=1)][String]$masterURL,
    [parameter(Position=2)][String]$scalaVer = "2.11"
)

$env:SPARK_SCALA_VERSION = "$scalaVer"
$env:SPARK_CONF_DIR = Join-Path -Path "$env:SPARK_HOME" -ChildPath "conf"
$sparkEnv = Join-Path -Path "$env:SPARK_HOME" -ChildPath "conf\spark-env.ps1"
if (Test-Path "$sparkEnv") {
    & $sparkEnv
}

$classPrefix = "org.apache.spark.deploy."

switch -wildcard ($deployClass) {
    "*master*" {
        $windowTitle = "Saprk: Master"
        $exactClass = $classPrefix + 'master.Master'
     }
    "*worker*" { 
        $windowTitle = "Spark: Worker"
        $exactClass = $classPrefix + 'worker.Worker'
        if ($masterURL -eq $Null) {
            Write-Output "Specify Master URL with -masterURL Parameter"
            Exit
        }
     }
    "*history*" {
        $windowTitle = "Spark: HistoryServer"
        $exactClass = $classPrefix + 'history.HistoryServer'
     }
    default { 
        Write-Output "No class matched"
        Exit
     }
}

$jre = Join-Path -Path "$env:JAVA_HOME" -ChildPath '\bin\java.exe'
$classpath = "$env:SPARK_HOME" + '\conf\;' + "$env:SPARK_HOME" + '\jars\*'
$jvmopts = '-Xmx1g'
# "C:\Program Files\Java\jre1.8.0_151\bin\java" -cp "D:\app\spark\conf\;D:\app\spark\jars\*" -Xmx1g org.apache.spark.deploy.master.Master
$host.ui.RawUI.WindowTitle = "$windowTitle"
& "$jre" -cp "$classpath" $jvmopts $exactClass $masterURL
