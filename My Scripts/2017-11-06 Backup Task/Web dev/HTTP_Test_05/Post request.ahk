#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
loginBody := "username=abc123&password=pass123&remember_me=1"
WebRequest.Open("POST", "https://www.scarlet.be/customercare/logon.do?language=fr")
WebRequest.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")

WebRequest.Send(loginBody)
html := WebRequest.ResponseText

Gui,Add,Edit,w600 +Wrap r25, %html%
Gui,Show
Return

GuiClose:
GuiEscape:
ExitApp