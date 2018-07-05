$prunsrv = Join-Path $env:KAFKA_HOME -ChildPath "\bin\daemon\kafka.exe"
if (!$(Test-Path -Path "$prunsrv")) {
    $prunsrv = Join-Path $env:KAFKA_HOME -ChildPath "\bin\daemon\prunsrv.exe"
}
# Service registration with Apache Commons Daemon(renamed prunsrv.exe)
& $prunsrv "//IS//kafka" `
 --DisplayName="kafka" `
 --Description="kafka broker Service" `
 --Startup=manual `
 --StartMode=jvm `
 --Classpath="$env:KAFKA_HOME\libs\*" `
 --StartClass=kafka.Kafka `
 ++StartParams="$env:KAFKA_HOME\config\server.properties" `
 --StopMode=jvm `
 --StopTimeout=5 `
 --StopClass="java.lang.System" `
 --StopMethod="exit" `
 --LogPath=D:\logs\kafka `
 --LogPrefix=kafka-wrapper `
 --PidFile=kafka.pid `
 --LogLevel=Info `
 --StdOutput=auto `
 --StdError=auto `
 ++DependsOn=zookeeper `
 ++JvmOptions="-Xmx1G" `
 ++JvmOptions="-Xms1G" `
 ++JvmOptions="-XX:+UseG1GC" `
 ++JvmOptions="-XX:MaxGCPauseMillis=20" `
 ++JvmOptions="-XX:InitiatingHeapOccupancyPercent=35" `
 ++JvmOptions="-XX:+ExplicitGCInvokesConcurrent" `
 ++JvmOptions="-Djava.awt.headless=true" `
 ++JvmOptions="-Dcom.sun.management.jmxremote" `
 ++JvmOptions="-Dcom.sun.management.jmxremote.authenticate=false" `
 ++JvmOptions="-Dcom.sun.management.jmxremote.ssl=false" `
 ++JvmOptions="-Dkafka.logs.dir=D:/logs/kafka" `
 ++JvmOptions="-Dlog4j.configuration=file:///D:/app/kafka/config/log4j.properties"