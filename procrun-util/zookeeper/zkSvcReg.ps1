$prunsrv = Join-Path $env:ZOOKEEPER_HOME -ChildPath "\bin\daemon\zookeeper.exe"
if (!$(Test-Path -Path "$prunsrv")) {
    $prunsrv = Join-Path $env:SPARK_HOME -ChildPath "\bin\daemon\prunsrv.exe"
}
$logPath = Join-Path -Path $env:ZOOKEEPER_HOME -ChildPath 'log'
$logProp = $logPath -Replace '\\','/'
& $prunsrv "//IS//zookeeper" `
        --DisplayName="Zookeeper" `
        --Description="Zookeeper Service" `
        --Startup=manual --StartMode=jvm `
        --Classpath="$env:ZOOKEEPER_HOME\*;$env:ZOOKEEPER_HOME\lib\*;$env:ZOOKEEPER_HOME\conf" `
        --StartClass=org.apache.zookeeper.server.quorum.QuorumPeerMain `
        ++StartParams="$env:ZOOKEEPER_HOME\conf\zoo.cfg" `
        ++JvmOptions="-Dzookeeper.log.dir=$logProp" `
        ++JvmOptions="-Dzookeeper.root.logger=INFO,CONSOLE" `
        --StopMode=jvm --StopTimeout=5 `
        --StopClass="java.lang.System" `
        --StopMethod="exit" `
        --LogPath="$logPath" `
        --LogPrefix=zookeeper-wrapper `
        --PidFile=zookeeper.pid `
        --LogLevel=Info `
        --StdOutput=auto `
        --StdError=auto