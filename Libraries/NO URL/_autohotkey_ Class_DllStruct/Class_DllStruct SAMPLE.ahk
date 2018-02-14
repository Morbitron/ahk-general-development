; ======================================================================================================================

; AHK_L 1.1 +

; ======================================================================================================================

#NoEnv

#Include Class_DllStruct.ahk

#Include APIStructures.ahk

Title := "Structures"

Gui, +LastFound +OwnDialogs

Gui, Margin, 20, 20

Gui, Font, s10

Gui, Add, Text, xm+10, ListView properties:

Gui, Font, s10, Courier New

Gui, Add, ListView, xm y+5 w400 r20 vLV hwndHLV, Structure|Field|Value

Gui, Show, , %Title%



; ======================================================================================================================

; Create structure TIMEZONEINFORMATION for use in proximate DllCall

TZI := New DllStruct(struct_TIMEZONEINFORMATION)

DllCall("Kernel32\GetTimeZoneInformation", "Ptr", TZI.GetPtr())

; Create structure SYSTEMTIME pointing to the field "DaylightDate" of TZI (as one possibility)

SYSTIME := New DllStruct(struct_SYSTEMTIME, TZI.GetPtr("DaylightDate"))

; Get and display the field values using "GetData" method

MsgBox, 0, %Title%, % "DaylightName:`n"

. TZI.GetData("DaylightName")

. "`n`nDaylightDate:`n"

. "Year: " . SYSTIME.GetData("wYear") . "`n"

. "Month: " . SYSTIME.GetData("wMonth") . "`n"

. "DoW: " . SYSTIME.GetData("wDayOfWeek") . "`n"

. "Day: " . SYSTIME.GetData("wDay") . "`n"

. "Hour: " . SYSTIME.GetData("wHour")

; Free structures

SYSTIME := ""

TZI := ""

; ======================================================================================================================



; ======================================================================================================================

; Create structure RECT with one multiple field and set/get the field values using arrays

RECT := New DllStruct("LONG rcWindow[4 : Left, Top, Right, Bottom]")

RECT.rcWindow := [20, 20, 400, 600]

MsgBox, 0, %Title%, % "RECT.rcwindow[""Left""] is " . RECT.rcwindow["Left"]

Arr_Pos := RECT.rcWindow

MsgBox, 0, %Title%, % "Arr_Pos:`n"

. "1 (Left) = " . Arr_Pos[1] . "`n"

. "2 (Top) = " . Arr_Pos[2] . "`n"

. "3 (Right) = " . Arr_Pos[3] . "`n"

. "4 (Bottom) = " . Arr_Pos[4]

; Display RECT properties (keys)

Msg := "RECT Properties:`n`n"

For Key In RECT

Msg .= A_Index . ": Key = " . Key . "`n"

MsgBox, 0, %Title%, %Msg%

; Free structure

RECT := ""

; ======================================================================================================================



; ======================================================================================================================

; Show some of the ListView properties

; Get the font

SendMessage, WM_GETFONT := 0x31, 0, 0, , ahk_id %HLV%

HFONT := ErrorLevel

; Create structure LOGFONT

LOGFONT := New DllStruct(struct_LOGFONT)

; Assign HFONT properties into LOGFONT

DllCall("Gdi32\GetObject", "Ptr", HFONT, "INT", LOGFONT.GetSize(), "Ptr", LOGFONT.GetPtr())

; Get and output field "lfFaceName"

LV_Add("", "LOGFONT", "lfFaceName", LOGFONT.GetData("lfFaceName"))

; Get and output field 1 ("lfHeight")

LV_Add("", "LOGFONT", "lfHeight", LOGFONT.GetData(1))

; Create structure RECT

RECT := New DllStruct(struct_RECT)

; Get the rectangle of the ListView's window into RECT

DllCall("User32\GetWindowRect", "Ptr", HLV, "Ptr", RECT.GetPtr())

; Get and output field "left"

LV_Add("", "RECT", "left", RECT.left)

; Get and output field "top"

LV_Add("", "RECT", "top", RECT.top)

; Get and output field 3 ("right")

LV_Add("", "RECT", "3", RECT.3)

; Get and output field 4 ("bottom")

LV_Add("", "RECT", "4", RECT.4)

Loop, 3

LV_ModifyCol(A_Index, "AutoHdr")

Return

; Free structures

LOGFONT := ""

RECT := ""

; ======================================================================================================================



GuiClose:

GuiEscape:

Gui, Destroy

ExitApp