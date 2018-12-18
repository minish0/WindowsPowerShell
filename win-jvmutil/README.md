# win-jvmutil

Search Win32_Process process via WMI and dump heap or thread, also check/start/stop Java Flight Recorder(jfr).

* jvm-heapdump.ps1: Java heap memory dump(jcmd GC.heap_dump)
* jvm-jfrcheck.ps1: Java Flight Recorder availability chekck(jcmd JFR.check)
* jvm-jfrstart.ps1: Start Java Flight Recording (jcmd JFR.start) 
* jvm-jfrstop.ps1: Stop Java Flight Recording (jcmd JFR.stop)
* jvm-tdump.ps1: Java Thread Dump(jstack -l)

