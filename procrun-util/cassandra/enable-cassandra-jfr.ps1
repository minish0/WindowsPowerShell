& $(Join-Path $env:CASSANDRA_HOME -ChildPath "\bin\daemon\prunsrv.exe") //US/cassandra `
++JvmOptions="-XX:+UnlockCommercialFeatures" `
++JvmOptions="-XX:+FlightRecorder"