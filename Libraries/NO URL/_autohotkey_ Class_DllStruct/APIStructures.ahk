; ======================================================================================================================

; AHK_L 1.1 +

; ======================================================================================================================

; GDI Bitmap Structures ================================================================================================

; ======================================================================================================================

; BITMAP ---------------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/dd183371%28VS.85%29.aspx

struct_BITMAP := "

(

{;

LONG bmType;

LONG bmWidth;

LONG bmHeight;

LONG bmWidthBytes;

WORD bmPlanes;

WORD bmBitsPixel;

LPVOID bmBits;

};

)"



; BITMAPFILEHEADER -----------------------------------------------------------------------------------------------------

struct_BITMAPFILEHEADER := "

(

{;

WORD bfType;

DWORD bfSize;

WORD bfReserved1;

WORD bfReserved2;

DWORD bfOffBits;

};

)"



; BITMAPINFOHEADER -----------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/dd183376%28VS.85%29.aspx

struct_BITMAPINFOHEADER := "

(

{;

DWORD biSize;

LONG biWidth;

LONG biHeight;

WORD biPlanes;

WORD biBitCount;

DWORD biCompression;

DWORD biSizeImage;

LONG biXPelsPerMeter;

LONG biYPelsPerMeter;

DWORD biClrUsed;

DWORD biClrImportant;

};

)"



; BITMAPINFO -----------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/dd183375%28VS.85%29.aspx

; RGBQUAD bmiColors[1] -> DWORD bmiColors[1]

struct_BITMAPINFO := struct_BITMAPINFOHEADER . "DWORD bmiColors[1];"



; BLENDFUNCTION --------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/dd183393%28VS.85%29.aspx

struct_BLENDFUNCTION := "

(

{;

BYTE BlendOp;

BYTE BlendFlags;

BYTE SourceConstantAlpha;

BYTE AlphaFormat;

};

)"



; RGBQUAD --------------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/dd162938%28VS.85%29.aspx

struct_RGBQUAD := "

(

{;

BYTE rgbBlue;

BYTE rgbGreen;

BYTE rgbRed;

BYTE rgbReserved;

};

)"



; SIZE -----------------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/dd145106%28VS.85%29.aspx

struct_SIZE := "

(

{;

LONG cx;

LONG cy;

};

)"



; ======================================================================================================================

; GDI Font and Text Structures =========================================================================================

; ======================================================================================================================

; LOGFONT --------------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/dd145037%28VS.85%29.aspx

struct_LOGFONT := "

(

{;

LONG lfHeight;

LONG lfWidth;

LONG lfEscapement;

LONG lfOrientation;

LONG lfWeight;

BYTE lfItalic;

BYTE lfUnderline;

BYTE lfStrikeOut;

BYTE lfCharSet;

BYTE lfOutPrecision;

BYTE lfClipPrecision;

BYTE lfQuality;

BYTE lfPitchAndFamily;

TCHAR lfFaceName[32];

};

)"



; ======================================================================================================================

; GDI Rectangle Structures =============================================================================================

; ======================================================================================================================

; RECT -----------------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/dd162897%28VS.85%29.aspx

struct_RECT := "

(

{;

LONG left;

LONG top;

LONG right;

LONG bottom;

};

)"



; POINT ----------------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/dd162805%28VS.85%29.aspx

struct_POINT := "

(

{;

LONG x;

LONG y;

};

)"



; POINTS ---------------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/dd162808%28VS.85%29.aspx

struct_POINTS := "

(

{;

SHORT x;

SHORT y;

};

)"



; ======================================================================================================================

; System Information Structures ========================================================================================

; ======================================================================================================================

; OSVERSION ------------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/ms724834%28VS.85%29.aspx

struct_OSVERSIONINFO := "

(

{;

DWORD dwOSVersionInfoSize;

DWORD dwMajorVersion;

DWORD dwMinorVersion;

DWORD dwBuildNumber;

DWORD dwPlatformId;

TCHAR szCSDVersion[128];

};

)"



; OSVERSIONEX ----------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/ms724833%28VS.85%29.aspx

struct_OSVERSIONINFOEX := "

(

{;

DWORD dwOSVersionInfoSize;

DWORD dwMajorVersion;

DWORD dwMinorVersion;

DWORD dwBuildNumber;

DWORD dwPlatformId;

TCHAR szCSDVersion[128];

WORD wServicePackMajor;

WORD wServicePackMinor;

WORD wSuiteMask;

BYTE wProductType;

BYTE wReserved;

};

)"



; ======================================================================================================================

; Time Structures ======================================================================================================

; ======================================================================================================================

; FILETIME -------------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/ms724284%28VS.85%29.aspx

struct_FILETIME := "

(

{;

DWORD dwLowDateTime;

DWORD dwHighDateTime;

};

)"



; SYSTEMTIME -----------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/ms724950%28VS.85%29.aspx

struct_SYSTEMTIME := "

(

{;

WORD wYear;

WORD wMonth;

WORD wDayOfWeek;

WORD wDay;

WORD wHour;

WORD wMinute;

WORD wSecond;

WORD wMilliseconds;

};

)"



; TIME_ZONE_INFORMATION ------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/ms725481%28VS.85%29.aspx

; StandardDate and DaylightDate are of type SYSTEMTIME -> WORD[8]

struct_TIMEZONEINFORMATION := "

(

{;

LONG Bias;

WCHAR StandardName[32];

WORD StandardDate[8];

LONG StandardBias;

WCHAR DaylightName[32];

WORD DaylightDate[8];

LONG DaylightBias;

};

)"



; ======================================================================================================================

; Window Structures ====================================================================================================

; ======================================================================================================================

; WINDOWINFO -----------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/ms632610%28VS.85%29.aspx

; RECT rcWindow, rcClient -> LONG[4], ATOM atomWindowType -> WORD

struct_WINDOWINFO := "

(

{;

DWORD cbSize;

LONG rcWindow[4];

LONG rcClient[4];

DWORD dwStyle;

DWORD dwExStyle;

DWORD dwWindowStatus;

UINT cxWindowBorders;

UINT cyWindowBorders;

WORD atomWindowType;

WORD wCreatorVersion;

};

)"



; WINDOWPLACEMENT ------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/ms632611%28VS.85%29.aspx

; POINT ptMinPosition, ptMaxPosition -> LONG[2], RECT rcNormalPosition -> LONG[4]

struct_WINDOWPLACEMENT := "

(

{;

UINT length;

UINT flags;

UINT showCmd;

LONG ptMinPosition[2];

LONG ptMaxPosition[2];

LONG rcNormalPosition[4];

};

)"



; WINDOWPOS ------------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/ms632612%28VS.85%29.aspx

struct_WINDOWPOS := "

(

{;

HWND hwnd;

HWND hwndInsertAfter;

INT x;

INT y;

INT cx;

INT cy;

UINT flags;

};

)"



; ======================================================================================================================

; Notification Structures ==============================================================================================

; ======================================================================================================================

; NMHDR ----------------------------------------------------------------------------------------------------------------

; http://msdn.microsoft.com/en-us/library/windows/desktop/bb775514%28v=vs.85%29.aspx

struct_NMHDR := "

(

{;

HWND hwndFrom;

UINT_PTR idFrom;

UINT code;

};

)"