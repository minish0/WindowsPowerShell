$prunsrv = Join-Path $env:SPARK_HOME -ChildPath "\bin\daemon\sparkworker.exe"
if (!$(Test-Path -Path "$prunsrv")) {
    $prunsrv = Join-Path $env:SPARK_HOME -ChildPath "\bin\daemon\prunsrv.exe"
}
Param (
    [parameter(Mandatory=$True,Position=0)][String]$masterURL
)
# Service registration with Apache Commons Daemon(renamed prunsrv.exe)
& $prunsrv "//IS//sparkworker" `
        --DisplayName="Spark Worker" `
        --Description="Spark Worker Service" `
        --Jvm="auto" `
        --Startup=manual `
        --StartMode=jvm `
        --Classpath="$env:SPARK_HOME\conf\;$env:SPARK_HOME\jars\*" `
        --StartClass="org.apache.spark.deploy.worker.Worker" `
        ++StartParams="$masterURL" `
        --StopMode=jvm `
        --StopTimeout=5 `
        --StopClass="java.lang.System" `
        --StopMethod="exit" `
        --LogPath="D:\logs\spark" `
        --LogPrefix=spark-worker-wrapper `
        --PidFile=sparkworker.pid `
        --LogLevel=Info `
        --StdOutput=auto `
        --StdError=auto
