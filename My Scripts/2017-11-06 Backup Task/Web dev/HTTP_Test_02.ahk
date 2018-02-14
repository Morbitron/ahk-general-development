#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance
#NoEnv 
SendMode Input 
SetWorkingDir %A_ScriptDir% 

Gui, Add, Tab, x-4 y-0 w210 h270 -Wrap vTabs gTabs, Procedure|Ping|Calc.|Passwords|Varie

Gui, Tab, Procedure
Gui, Add, GroupBox, x6 y21 w190 h46 , TGU
Gui, Add, GroupBox, x6 y67 w190 h178 , Applicativi

Gui, Add, Edit, x16 y37 w170 h20 +BackgroundTrans +Number vTGU, TGU
TGU_TT:="Inserisci il circuito da esaminare"

Gui, Add, Button, x16 y87 w80 h30 , App1
Gui, Add, Button, x106 y87 w80 h30 , App2
Gui, Add, Button, x16 y127 w80 h30 , App3
Gui, Add, Button, x106 y127 w80 h30 , App4
Gui, Add, Button, x16 y167 w80 h30 , App5
Gui, Add, Button, x106 y167 w80 h30 , App6
Gui, Add, Button, x16 y207 w80 h30 , App7
Gui, Add, Button, x106 y207 w80 h30 , App8
	
Gui, Tab, Passwords
Gui, Add, GroupBox, x6 y21 w190 h66 , Sistema LDAP
Gui, Add, GroupBox, x6 y90 w190 h66 , Sistema IDM
Gui, Add, GroupBox, x6 y159 w190 h64 , CRM Siebel

Gui, Add, Text, x16 y37 w30 h20 , User:
Gui, Add, Text, x16 y57 w30 h20 , Psw:
Gui, Add, Text, x16 y107 w30 h20 , User:
Gui, Add, Text, x16 y127 w30 h20 , Psw:
Gui, Add, Text, x16 y177 w30 h20 , User:
Gui, Add, Text, x16 y197 w30 h20 , Psw:

Gui, Add, Edit, x46 y37 w140 h20 vUserLDAP, User
FileRead, ContenutoUserLDAP, C:\UserLDAP.txt
GuiControl,, UserLDAP, %ContenutoUserLDAP%

Gui, Add, Edit, x46 y57 w140 h20 +Password vPasswordLDAP, Password
FileRead, ContenutoPasswordLDAP, C:\PasswordLDAP.txt
GuiControl,, PasswordLDAP, %ContenutoPasswordLDAP%

Gui, Add, Edit, x46 y107 w140 h20 vUserIDM, User
FileRead, ContenutoUserIDM, C:\UserIDM.txt
GuiControl,, UserIDM, %ContenutoUserIDM%

Gui, Add, Edit, x46 y127 w140 h20 +Password vPasswordIDM, Password
FileRead, ContenutoPasswordIDM, C:\PasswordIDM.txt
GuiControl,, PasswordIDM, %ContenutoPasswordIDM%

Gui, Add, Edit, x46 y177 w140 h20 vUserCRM, User
FileRead, ContenutoUserCRM, C:\UserCRM.txt
GuiControl,, UserCRM, %ContenutoUserCRM%

Gui, Add, Edit, x46 y197 w140 h20 +Password vPasswordCRM, Password
FileRead, ContenutoPasswordCRM, C:\PasswordCRM.txt
GuiControl,, PasswordCRM, %ContenutoPasswordCRM%
User_TT:="Inserisci il tuo User Name"
Passsword:="Inserisci la tua Password"

Gui, Add, Button, x16 y225 w70 h20 , Salva
Salva_TT:="Salva le User e le Password inserite"
Gui, Add, Button, x116 y225 w70 h20 , Annulla
Annulla_TT:="Annulla le modifiche apportate `n(se non è stato premuto il pulsante Salva)"

Gui, 2:Add, Text, Center, Sviluppato da Developer.`n`nPer informazioni manda una e-mail a:`n
Gui, 2:Add, Text, cBlue gLink1 vURL_Link1, email@isp.net`n

Gui, Tab, Ping

Gui, Add, StatusBar, gInformazioni
SB_SetParts(125)

Gui, +AlwaysOnTop -MaximizeBox -MinimizeBox
Gui, Show, x132 y95 h270 w202, ProcLauncher
SB_SetText("About", 1)
SB_SetText("Pronto", 2)
About_TT:="Nella parte destra viene visualizzato il nome dell'ultima applicazione aperta.`nClicca per Informazioni sull'autore."

OnMessage(0x200, "WM_MOUSEMOVE")
return

WM_MOUSEMOVE()
{
    static CurrControl, PrevControl, _TT  
    CurrControl := A_GuiControl
    If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
    {
        ToolTip
        SetTimer, DisplayToolTip, 1000
        PrevControl := CurrControl
    }
    return

    DisplayToolTip:
    SetTimer, DisplayToolTip, Off
    ToolTip % %CurrControl%_TT 
    SetTimer, RemoveToolTip, 3000
    return

    RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
    return
}

