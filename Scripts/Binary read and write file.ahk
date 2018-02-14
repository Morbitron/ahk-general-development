#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;set variables
filepath := a_scriptdir
filename = test.png ;;;;;;;;;;
file:= filepath "\" filename

;get a "test.png" file
if not fileexist(filename)
    urldownloadtofile,http://ahkscript.org/static/ahk_logo.png,%file% ;;;

;Binary read the contents of the file
oFile := FileOpen(file, "r")
oFile.RawRead(data, oFile.Length()) ; Use the function-retrieved length of the file read (oFile.Length()) instead of a random "big" number for consistency.


;Binary write the contents of the file to a new file
filedelete,%filepath%\copy_of_%filename%
oFile2 := FileOpen("copy_of_" . filename, "w") ; Instead of writing straight to the file using FileAppend, create a new file calling FileOpen again.
oFile2.RawWrite(data, oFile.Length()) ; And than use RawWrite() to write up to the length of the input data.
return