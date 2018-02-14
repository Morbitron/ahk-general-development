#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.




bckDir = X:\[BACKUP OF FILES]\Installations






















exitApp



;1		Good
;2		Maybe
;3		Delete
;4		Softcore
;5		Funny
;6		Dirt
;Other	Quit



FileCreateDir, %A_ScriptDir%\to_delete
FileCreateDir, %A_ScriptDir%\to_reconsider
FileCreateDir, %A_ScriptDir%\processed
FileCreateDir, %A_ScriptDir%\processed\animation
FileCreateDir, %A_ScriptDir%\processed\dirt
FileCreateDir, %A_ScriptDir%\processed\softcore
FileCreateDir, %A_ScriptDir%\processed\funny
FileCreateDir, %A_ScriptDir%\processed\other
FileCreateDir, %A_ScriptDir%\processed\picture
FileCreateDir, %A_ScriptDir%\processed\gif
FileCreateDir, %A_ScriptDir%\processed\video


curPath = I:
;curPath = M:\Server\[MASTER P]\Incoming
;curPath = C:\Incoming

;FileSelectFolder, curPath, Y:\[MASTER P],, Please select the folder you want to clean.



fileTargetDir := ""



Loop, Files, %curPath%\*, R
{
	SplitPath, A_LoopFileFullPath,fileName,fileDir, fileExt
	
	if !(RegExMatch(fileExt, "jpg|jpeg|png|bmp|gif|avi|wmw|webm|mp4|mkv|mpg|mpeg|mov|flv|swf")) {
		fileTargetDir = %A_ScriptDir%\processed\other
		runwait, ROBOCOPY "%fileDir%" "%fileTargetDir%" "%fileName%" "/MOVE", , Hide UseErrorLevel
		
	}else{
		Run, "%A_LoopFileFullPath%",,, curWindow
		Input, keyPressed, L1 M
		WinKill, A
		sleep 500

		if (keyPressed = 1) {
			if (RegExMatch(fileExt, "jpg|jpeg|png|bmp")) {
				fileTargetDir = %A_ScriptDir%\processed\picture
				
			} else if (RegExMatch(fileExt, "gif")) {
				fileTargetDir = %A_ScriptDir%\processed\gif
				
			} else if (RegExMatch(fileExt, "avi|wmw|webm|mp4|mkv|mpg|mpeg|mov|flv")) {
				fileTargetDir = %A_ScriptDir%\processed\video
				
			} else if (RegExMatch(fileExt, "swf")) {
				fileTargetDir = %A_ScriptDir%\processed\animation
			}

		} else if (keyPressed = 2) {
			fileTargetDir = %A_ScriptDir%\to_reconsider
		} else if (keyPressed = 3) {
			fileTargetDir = %A_ScriptDir%\to_delete
		} else if (keyPressed = 4) {
			fileTargetDir = %A_ScriptDir%\processed\softcore
		} else if (keyPressed = 5) {
			fileTargetDir = %A_ScriptDir%\processed\funny
		} else if (keyPressed = 6) {
			fileTargetDir = %A_ScriptDir%\processed\dirt
		} else if (keyPressed = "m") {
			Run, %fileDir%
			Run, %A_ScriptDir%\processed\
			break
		} else {
			;MsgBox, "Quitting"
			;sleep 2000
			break
		}
		runwait, ROBOCOPY "%fileDir%" "%fileTargetDir%" "%fileName%" "/MOVE", , Hide UseErrorLevel
	}
}

;MsgBox, "You finished processing your stuff!"
sleep 800
exitApp