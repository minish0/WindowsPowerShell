$drvName = Split-Path -Path "$env:KAFKA_MANAGER_HOME" -Qualifier
$logPath = Join-Path -Path $drvName -ChildPath 'logs\kafka-manager'
$prunsrv = Join-Path $env:KAFKA_MANAGER_HOME -ChildPath "\bin\daemon\kafkamgr.exe"
if (!$(Test-Path -Path "$prunsrv")) {
    $prunsrv = Join-Path $env:KAFKA_MANAGER_HOME -ChildPath "\bin\daemon\prunsrv.exe"
}
# Service registration with Apache Commons Daemon(renamed prunsrv.exe)
& $prunsrv "//IS//kafkamgr" `
    --DisplayName="kafka manager" `
    --Description="kafka manager Service" `
    --Startup=manual `
    --StartMode=jvm `
    --Classpath="$env:KAFKA_MANAGER_HOME\conf;$env:KAFKA_MANAGER_HOME\lib\*" `
    --StartClass="play.core.server.ProdServerStart" `
    --StopMode=jvm `
    --StopTimeout=5 `
    --StopClass="java.lang.System" `
    --StopMethod="exit" `
    --LogPath="$logPath" `
    --LogPrefix=kafkamgr-wrapper `
    --PidFile=kafkamgr.pid `
    --LogLevel=Info `
    --StdOutput=auto `
    --StdError=auto
