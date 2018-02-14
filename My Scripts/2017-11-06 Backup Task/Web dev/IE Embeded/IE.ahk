﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Add_IE_Control(hwnd,x=0,y=0,w=500,h=500,value="http://www.google.de/")
{
AtlAxWinInit()
CoInitialize()
pwb:=IE_Add( hwnd, x, y, w, h)
IE_LoadURL(pwb,value)
Release(pwb)
Return,pwb
}
/*
CoHelper.ahk
*/

VTable(ppv, idx)
{
   Return DecodeInteger(DecodeInteger(ppv) + idx * 4)
}

DecodeInteger(ptr)
{
   Return *ptr | *++ptr << 8 | *++ptr << 16 | *++ptr << 24
}

EncodeInteger(ref, val)
{
   DllCall("ntdll\RtlFillMemoryUlong", "Uint", ref, "Uint", 4, "Uint", val)
}

Ansi2Unicode(ByRef sString, ByRef wString, nLen = 0)
{
   If !nLen
      nLen := DllCall("MultiByteToWideChar"
      , "Uint", 0
      , "Uint", 0
      , "Uint", &sString
      , "int",  -1
      , "Uint", 0
      , "int",  0)

   VarSetCapacity(wString, nLen * 2)

   DllCall("MultiByteToWideChar"
      , "Uint", 0
      , "Uint", 0
      , "Uint", &sString
      , "int",  -1
      , "Uint", &wString
      , "int",  nLen)
}

Unicode2Ansi(ByRef wString, ByRef sString, nLen = 0)
{
   pString := wString + 0 > 65535 ? wString : &wString

   If !nLen
      nLen := DllCall("WideCharToMultiByte"
      , "Uint", 0
      , "Uint", 0
      , "Uint", pString
      , "int",  -1
      , "Uint", 0
      , "int",  0
      , "Uint", 0
      , "Uint", 0)

   VarSetCapacity(sString, nLen)

   DllCall("WideCharToMultiByte"
      , "Uint", 0
      , "Uint", 0
      , "Uint", pString
      , "int",  -1
      , "str",  sString
      , "int",  nLen
      , "Uint", 0
      , "Uint", 0)
}

CLSID4ProgID(Byref CLSID, sProgID)
{
   VarSetCapacity(CLSID, 16)
   Ansi2Unicode(sProgID, wProgID)
   DllCall("ole32\CLSIDFromProgID", "str", wProgID, "str", CLSID)
}

GUID4String(Byref CLSID, sString)
{
   VarSetCapacity(CLSID, 16, 0)
   Ansi2Unicode(sString, wString, 39)
   DllCall("ole32\CLSIDFromString", "str", wString, "str", CLSID)
}

String4GUID(Byref CLSID)
{
   VarSetCapacity(wString, 39 * 2)
   DllCall("ole32\StringFromGUID2", "str", CLSID, "str", wString, "int", 39)
   Unicode2Ansi(wString, sString, 39)
   Return sString
}

CreateObject(ByRef CLSID, ByRef IID, CLSCTX = 5)
{
   If ( StrLen(CLSID) = 38 )
   GUID4String(CLSID, CLSID)
   If ( StrLen(  IID) = 38 )
   GUID4String(  IID,   IID)
   DllCall("ole32\CoCreateInstance", "str", CLSID, "Uint", 0, "Uint", CLSCTX, "str", IID, "UintP", ppv)
   Return ppv
}

GetObject(Namespace)
{
   Ansi2Unicode(Namespace, wNamespace)
   GUID4String(IID_IDispatch, "{00020400-0000-0000-C000-000000000046}")
   DllCall("ole32\CoGetObject", "str", wNamespace, "Uint", 0, "str", IID_IDispatch, "UintP", pdisp)
   Return pdisp
}

GetActiveObject(ProgID)
{
   CLSID4ProgID(CLSID, ProgID)
   DllCall("oleaut32\GetActiveObject", "str", CLSID, "Uint", 0, "UintP", punk)
   Return punk
}

