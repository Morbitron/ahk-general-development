#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



workRoot = F:


;A_YYYY A_MM A_DD



Loop %0%  ; For each parameter (or file dropped onto a script):
{
    GivenPath := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
    
	Loop %GivenPath%, 1
	{
        LongPath = %A_LoopFileLongPath%
	}
	
	SplitPath, LongPath, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	
	StringSplit, shortcutAr, OutNameNoExt, %A_Space%
	
	product = WORK %shortcutAr2%
	projectPath = ""
	
	Loop, %shortcutAr0%
	{
		if (a_index > 2 && a_index != shortcutAr0) {
			curValue := shortcutAr%a_index%
			;MsgBox, Color number %a_index% is %curValue%.
			if (a_index == 3) {
				projectPath = %curValue%
			} else {
				projectPath = %projectPath%\%curValue%
			}
		}
	}
	
	Run,  %workRoot%\%product%\%projectPath%\%OutNameNoExt%
	IfExist, %workRoot%\%product%\%projectPath%\Starteam.url
		Run,  %workRoot%\%product%\%projectPath%\Starteam.url
}




