#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;https://autohotkey.com/boards/viewtopic.php?t=1929

prodIndex:=1
RowY:=50
Options:=""
for index, val in RMAObj.ptsi_prefix {
	Options.=val . " / " . RMAObj["name"][val] . "|"
	if (index==1) {
		Options.="|"
	}
}
Gui, RMA: Destroy
Gui, RMA: +AlwaysOnTop
Gui, RMA: Add, Tab2, w280 h150, RMA|RMA Memo
Gui, RMA:Add, Text,, Select RMA Center
Gui, RMA:Add, DropDownList, vFacility w175, %Options%
Gui, RMA:Add, Text, , Select RMA Ship Type
Gui, RMA:Add, DropDownList, vSuperType w125, Repair (Mail In/Out)||Swap (Advance Ship)|Swap (Mail In/Out)
Gui, RMA:Add, Button, gRMAShowProdWin, Product Info List
Gui, RMA:Tab, 2
Gui, RMA:Add, Text, , Enter the RMA Memo Below (LIMIT: 500)
Gui, RMA:Add, Edit, vRMemo r6 w260 limit500
Gui, RMA:Tab
Gui, RMA:Show, xCenter yCenter, PTSI RMA - Information Required
Gui, RMA2: Destroy
Gui, RMA2: +AlwaysOnTop +ToolWindow
Gui, RMA2: Add, Button, yp+15 xp+5 gRMANew vRMAButtonAdd, Add
Gui, RMA2: Add, Text, xp+5 yp+30 vRMAList, Serial No.`t`tModel`t`t`tProblem
Gui, RMA2: Add, Edit, w100 vSer_1 limit25
Gui, RMA2: Add, Edit, w100 vMod_1 limit50 yp+0 xp+120
Gui, RMA2: Add, Edit, w100 vProb_1 limit150 yp+0 xp+120
return

RMAShowProdWin:
newHeight:=prodIndex*25+75
Gui, RMA2: Show, h%newHeight%, Product Information
return

GuiRMA2Close:
Gui, RMA2: Hide
return

GuiRMAClose:
; Need this to destroy BOTH gui windows...
Gui, RMA2: Destroy
;Gui, RMA: Destroy
return

RMANew:
if (prodIndex<25) {
	prodIndex++
	Gui, RMA2:Add, Edit, xp-240 yp+25 w100 vSer_%prodIndex% limit25, Product %prodIndex%
	Gui, RMA2:Add, Edit, w100 vMod_%prodIndex% limit50 yp+0 xp+120
	Gui, RMA2:Add, Edit, w100 vProb_%prodIndex% limit150 yp+0 xp+120
	newHeight:=prodIndex*25+75
	Gui, RMA2: Show, h%newHeight%, Product Information
	if (prodIndex==25) {
		GuiControl, Disable, RMAButtonAdd
	}
}
return