SysAllocString(sString)
{
   Ansi2Unicode(sString, wString)
   Return DllCall("oleaut32\SysAllocString", "str", wString)
}

SysFreeString(pString)
{
   Return DllCall("oleaut32\SysFreeString", "Uint", pString)
}

OleInitialize()
{
   DllCall("ole32\OleInitialize", "Uint", 0)
}

OleUninitialize()
{
   DllCall("ole32\OleUninitialize")
}

CoInitialize()
{
   DllCall("ole32\CoInitialize", "Uint", 0)
}

CoUninitialize()
{
   DllCall("ole32\CoUninitialize")
}

QueryInterface(ppv, ByRef IID)
{
   If ( StrLen(IID) = 38 )
   GUID4String(IID,   IID)
   DllCall(DecodeInteger(DecodeInteger(ppv)), "Uint", ppv, "str", IID, "UintP", ppv)
   Return ppv
}

AddRef(ppv)
{
   Return DllCall(DecodeInteger(DecodeInteger(ppv) + 4), "Uint", ppv)
}

Release(ppv)
{
   Return DllCall(DecodeInteger(DecodeInteger(ppv) + 8), "Uint", ppv)
}

QueryService(ppv, ByRef SID, ByRef IID)
{
   If ( StrLen(SID) = 38 )
   GUID4String(SID,   SID)
   If ( StrLen(IID) = 38 )
   GUID4String(IID,   IID)
   GUID4String(IID_IServiceProvider, "{6D5140C1-7436-11CE-8034-00AA006009FA}")
   DllCall(DecodeInteger(DecodeInteger(ppv)), "Uint", ppv, "str", IID_IServiceProvider, "UintP", psp)
   DllCall(DecodeInteger(DecodeInteger(psp) + 12), "Uint", psp, "str", SID, "str", IID, "UintP", ppv)
   DllCall(DecodeInteger(DecodeInteger(psp) +  8), "Uint", psp)
   Return ppv
}

/*
IEControl.ahk
*/

/* Supported Functions
IE_Add(hWnd, x, y, w, h)
IE_Move(pwb, x, y, w, h)
IE_LoadURL(pwb, u)
IE_LoadHTML(pwb, h)
IE_GoBack(pwb)
IE_GoForward(pwb)
IE_GoHome(pwb)
IE_GoSearch(pwb)
IE_Refresh(pwb)
IE_Stop(pwb)
IE_Document(pwb)
IE_GetTitle(pwb)
IE_GetUrl(pwb)
IE_Busy(pwb)
IE_Quit(pwb)            ; iexplore.exe only
IE_hWnd(pwb)            ; iexplore.exe only
IE_FullName(pwb)         ; iexplore.exe only
IE_GetStatusText(pwb)         ; iexplore.exe only
IE_SetStatusText(pwb, sText = "")   ; iexplore.exe only
IE_ReadyState(pwb)
IE_Open(pwb)
IE_New(pwb)
IE_Save(pwb)
IE_SaveAs(pwb)
IE_Print(pwb)
IE_PrintPreview(pwb)
IE_PageSetup(pwb)
IE_Properties(pwb)
IE_Cut(pwb)
IE_Copy(pwb)
IE_Paste(pwb)
IE_SelectAll(pwb)
IE_Find(pwb)
IE_DoFontSize(pwb, s)
IE_InternetOptions(pwb)
IE_ViewSource(pwb)
IE_AddToFavorites(pwb)
IE_MakeDesktopShortcut(pwb)
IE_SendEMail(pwb)
CGID_MSHTML(pwb, nCmd, nOpt = 0)
GetHostWindow(pwb)
GetWebControl()
UrlHistoryEnum()
UrlHistoryClear()
AtlAxWinInit()
AtlAxWinTerm()
AtlAxGetControl(hWnd)
AtlAxAttachControl(pwb, hWnd)
AtlAxCreateContainer(hWnd, x, y, w, h, sName = "")
*/

IE_Add(hWnd, x, y, w, h)
{
   AtlAxWinInit()
   Return AtlAxGetControl( AtlAxCreateContainer(hWnd, x, y, w, h, "Shell.Explorer") )
}

