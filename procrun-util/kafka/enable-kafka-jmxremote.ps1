& $(Join-Path $env:KAFKA_HOME -ChildPath "\bin\daemon\prunsrv.exe") //US/kafka `
++JvmOptions='-Dcom.sun.management.jmxremote.port=7169' `
++JvmOptions='-Dcom.sun.management.jmxremote.rmi.port=7169'
