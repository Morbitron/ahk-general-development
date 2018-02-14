
id=_CNehPJrZzY
fx=https://simissues.cae.com/system/mCommand.asp?cmd=issue_details&issueid=11432200082
;fx=https://www.google.com/
;fx:="https://autohotkey.com/boards/"

;xxa=Shell.Explorer                  ;- IExplorer
xxa=Mozilla.Browser                  ;- firefox
Gui Add, ActiveX, w980 h640 vWB,%xxa%
WB.Silent := True
WB.Navigate(fx)
Gui, Show,,DANMARK
return
Guiclose:
exitapp