IE_Move(pwb, x, y, w, h)
{
   WinMove, % "ahk_id " . GetHostWindow(pwb), , x, y, w, h
}

IE_LoadURL(pwb, u)
{
   pUrl := SysAllocString(u)
   VarSetCapacity(var, 8 * 2, 0)
   DllCall(VTable(pwb, 11), "Uint", pwb, "Uint", pUrl, "Uint", &var, "Uint", &var, "Uint", &var, "Uint", &var)
   SysFreeString(pUrl)
}

IE_LoadHTML(pwb, h)
{
   pUrl := SysAllocString("about:" . h)
   VarSetCapacity(var, 8 * 2, 0)
   DllCall(VTable(pwb, 11), "Uint", pwb, "Uint", pUrl, "Uint", &var, "Uint", &var, "Uint", &var, "Uint", &var)
   SysFreeString(pUrl)
}

IE_GoBack(pwb)
{
   DllCall(VTable(pwb, 7), "Uint", pwb)
}

IE_GoForward(pwb)
{
   DllCall(VTable(pwb, 8), "Uint", pwb)
}

IE_GoHome(pwb)
{
   DllCall(VTable(pwb, 9), "Uint", pwb)
}

IE_GoSearch(pwb)
{
   DllCall(VTable(pwb, 10), "Uint", pwb)
}

IE_Refresh(pwb)
{
   DllCall(VTable(pwb, 12), "Uint", pwb)
}

IE_Stop(pwb)
{
   DllCall(VTable(pwb, 14), "Uint", pwb)
}

IE_Document(pwb)
{
   DllCall(VTable(pwb, 18), "Uint", pwb, "UintP", pdoc)
   Return pdoc
}

IE_GetTitle(pwb)
{
   DllCall(VTable(pwb, 29), "Uint", pwb, "UintP", pTitle)
   Unicode2Ansi(pTitle, sTitle)
   SysFreeString(pTitle)
   Return sTitle
}

IE_GetUrl(pwb)
{
   DllCall(VTable(pwb, 30), "Uint", pwb, "UintP", pUrl)
   Unicode2Ansi(pUrl, sUrl)
   SysFreeString(pUrl)
   Return sUrl
}

IE_Busy(pwb)
{
   DllCall(VTable(pwb, 31), "Uint", pwb, "shortP", bBusy)
   Return -bBusy
}

IE_Quit(pwb)            ; iexplore.exe only
{
   DllCall(VTable(pwb, 32), "Uint", pwb)
}

IE_hWnd(pwb)            ; iexplore.exe only
{
   DllCall(VTable(pwb, 37), "Uint", pwb, "UintP", hIE)
   Return hIE
}

IE_FullName(pwb)         ; iexplore.exe only
{
   DllCall(VTable(pwb, 38), "Uint", pwb, "UintP", pFile)
   Unicode2Ansi(pFile, sFile)
   SysFreeString(pFile)
   Return sFile
}

IE_GetStatusText(pwb)         ; iexplore.exe only
{
   DllCall(VTable(pwb, 44), "Uint", pwb, "UintP", pText)
   Unicode2Ansi(pText, sText)
   SysFreeString(pText)
   Return sText
}

IE_SetStatusText(pwb, sText = "")   ; iexplore.exe only
{
   pText := SysAllocString(sText)
   DllCall(VTable(pwb, 45), "Uint", pwb, "Uint", pText)
   SysFreeString(pText)
}

IE_ReadyState(pwb)
{
/*
   READYSTATE_UNINITIALIZED = 0      ; Default initialization state.
   READYSTATE_LOADING       = 1      ; Object is currently loading its properties.
   READYSTATE_LOADED        = 2      ; Object has been initialized.
   READYSTATE_INTERACTIVE   = 3      ; Object is interactive, but not all of its data is available.
   READYSTATE_COMPLETE      = 4      ; Object has received all of its data.
*/
   DllCall(VTable(pwb, 56), "Uint", pwb, "intP", nReady)
   Return nReady
}

