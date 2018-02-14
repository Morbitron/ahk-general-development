#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include <Gdip>




file=%a_scriptdir%\test.png
run,calc.exe ;just for example
WinGet, hwnd,ID,A  ;get handle of active window 

pToken:=Gdip_Startup()
pBitmap:=Gdip_BitmapFromHWND(hwnd)
pBitmap_part:=Gdip_CloneBitmapArea(pBitmap, 0, 0, 100,100) ;get toppart of active window
Gdip_SaveBitmapToFile(pBitmap_part, file)

Gdip_DisposeImage(pBitmap)
Gdip_DisposeImage(pBitmap_part)
Gdip_Shutdown(pToken)




file=%A_ScriptDir%\test_raster.png

pToken:=Gdip_Startup()

raster:=0x40000000 + 0x00CC0020
pBitmap:=Gdip_BitmapFromScreen(0,raster)

Gdip_SaveBitmapToFile(pBitmap, file)
Gdip_Shutdown(pToken)