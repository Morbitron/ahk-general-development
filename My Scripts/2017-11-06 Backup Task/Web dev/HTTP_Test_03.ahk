#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

GoSub, GuiOpen
pweb :=   COM_AtlAxCreateControl(WinExist(), "Shell.Explorer")
psink:=   COM_ConnectObject(pweb, "Web_")
COM_Invoke(pweb, "Silent", True)
COM_Invoke(pweb, "Navigate2", "http://www.mclink.it/cgi-bin/trace.pl")
Return

Navigate:
COM_Invoke(pweb, "Navigate2", _URL_)
Return

GuiOpen:
Gui, +Resize +LastFound
Gui, Show, w210 h270 Center, WebBrowser
COM_AtlAxWinInit()
Return

GuiClose:
COM_Release(psink)
COM_Release(pweb)
Gui, Destroy
COM_AtlAxWinTerm()
ExitApp

Web_NewWindow3(prms)
{
   Global   _URL_:=   COM_DispGetParam(prms,4)
   COM_DispSetParam(-1,prms,1,11)
   SetTimer, Navigate, -10
}