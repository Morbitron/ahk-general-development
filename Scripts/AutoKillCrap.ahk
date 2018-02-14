#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


killApps() {
	Process, Close, NVIDIA Web Helper.exe
	Process, Close, NVIDIA Share.exe
	Process, Close, NVDisplay.Container.exe
	Process, Close, NVTelemetryContainer.exe
	Process, Close, nvsphelper64.exe
	Process, Close, nvscaps64.exe
	Process, Close, nvcontainer.exe
	Process, Close, OfficeClickToRun.exe
	Process, Close, HuaweiHiSuiteService64.exe
	Process, Close, amrsvc.exe
	Process, Close, acrotray.exe
	Process, Close, atiedxx.exe
	Process, Close, atiesrxx.exe
	
	Sleep, 10000
	killApps()
}




killApps()



