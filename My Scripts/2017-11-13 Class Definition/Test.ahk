#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



Class Test
{
	testVar := "This show Var decleration."
	
	__New()
	{
		MsgBox Initializing
	}
	
	Say(msg)
	{
		MsgBox % msg
	}

	__Delete()
	{
		MsgBox Closing
	
	}
}


Test.Say("tttttttttttttt")
tst := New Test


;Test for extend normal Class
; Define a custom class inheriting standard properties from _Object.
class SubObject extends _Object {
    
	Lol(){
		MsgBox YOOOOOOOO
	}
	
}

leArray := Array("le1","sdadas","PPOP","TO")

