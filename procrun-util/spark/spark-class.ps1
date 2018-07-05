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
    [parameter][String]$masterURL
)

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