
id=_CNehPJrZzY
fx=https://youtube.googleapis.com/v/%id%?playlist=%id%&autoplay=1&loop=1
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
