
id=_CNehPJrZzY
;fx=https://simissues.cae.com/system/mCommand.asp?cmd=issue_details&issueid=11432200082
URL=https://simissues.cae.com/login.aspx
;fx=https://www.google.com/
;fx:="https://autohotkey.com/boards/"

Flags := 0
TargetFrame := ""
PostData := "txtUsername=ldesrochers&txtPassword=(ALPHA)M82A11&__VIEWSTATE=/wEPDwUJNTA0NDM5OTIwD2QWAgIBD2QWAgIJDw9kFgIeB29uQ2xpY2sFFWphdmFzY3JpcHQ6U2F2ZVVzZXIoKWRkQZneGDmz21wjZHf/rr3oGJnTKTM=&__VIEWSTATEGENERATOR=C2EE9ABB&__EVENTVALIDATION=/wEWBALNxOLLAwKl1bK4CQK1qbSRCwKC3IeGDFShXoghENEHlZGaL1NOTtSFZUPa&btnLogin=Login"
Headers := "Content-Type: application/x-www-form-urlencoded"


/*
arr2 := ComObj(vt, PostData)
MsgBox, % arr2
*/


xxa=Shell.Explorer                  ;- IExplorer
;xxa=Mozilla.Browser                  ;- firefox
Gui Add, ActiveX, w980 h640 vWB,%xxa%
WB.Silent := True
WB.Navigate(URL,Flags,TargetFrame,PostData,Headers)
Gui, Show,,CAE
return
Guiclose:
exitapp
