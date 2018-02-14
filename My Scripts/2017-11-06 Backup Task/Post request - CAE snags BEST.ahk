#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



;Connect on login window

WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
loginBody := "txtUsername=ldesrochers&txtPassword=(ALPHA)M82A11&__VIEWSTATE=/wEPDwUJNTA0NDM5OTIwD2QWAgIBD2QWAgIJDw9kFgIeB29uQ2xpY2sFFWphdmFzY3JpcHQ6U2F2ZVVzZXIoKWRkQZneGDmz21wjZHf/rr3oGJnTKTM=&__VIEWSTATEGENERATOR=C2EE9ABB&__EVENTVALIDATION=/wEWBALNxOLLAwKl1bK4CQK1qbSRCwKC3IeGDFShXoghENEHlZGaL1NOTtSFZUPa&btnLogin=Login"
WebRequest.Open("POST", "https://simissues.cae.com/login.aspx?",True)
WebRequest.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
WebRequest.Send(loginBody)

Sleep, 3000

html := WebRequest.ResponseText

;MsgBox, % html

Gui,Add,Edit,w600 +Wrap r25 vleCode, %html%
Gui,Show





;Show List of snags
loginBody := ""
WebRequest.Open("POST", "https://simissues.cae.com/main/snaglist.asp",True)

WebRequest.Send(loginBody)

Sleep, 3000

html := WebRequest.ResponseText
GuiControl,,leCode,%html%





;Show first snag to fetch bigArray 
loginBody := ""
WebRequest.Open("POST", "https://simissues.cae.com/main/snagdetails.asp?cmd=issue_details&issueid=11432200082",True)


WebRequest.Send(loginBody)

Sleep, 3000

html := WebRequest.ResponseText
GuiControl,,leCode,%html%




;Show Results




Return

GuiClose:
GuiEscape:
ExitApp


;cmd=issue_details&issueid=11432200082
;https://simissues.cae.com/system/mCommand.asp?cmd=issue_details&issueid=11432200082