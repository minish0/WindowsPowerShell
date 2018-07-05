$prunsrv = Join-Path $env:SPARK_HOME -ChildPath "\bin\daemon\sparkmaster.exe"
if (!$(Test-Path -Path "$prunsrv")) {
    $prunsrv = Join-Path $env:SPARK_HOME -ChildPath "\bin\daemon\prunsrv.exe"
}
# Service registration with Apache Commons Daemon(renamed prunsrv.exe)
& $prunsrv "//IS//sparkmaster" `
        --DisplayName="Spark Master" `
        --Description="Spark Master Service" `
        --Jvm="auto" `
        --Startup=manual --StartMode=jvm `
        --Classpath="$env:SPARK_HOME\conf\;$env:SPARK_HOME\jars\*" `
        --StartClass="org.apache.spark.deploy.master.Master" `
        --StartMethod="main" `
        --StopMode=jvm `
        --StopTimeout=5 `
        --StopClass="java.lang.System" `
        --StopMethod="exit" `
        --LogPath="D:\logs\spark" `
        --LogPrefix=spark-master-wrapper `
        --PidFile=sparkmaster.pid `
        --LogLevel=Info `
        --StdOutput=auto `
        --StdError=auto