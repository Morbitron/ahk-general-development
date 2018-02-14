#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;-------- http://www.autohotkey.com/forum/topic76490.html ---
Firefox=y

/*

   -------- if use FireFox -----------------
   For Mozilla browser download Xulrunner:
   http://releases.mozilla.org/pub/mozilla.org/xulrunner/releases/1.9.2b1/runtimes/
   You need to register the Mozilla ActiveX first, something like this:
   Run, regsvr32 "c:\programme\xulrunner\mozctlx.dll"

    --Download COM
   http://www.autohotkey.com/forum/viewtopic.php?t=22923
   http://www.autohotkey.net/~Sean/Lib/COM.zip

   http://www.autohotkey.com/forum/viewtopic.php?t=51020
   http://www.autohotkey.com/forum/viewtopic.php?t=19225

   Streamripper ................... http://sourceforge.net/projects/streamripper
                                    streamripper.exe   &   tre.dll
                                    records radio found in shoutcast
*/


MODIFIED=20110914
COM_AtlAxWinInit()
Gui,2: +LastFound +Resize
Gui,2:Color,black

if Firefox=y
   pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),70,10,710,480, "Mozilla.Browser") )
else
   pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),70,10,710,480, "Shell.Explorer") )

COM_Invoke(pwb, "Navigate", "about:blank")
Gui,2:Add,Button,x5 y10  gA1,Google
Gui,2:Add,Button,x5 y40  gA2,Yahoo
Gui,2:Show, x100 y50 w800 h500,Gui Browser
return
;---------------------------------------------
A1:
url:="http://www.google.com"
COM_Invoke(pwb, "Navigate", url)
loop
      If (rdy:=COM_Invoke(pwb,"readyState") = 4)
         break
return
;---------------------------------------------
A2:
url:="http://www.Yahoo.com"
COM_Invoke(pwb, "Navigate", url)
loop
      If (rdy:=COM_Invoke(pwb,"readyState") = 4)
         break
return
;---------------------------------------------
2Guiclose:
;MsgBox, 262208, Done, Goodbye,5
Gui,2: Destroy
COM_AtlAxWinTerm()
ExitApp
