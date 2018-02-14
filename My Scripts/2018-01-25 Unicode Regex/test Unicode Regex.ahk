#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

pop := "aäb cde fgh ijk lmn oöp qrsß tuü vwx yz AÄBC DEF GHI JKL MNO ÖPQ RST UÜV WXYZ !§ $%& /() =?*Ω '<> #|; ²³~ @`´ ©«» ¼× {} aäb"
MsgBox, % RegExMatch(pop, "\x{03A9}", lol)
MsgBox, % lol