~LButton::
  if (A_PriorHotkey == A_ThisHotkey AND A_TimeSincePriorHotkey < 350) 
  {
    CoordMode, Mouse, Window 
    MouseGetPos, ClickX, ClickY, WindowUnderMouseID
    WinGetPos, x, y, w, h, ahk_id %WindowUnderMouseID% 

    if ( ClickX < w  and ClickY < 24 and ClickY > 0 and ClickX > 0 )
    {   
     WinActivate, ahk_id %WindowUnderMouseID% 
     WinMinimize, A
    }
  }
Return

ButtonApp1:
GuiControlGet, TGU
SB_SetText("App1", 2)
MsgBox %Tabs%
Return

ButtonApp2:
GuiControlGet, TGU
SB_SetText("App2", 2)
Return

ButtonApp3:
GuiControlGet, TGU
SB_SetText("App3", 2)
Return

ButtonCPC:
GuiControlGet, TGU
SB_SetText("App4", 2)
Return

ButtonWebLido:
GuiControlGet, TGU
SB_SetText("App5", 2)
Return

ButtonLTR:
GuiControlGet, TGU
SB_SetText("App6", 2)
Return

ButtonPOP:
GuiControlGet, TGU
SB_SetText("App7", 2)
Return

ButtonSamurai:
GuiControlGet, TGU
SB_SetText("App8", 2)
Return

ButtonSalva:
GuiControlGet, UserLDAP
FileDelete, C:\UserLDAP.txt
FileAppend, %UserLDAP%, C:\UserLDAP.txt
GuiControlGet, PasswordLDAP
FileDelete, C:\PasswordLDAP.txt
FileAppend, %PasswordLDAP%, C:\PasswordLDAP.txt
GuiControlGet, UserIDM
FileDelete, C:\UserIDM.txt
FileAppend, %UserIDM%, C:\UserIDM.txt
GuiControlGet, PasswordIDM
FileDelete, C:\PasswordIDM.txt
FileAppend, %PasswordIDM%, C:\PasswordIDM.txt
GuiControlGet, UserCRM
FileDelete, C:\UserCRM.txt
FileAppend, %UserCRM%, C:\UserCRM.txt
GuiControlGet, PasswordCRM
FileDelete, C:\PasswordCRM.txt
FileAppend, %PasswordCRM%, C:\PasswordCRM.txt
Return

ButtonAnnulla:
FileRead, ContenutoUserLDAP, C:\UserLDAP.txt
GuiControl,, UserLDAP, %ContenutoUserLDAP%
FileRead, ContenutoPasswordLDAP, C:\PasswordLDAP.txt
GuiControl,, PasswordLDAP, %ContenutoPasswordLDAP%
FileRead, ContenutoUserIDM, C:\UserIDM.txt
GuiControl,, UserIDM, %ContenutoUserIDM%
FileRead, ContenutoPasswordIDM, C:\PasswordIDM.txt
GuiControl,, PasswordIDM, %ContenutoPasswordIDM%
FileRead, ContenutoUserCRM, C:\UserCRM.txt
GuiControl,, UserCRM, %ContenutoUserCRM%
FileRead, ContenutoPasswordCRM, C:\PasswordCRM.txt
GuiControl,, PasswordCRM, %ContenutoPasswordCRM%
Return

Informazioni: 
  Gui, 2:+AlwaysOnTop -MaximizeBox -MinimizeBox
  Gui, 2:Show,, A proposito...  
 
  Process, Exist
  pid_this := ErrorLevel
  WinGet, hw_gui, ID, ahk_class AutoHotkeyGUI ahk_pid %pid_this%  
  WM_SETCURSOR = 0x20
  OnMessage(WM_SETCURSOR, "HandleMessage")
  WM_MOUSEMOVE = 0x200
  OnMessage(WM_MOUSEMOVE, "HandleMessage")
 Return
 
Link1:
   Run, mailto:mail@isp.net?Subject=ProcLauncher
   Gui, 2:Destroy
return

Tabs:
;Gui, Submit, NoHide
;Gui, +OwnDialogs
;If Tabs=Ping
Return
  
GuiClose:
Gui, Destroy
ExitApp


;######## Functions ############################################################
HandleMessage(p_w, p_l, p_m, p_hw)
  {
    global   WM_SETCURSOR, WM_MOUSEMOVE,
    static   URL_hover, h_cursor_hand, h_old_cursor, CtrlIsURL, LastCtrl
   
    If (p_m = WM_SETCURSOR)
      {
        If URL_hover
          Return, true
      }
    Else If (p_m = WM_MOUSEMOVE)
      {
        StringLeft, CtrlIsURL, A_GuiControl, 3
        If (CtrlIsURL = "URL")
          {
            If URL_hover=
              {
                Gui, Font, cBlue underline
                GuiControl, Font, %A_GuiControl%
                LastCtrl = %A_GuiControl%
               
                h_cursor_hand := DllCall("LoadCursor", "uint", 0, "uint", 32649)
               
                URL_hover := true
              }                 
              h_old_cursor := DllCall("SetCursor", "uint", h_cursor_hand)
          }
        Else
          {
            If URL_hover
              {
                Gui, Font, norm cBlue
                GuiControl, Font, %LastCtrl%
               
                DllCall("SetCursor", "uint", h_old_cursor)
               
                URL_hover=
              }
          }
      }
  }
;######## End Of Functions #####################################################