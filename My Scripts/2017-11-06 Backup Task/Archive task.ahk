#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



#Include, XA.ahk
#Include, Debug.ahk

workRoot = F:
workLinkDir = F:\DESKTOP\work

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
	
	; "":"", 
	file_data := Array()
	; {"FolderName":"", "DateCreated":"", "DateModified":"", "IsArchived":"", "Title":"","WorkFolder":"", "Plane":"", "Jira":Array(), "Simissues":Array(), "":"", "":"", "":""}

	file_data["FolderName"] := "LE Folder Name"
	file_data["DateCreated"] := "2017/03/11"
	file_data["DateModified"] := "2017/03/11"
	file_data["IsArchived"] := False
	file_data["Title"] := "This task title"
	file_data["WorkFolder"] := "WORK RAVE"
	file_data["Plane"] := Array("C130J", "OTSP")
	file_data["Jira"] := Array()
	file_data["Jira"]["URL"] := "https://jira.caecorp.cae.com/browse/CISTFX-5685"
	file_data["Jira"]["ID"] := "CISTFX-5685"
	file_data["Jira"]["Title"] := "C130J RAAF - VCC Viewer 2"
	file_data["Jira"]["Status"] := "IN Progress"
	file_data["Jira"]["CreatedDate"] := ""
	file_data["Jira"]["RBD"] := ""
	file_data["Jira"]["Description"] := "BLA BLA BLA"
	

	;file_data["Jira"].Push({"URL":"https://jira.caecorp.cae.com/browse/CISTFX-5685", "ID":"CISTFX-5685", "Title":"C130J RAAF - VCC Viewer 2", "Status":"IN Progress", "CreatedDate":"", "RBD":"", "Description":"BLA BLA BLA"})
	;file_data["Simissues"].Push({"URL":"https://simissues.cae.com/system/mCommand.asp?cmd=issue_details&issueid=11432200082", "ID":"11432200082", "Severity":"C", "Status":"Reopened", "CreatedDate":"", "RBD":"", "Description":"BLA BLA BLA"})


	XA_Save(file_data, "task.xml")

	;MsgBox % D_TraceObj(file_data)


}




	/*
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
		MsgBox % projectPath
	}
	*/



	/*
	RunWait,  "C:\Program Files\7-Zip\7z.exe" a "%workRoot%\%product%\[Archive]\%OutNameNoExt%.7z" "%workRoot%\%projectPath%\%OutNameNoExt%\*"
	FileRemoveDir, %workRoot%\%product%\%projectPath%\%OutNameNoExt%, 1
	FileDelete, %LongPath%
	*/