Loop {
  app  = msnmsgr.exe
  ; Live Messenger on my machine is having memory leaks, hence this script :)
  mem := GetProcessMemoryInfo(app)
  Menu, tray, tip, %app% %mem% KB
  if mem > 80000
  {
   Process, close, %app%
   TrayTip, %app% closed, %mem% KB used.
  }
  Sleep, 1000
}

; http://www.autohotkey.com/forum/viewtopic.php?p=223061#223061
GetProcessMemoryInfo( pname )
{
  Process, Exist, %pname%
  pid := Errorlevel

  ; get process handle
  hProcess := DllCall( "OpenProcess", UInt, 0x10|0x400, Int, false, UInt, pid )

  ; get memory info
  VarSetCapacity( memCounters, 40, 0 )
  DllCall( "psapi.dll\GetProcessMemoryInfo", UInt, hProcess, UInt, &memCounters, UInt, 40 )
  DllCall( "CloseHandle", UInt, hProcess )

  list = cb,PageFaultCount,PeakWorkingSetSize,WorkingSetSize,QuotaPeakPagedPoolUsage 
  ,QuotaPagedPoolUsage,QuotaPeakNonPagedPoolUsage,QuotaNonPagedPoolUsage 
  ,PagefileUsage,PeakPagefileUsage

  /*
  cb := NumGet( memCounters, 0, "UInt" )
  PageFaultCount := NumGet( memCounters, 4, "UInt" )
  PeakWorkingSetSize := NumGet( memCounters, 8, "UInt" )
  WorkingSetSize := NumGet( memCounters, 12, "UInt" )
  QuotaPeakPagedPoolUsage := NumGet( memCounters, 16, "UInt" )
  QuotaPagedPoolUsage := NumGet( memCounters, 20, "UInt" )
  QuotaPeakNonPagedPoolUsage := NumGet( memCounters, 24, "UInt" )
  QuotaNonPagedPoolUsage := NumGet( memCounters, 28, "UInt" )
  PagefileUsage := NumGet( memCounters, 32, "UInt" )
  PeakPagefileUsage := NumGet( memCounters, 36, "UInt" )
  */

  n=0 
  Loop, Parse, list, `,
  {
    n+=4
    SetFormat, Float, 0.0 ; round up K
    this := A_Loopfield
    this := NumGet( memCounters, (A_Index = 1 ? 0 : n-4), "UInt") / 1024

    ; omit cb
    If A_Index != 1
      info .= A_Loopfield . ": " . this . " K" . ( A_Loopfield != "" ? "`n" : "" )
  }

  ; Return "[" . pid . "] " . pname . "`n`n" . info ; for everything
  ; Return WorkingSetSize := NumGet( memCounters, 12, "UInt" ) / 1024 . " K" ; what Task Manager shows
  Return PagefileUsage := NumGet( memCounters, 32, "UInt" ) / 1024 ; what Task Manager shows
}