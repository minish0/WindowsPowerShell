$prunsrv = Join-Path $env:SPARK_HOME -ChildPath "\bin\daemon\sparkhistory.exe"
if (!$(Test-Path -Path "$prunsrv")) {
    $prunsrv = Join-Path $env:SPARK_HOME -ChildPath "\bin\daemon\prunsrv.exe"
}
# Service registration with Apache Commons Daemon(renamed prunsrv.exe)
& $prunsrv "//IS//sparkhistory" `
        --DisplayName="Spark History" `
        --Description="Spark History Service" `
        --Jvm="auto" `
        --Startup=manual --StartMode=jvm `
        --Classpath="$env:SPARK_HOME\conf\;$env:SPARK_HOME\jars\*" `
        --StartClass="org.apache.spark.deploy.history.HistoryServer" `
        --StartMethod="main" `
        --StopMode=jvm `
        --StopTimeout=5 `
        --StopClass="java.lang.System" `
        --StopMethod="exit" `
        --LogPath="D:\logs\spark" `
        --LogPrefix=spark-history-wrapper `
        --PidFile=sparkhistory.pid `
        --LogLevel=Info `
        --StdOutput=auto `
        --StdError=auto