IE_Open(pwb)
{
   DllCall(VTable(pwb, 54), "Uint", pwb, "Uint", 1, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_New(pwb)
{
   DllCall(VTable(pwb, 54), "Uint", pwb, "Uint", 2, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Save(pwb)
{
   DllCall(VTable(pwb, 54), "Uint", pwb, "Uint", 3, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_SaveAs(pwb)
{
   DllCall(VTable(pwb, 54), "Uint", pwb, "Uint", 4, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Print(pwb)
{
   DllCall(VTable(pwb, 54), "Uint", pwb, "Uint", 6, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_PrintPreview(pwb)
{
   DllCall(VTable(pwb, 54), "Uint", pwb, "Uint", 7, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_PageSetup(pwb)
{
   DllCall(VTable(pwb, 54), "Uint", pwb, "Uint", 8, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Properties(pwb)
{
   DllCall(VTable(pwb, 54), "Uint", pwb, "Uint", 10, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Cut(pwb)
{
   DllCall(VTable(pwb, 54), "Uint", pwb, "Uint", 11, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Copy(pwb)
{
   DllCall(VTable(pwb, 54), "Uint", pwb, "Uint", 12, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Paste(pwb)
{
   DllCall(VTable(pwb, 54), "Uint", pwb, "Uint", 13, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_SelectAll(pwb)
{
   DllCall(VTable(pwb, 54), "Uint", pwb, "Uint", 17, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_Find(pwb)
{
   DllCall(VTable(pwb, 54), "Uint", pwb, "Uint", 32, "Uint", 0, "Uint", 0, "Uint", 0)
}

IE_DoFontSize(pwb, s)
{
/*
   s = 4   ; Largest
   s = 3   ; Larger
   s = 2   ; Medium
   s = 1   ; Smaller
   s = 0   ; Smallest
*/
   VarSetCapacity(var, 8 * 2)
   EncodeInteger(&var + 0, 3)
   EncodeInteger(&var + 8, s)
   DllCall(VTable(pwb, 54), "Uint", pwb, "Uint", 19, "Uint", 2, "Uint", &var, "Uint", &var)
}

IE_InternetOptions(pwb)
{
   CGID_MSHTML(pwb, 2135)
}

IE_ViewSource(pwb)
{
   CGID_MSHTML(pwb, 2139)
}

IE_AddToFavorites(pwb)
{
   CGID_MSHTML(pwb, 2261)
}

IE_MakeDesktopShortcut(pwb)
{
   CGID_MSHTML(pwb, 2266)
}

IE_SendEMail(pwb)
{
   CGID_MSHTML(pwb, 2288)
}

CGID_MSHTML(pwb, nCmd, nOpt = 0)
{
   GUID4String(CGID_MSHTML          , "{DE4BA900-59CA-11CF-9592-444553540000}")
   GUID4String(IID_IOleCommandTarget, "{B722BCCB-4E68-101B-A2BC-00AA00404770}")
   pct := QueryInterface(pwb, IID_IOleCommandTarget)
   DllCall(VTable(pct, 4), "Uint", pct, "str", CGID_MSHTML, "Uint", nCmd, "Uint", nOpt, "Uint", 0, "Uint", 0)
   Release(pct)
}

GetHostWindow(pwb)
{
   GUID4String(IID_IOleWindow, "{00000114-0000-0000-C000-000000000046}")
   DllCall(VTable(pwb, 0), "Uint", pwb, "str", IID_IOleWindow, "UintP", pow)
   DllCall(VTable(pow, 3), "Uint", pow, "UintP", hWnd)
   DllCall(VTable(pow, 2), "Uint", pow)
   Return DllCall("GetParent", "Uint", hWnd)
}

GetWebControl()
{
;   ControlGet, hIESvr, hWnd, , Internet Explorer_Server1, A
   MouseGetPos,,,, hIESvr, 2

   GUID4String(IID_IHTMLDocument2, "{332C4425-26CB-11D0-B483-00C04FD90119}")
   GUID4String(IID_IWebBrowser2  , "{D30C1661-CDAF-11D0-8A3E-00C04FC9E26E}")
   GUID4String(SID_SWebBrowserApp, "{0002DF05-0000-0000-C000-000000000046}")
   DllCall("SendMessageTimeout", "Uint", hIESvr
      , "Uint", DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
      , "int", 0, "int", 0, "Uint", 2, "Uint", 1000, "UintP", lResult)
   DllCall("oleacc\ObjectFromLresult", "Uint", lResult, "str", IID_IHTMLDocument2, "int", 0, "UintP", phd)
   pwb := QueryService(phd, SID_SWebBrowserApp, IID_IWebBrowser2)
   Release(phd)
   Return  pwb
}

UrlHistoryEnum()
{
   GUID4String( CLSID_CUrlHistory, "{3C374A40-BAE4-11CF-BF7D-00AA006946EE}")
   GUID4String(IID_IUrlHistoryStg, "{3C374A41-BAE4-11CF-BF7D-00AA006946EE}")
   puh := CreateObject(CLSID_CUrlHistory, IID_IUrlHistoryStg)
   DllCall(VTable(puh, 7), "Uint", puh, "UintP", peu)
   VarSetCapacity(var, 40)
   EncodeInteger(&var, VarSetCapacity(var))
   
   Loop
   {
      If DllCall(VTable(peu, 3), "Uint", peu, "Uint", 1, "Uint", &var, "Uint", 0)
         Break
      pUrl   := DecodeInteger(&var + 4)
      pTitle := DecodeInteger(&var + 8)
      Unicode2Ansi(pUrl  , sUrl  )
      Unicode2Ansi(pTitle, sTitle)
      sHistory .= sUrl . "|" . sTitle . "`n"
      SysFreeString(pUrl  )
      SysFreeString(pTitle)
   }

   DllCall(VTable(peu, 2), "Uint", peu)
   DllCall(VTable(puh, 2), "Uint", puh)
   Return sHistory
}

UrlHistoryClear()
{
   GUID4String( CLSID_CUrlHistory, "{3C374A40-BAE4-11CF-BF7D-00AA006946EE}")
   GUID4String(IID_IUrlHistoryStg, "{3C374A41-BAE4-11CF-BF7D-00AA006946EE}")
   puh := CreateObject(CLSID_CUrlHistory, IID_IUrlHistoryStg)
   DllCall(VTable(puh, 9), "Uint", puh)
   DllCall(VTable(puh, 2), "Uint", puh)
}

AtlAxWinInit()
{
   If !DllCall("GetModuleHandle", "str", "atl")
       DllCall("LoadLibrary"    , "str", "atl")
   Return DllCall("atl\AtlAxWinInit")
}

AtlAxWinTerm()
{
   If hModule := DllCall("GetModuleHandle", "str", "atl")
      DllCall("FreeLibrary", "Uint", hModule)
}

AtlAxGetControl(hWnd)
{
   DllCall("atl\AtlAxGetControl", "Uint", hWnd, "UintP", punk)
   pdsp := QueryInterface(punk, IID_IDispatch := "{00020400-0000-0000-C000-000000000046}")
   Release(punk)
   Return  pdsp
}

AtlAxAttachControl(pdsp, hWnd)
{
   punk := QueryInterface(pdsp, IID_IUnknown := "{00000000-0000-0000-C000-000000000046}")
   DllCall("atl\AtlAxAttachControl", "Uint", punk, "Uint", hWnd, "Uint", 0)
   Release(punk)
}

AtlAxCreateContainer(hWnd, x, y, w, h, sName = "")
{
   pName := sName ? &sName : 0
   AtlAxWin := "AtlAxWin"
   Return DllCall("CreateWindowEx", "Uint", 0x200, "Uint", &AtlAxWin, "Uint", pName, "Uint",0x10000000|0x40000000|0x04000000, "int", x, "int", y, "int", w, "int", h, "Uint", hWnd, "Uint", 0, "Uint", 0, "Uint", 0)
}