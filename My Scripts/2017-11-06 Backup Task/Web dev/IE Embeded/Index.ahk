#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#Include IE.ahk
#Include COM.ahk
#SingleInstance force


GoSub, GuiStart
SysGet, Scale, MonitorWorkArea

Gui, +LastFound +Resize
Gui, Show, x0 y0 w800 h610, , WebBrowser

hWnd := WinExist()

  pwb1 := IE_Add(hwnd,0,0,800,600)
  IE_LoadURL(pwb1, "http://www.google.com" )


Return

GuiStart:
COM_AtlAxWinInit()
COM_CoInitialize()
Return

GuiClose:
Gui, %A_Gui%:Destroy
COM_Release(pwb)
COM_CoUninitialize()
COM_AtlAxWinTerm()
ExitApp