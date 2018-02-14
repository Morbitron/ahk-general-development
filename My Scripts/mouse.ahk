#NoEnv
SendMode Input
#SingleInstance

;tested on Windows 7
;note: may not work correctly if aero mode is on

LButton::
CoordMode, Mouse, Screen
MouseGetPos, vPosX, vPosY, hWnd

WinGetClass, vWinClass, ahk_id %hWnd%

vDoMove := 0
if vWinClass not in BaseBar,#32768,Shell_TrayWnd,WorkerW,Progman,DV2ControlHost
{
SendMessage, 0x84, 0, vPosX|(vPosY<<16), , ahk_id %hWnd% ;WM_NCHITTEST
vNCHITTEST := ErrorLevel
;ToolTip %vNCHITTEST%
if (vNCHITTEST = 2) ;HTCAPTION := 2
vDoMove := 1
}

SendInput {LButton Down}
KeyWait, LButton
SendInput {LButton Up}

if vDoMove
{
MouseGetPos, vPosX, vPosY
vPosW := A_ScreenWidth/2
vPosH := A_ScreenHeight/2

vGridX := (vPosX < A_ScreenWidth/2) ? 0 : 1
vGridY := (vPosY < A_ScreenHeight/2) ? 0 : 1

;if window is beyond edges of screen, do move
WinGetPos, vPosX2, vPosY2, vPosW2, vPosH2, ahk_id %hWnd%

;ToolTip % vPosX2 " " vPosY2 " " (vPosX2+vPosW2) " " (vPosY2+vPosH2)
if (vPosX2 < 0) OR (vPosY2 < 0) OR (vPosX2+vPosW2 > A_ScreenWidth) OR (vPosY2+vPosH2 > A_ScreenHeight)
WinMove, ahk_id %hWnd%, , % vGridX*vPosW, % vGridY*vPosH, % vPosW, % vPosH
}
Return