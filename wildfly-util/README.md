Various Java 8 performance for WildFly on Windows Power Shell.
Captures Process ID via WMI and handle with jcmd.exe or jstack.exe.

* wf-heapdump.ps1: Java heap memory dump(jcmd GC.heap_dump)
* wf-jfrcheck.ps1: Java Flight Recorder availability chekck(jcmd JFR.check)
* wf-jfrstart.ps1: Start Java Flight Recording (jcmd JFR.start) 
* wf-jfrstop.ps1: Stop Java Flight Recording (jcmd JFR.stop)
* wf-tdump.ps1: Java Thread Dump(jstack -l)
