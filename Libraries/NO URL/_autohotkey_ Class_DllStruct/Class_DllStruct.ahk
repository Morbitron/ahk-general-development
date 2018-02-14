; ======================================================================================================================
; AHK_L 1.1 +
; ======================================================================================================================
; Function:         Class definitions for windows structures used with DllCall
; AHK version:      1.1.05.06 (U 32) / (U64)
; Language:         English
; Tested on:        Win XPSP3, Win VistaSP2 (x86) / Win 7 (x64)
; Version:          0.0.01.09/2011-12-09/just me
; Remarks:          To create a structure create a new instance of the class using
;                      MyStruct := New DllStruct(StructStr)
;
;                   The parameter "StructStr" describes the fields of the structure as follows:
;                   "TYPE name[n];"
;                        TYPE            : Datatype, for valid types see AHKTypes and WINTypes below
;                        name (optional) : Name to access the field with the methods described below. If name is not 
;                                          specified, you have to access the field by it's 1-based index, otherwise
;                                          TYPE and name must be seperated with at least one space.
;                                          If name is preceded with a "*" the TYPE will be changed to "UPTR".
;                        [n]  (optional) : Number of occurrences, if [n] is not specified it defaults to 1.
;                                          To access a certain occurrence with Get/SetData methods you have to pass
;                                          the 1-based index within the parameter Index. String types (CHAR [n], 
;                                          TCHAR [n], WCHAR [n]) are always accessed as strings.
;                                          To supply names for occurences append a colon (:) to the counter (n)
;                                          followed by the names seperated by commas (,) and the closing bracket,
;                                          e.g. "[4: Left, Top, Right, Bottom]". To access an occurence by name just
;                                          pass the name instead of the numeric index.
;                        ;               : Each field description must be closed with a semicolon
;
;                   Alignment and padding:
;                   By default, each structure member is aligned to start at an address which is a multiple of its
;                   length. In addition the structure is padded to set the size to be a multiple of its longest
;                   member when needed. This can be changed by specifing "Align n;" within "StructStr" where n may
;                   be 0, 1, 2, 4, or 8. It changes alignment for all subsequent structure members be a multiple of n
;                   or their size, whatever is smaller. "Align 0;" restores the default alignment.
;                   Since inluding of embedded structures by name is not supported, the script doesn't notice the start
;                   or end of these structures. But sometimes the structure's size has to be aligned, especially
;                   in 64-bit environments. To avoid displacements you should enclose the structure decleration in
;                   braces followed by a semicolon, e.g. "{; HWND hwndFrom; UINT_PTR idFrom; UINT code; };" (NMHDR).
; 
;                   The following public methods provide access to the structure's memory/fields (see below): 
;                   Init           Sets structure's memory to binary NULL
;                   GetData        Gets the current value of a field
;                   SetData        Sets the value of a field
;                   GetCount       Returns the number of occurrences of a field defined as TYPE [nn]
;                   GetPtr         Returns a pointer to the structure or one of the fields
;                   GetSize        Returns the size of the structure or one of the fields in bytes
;
;                   It's also possible to access fields using the object syntax "Class.Property". To access
;                   a subitem of a field with multiple occurences (e.g. "LONG [4];") you must use the array syntax
;                   Class.Property[4] or Class.Property["Name"]. 
;                   The notation "Class.Property.4" is not supported and will yield a blank result.
;
;                   Fields with multiple occurrences may be accessed as a whole if no subitem index is passed. To 
;                   set the values you have to pass an appropriate array containing all values, reading access returns
;                   an array containing them.   
;
;                   Names of "private" properties/methods are prefixed with underscores, they must not be
;                   set/called by the script!
;                   
;                   You can find the description of windows data types at 
;                   http://msdn.microsoft.com/en-us/library/aa383751%28VS.85%29.aspx
; ======================================================================================================================
; This software is provided 'as-is', without any express or implied warranty.
; In no event will the authors be held liable for any damages arising from the use of this software.
; ======================================================================================================================
;=======================================================================================================================
Class DllStruct {
   ; ===================================================================================================================
   ; Base Class Definition
   ; ===================================================================================================================
   Class _Base {
      ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; Meta-Functions +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; ================================================================================================================
      ; CONSTRUCTOR __New - you must not instantiate instances
      ; ================================================================================================================
      __New(P*) {
         Return False
      }
      ; ================================================================================================================
      ; __Get      Get pseudo properties 
      ; ================================================================================================================
      __Get(Name, Index = 0) {
         Return This.GetData(Name, Index)
      }
      ; ================================================================================================================
      ; __Set      Set pseudo properties
      ; ================================================================================================================
      __Set(Name, Params*) {
         If !IsObject(Params) || (Params.MaxIndex() > 2)
            Return ""
         If (Params.MaxIndex() = 1) {
            Index := 0
            Value := Params[1]
         } Else {
            Index := Params[1]
            Value := Params[2]
         }
         Return This.SetData(Name, Value, Index)
      }
      ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; Private Methods ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; ================================================================================================================
      ; PRIVATE METHOD _IsInt()
      ; ================================================================================================================
      _IsInt(Value) {
         If Value Is Not Integer
            Return False
         Return True
      }
      ; ================================================================================================================
      ; PRIVATE METHOD _IsIn()
      ; ================================================================================================================
      _IsIn(Value, MatchList) {
         If Value Not In %MatchList%
            Return False
         Return True
      }
      ; ================================================================================================================
      ; PRIVATE METHOD _StructHasField()
      ; ================================================================================================================
      _StructHasField(ByRef Name) {
         StringUpper, Name, Name
         If !(This._IsInt(Name)) {
            If !This._StructObj.HasKey(Name) {
               This.Error := True
               Return False
            }
            Name := This._StructObj[Name]
         }
         If !This._StructArr.HasKey(Name) {
            This.Error := True
            Return False
         }
         Return True
      }
      ; ================================================================================================================
      ; PRIVATE METHOD _FieldHasIndex()
      ; ================================================================================================================
      _FieldHasIndex(ByRef Index, Field) {
         If !(This._IsInt(Index)) {
            If Field.Names.HasKey(Index) {
               Index := Field.Names[Index]
               Return True
            } Else {
               This.Error := True
               Return False
            }
         }
         If (Index < 0) || (Index > Field.Cnt) {
            This.Error := True
            Return False
         }
         Return True
      }
      ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; PUBLIC Interface +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ; ================================================================================================================
      ; METHOD Init           Sets structure's memory to NULL
      ; Return values:        On success  - True
      ;                       On failure  - False, This.Error is set
      ; ================================================================================================================
      Init() {
         This.Error := False
         If !(This._Ptr) || !(This._Alloc) {
            This.Error := True
            Return False
         }
         DllCall("Kernel32.dll\RtlZeroMemory", "Ptr", This._Ptr, "Ptr", This._Size)
         If (ErrorLevel) {
            This.Error := True
            Return False
         }
         Return True
      }
      ; ================================================================================================================
      ; METHOD GetData        Get current value of structure field
      ; Parameters:           Name        - Name or index of the field
      ;                       Index       - Optional: 1-based index of subitem (Name[nn])
      ; Return values:        On success  - Field value
      ;                       On failure  - False, This.Error is set
      ; Remarks:              To access a certain field "Name" must contain the 1-based field index or the name defined
      ;                       in the structure description string.
      ; ================================================================================================================
      GetData(Name, Index = 0) {
         This.Error := False
         If !This._StructHasField(Name) {
            This.Error := True
            Return False
         }
         Field := This._StructArr[Name]
         If !This._FieldHasIndex(Index, Field) {
            This.Error := True
            Return False
         }
         If (Index = 0) && (Field.Cnt > 1) {
            Value := []
            Loop, % Field.Cnt
               Value.Insert(NumGet(This._Ptr + 0, Field.Pos + ((A_Index - 1) * Field.Len), Field.Type))
            Return Value
         }
         If (Index > 0)
            Index--
         If (Field.Type = "ASTR") || (Field.Type = "WSTR") {
            CP := (Field.Type = "WSTR" ? "UTF-16" : "CP0")
            Len := (Field.Type = "WSTR" ? Field.Len // 2 : Field.Len)
            Value := StrGet(This._Ptr + Field.Pos, Len, CP)
         } Else {
            Value := NumGet(This._Ptr + 0, Field.Pos + (Index * Field.Len), Field.Type)
         }
         Return Value
      }
      ; ================================================================================================================
      ; METHOD SetData        Set value of a structure field
      ; Parameters:           Name        - Name or index of the field
      ;                       Value       - New value 
      ;                       Index       - Optional: 1-based index of subitem (Name[nn])
      ; Return values:        On success  - True
      ;                       On failure  - False, This.Error is set
      ; Remarks:              To access a certain field "Name" must contain the 1-based field index or the name defined
      ;                       in the structure description string.
      ; ================================================================================================================
      SetData(Name, Value, Index = 0) {
         This.Error := False
         If !This._StructHasField(Name) {
            This.Error := True
            Return False
         }
         Field := This._StructArr[Name]
         If !This._FieldHasIndex(Index, Field) {
            This.Error := True
            Return False
         }
         If (Index = 0) && IsObject(Value) && (Value.MaxIndex() = Field.Cnt) {
            For I, V In Value
               NumPut(V, This._Ptr + 0, Field.Pos + ((I - 1) * Field.Len), Field.Type)
            Return True
         }
         If (Index > 0)
            Index--
         If (Field.Type = "ASTR") || (Field.Type = "WSTR") {
            CP := (Field.Type = "WSTR" ? "UTF-16" : "CP0")
            Len := (Field.Type = "WSTR" ? Field.Len // 2 : Field.Len)
            StrPut(Value, This._Ptr + Field.Pos, Len, CP)
         } Else {
            NumPut(Value, This._Ptr + 0, Field.Pos + (Index * Field.Len), Field.Type)
         }
         Return True
      }
      ; ================================================================================================================
      ; METHOD GetCount       Returns the number of occurrences of a field defined as TYPE [nn]
      ; Parameters:           Name        - Name or index of the field
      ; Return values:        On success  - Integer value > 0
      ;                       On failure  - False, This.Error is set
      ; Remarks:              To access a certain field "Name" must contain the 1-based field index or the name defined
      ;                       in the structure description string.
      ; ================================================================================================================
      GetCount(Name) {
         This.Error := False
         If !(This._Ptr) {
            This.Error := True
            Return False
         }
         If !This._StructHasField(Name) {
            This.Error := True
            Return False
         }
         Field := This._StructArr[Name]
         Return (Field.Cnt)
      }
      ; ================================================================================================================
      ; METHOD GetPtr         Returns a pointer to the structure or one of the fields
      ; Parameters:           Name        - Optional: Name or index of the field
      ; Return values:        On success  - Address of the structure or the field passed in Name
      ;                       On failure  - False, This.Error is set
      ; Remarks:              To access a certain field "Name" must contain the 1-based field index or the name defined
      ;                       in the structure description string.
      ; ================================================================================================================
      GetPtr(Name = "") {
         This.Error := False
         If !(This._Ptr) {
            This.Error := True
            Return False
         }
         If (Name = "")
            Return This._Ptr
         If !This._StructHasField(Name) {
            This.Error := True
            Return False
         }
         Field := This._StructArr[Name]
         Return (This._Ptr + Field.Pos)
      }
      ; ================================================================================================================
      ; METHOD GetSize        Returns the size of the structure or one of the fields in bytes
      ; Parameters:           Name        - Optional: Name or index of the field
      ; Return values:        On success  - Size in bytes of the structure or the field passed in Name
      ;                       On failure  - False, This.Error is set
      ; Remarks:              To access a certain field "Name" must contain the 1-based field index or the name defined
      ;                       in the structure description string.
      ; ================================================================================================================
      GetSize(Name = "") {
         This.Error := False
         If !(This._Size) {
            This.Error := True
            Return False
         }
         If (Name = "")
            Return This._Size
         If !This._StructHasField(Name) {
            This.Error := True
            Return False
         }
         Field := This._StructArr[Name]
         Return (Field.Len * Field.Cnt)
      }
   }
   ; ===================================================================================================================
   ; Helper Class for Windows Types
   ; ===================================================================================================================
   Class _WINTypes {
      Static ATOM := "USHORT"
      Static BOOL := "INT"
           , BOOLEAN := "UCHAR"
           , BYTE := "UCHAR"
      Static COLORREF := "UINT"
      Static DWORD32 := "UINT"
           , DWORD64 := "UINT64"
           , DWORD := "UINT"
           , DWORD_PTR := "UPTR"
           , DWORDLONG := "UINT64"
      Static HACCEL := "UPTR"
           , HALF_PTR := (A_PtrSize = 8 ? "INT" : "SHORT")
           , HANDLE := "UPTR"
           , HBITMAP := "UPTR"
           , HBRUSH := "UPTR"
           , HCOLORSPACE := "UPTR"
           , HCONV := "UPTR"
           , HCONVLIST := "UPTR"
           , HCURSOR := "UPTR"
           , HDC := "UPTR"
           , HDDEDATA := "UPTR"
           , HDESK := "UPTR"
           , HDROP := "UPTR"
           , HDWP := "UPTR"
           , HENHMETAFILE := "UPTR"
           , HFILE := "INT"
           , HFONT := "UPTR"
           , HGDIOBJ := "UPTR"
           , HGLOBAL := "UPTR"
           , HHOOK := "UPTR"
           , HICON := "UPTR"
           , HINSTANCE := "UPTR"
           , HKEY := "UPTR"
           , HKL := "UPTR"
           , HLOCAL := "UPTR"
           , HMENU := "UPTR"
           , HMETAFILE := "UPTR"
           , HMODULE := "UPTR"
           , HMONITOR := "UPTR"
           , HPALETTE := "UPTR"
           , HPEN := "UPTR"
           , HRESULT := "INT"
           , HRGN := "UPTR"
           , HRSRC := "UPTR"
           , HSZ := "UPTR"
           , HWINSTA := "UPTR"
           , HWND := "UPTR"
      Static INT32 := "INT"
           , INT_PTR := "PTR"
      Static LANGID := "USHORT"
           , LCID := "UINT"
           , LCTYPE := "UINT"
           , LGRPID := "UINT"
           , LONG32 := "INT"
           , LONG64 := "INT64"
           , LONG := "INT"
           , LONG_PTR := "PTR"
           , LONGLONG := "INT64"
           , LPARAM := "PTR"
           , LPBOOL := "UPTR"
           , LPBYTE := "UPTR"
           , LPCOLORREF := "UPTR"
           , LPCSTR := "UPTR"
           , LPCTSTR := "UPTR"
           , LPCVOID := "UPTR"
           , LPCWSTR := "UPTR"
           , LPDWORD := "UPTR"
           , LPHANDLE := "UPTR"
           , LPINT := "UPTR"
           , LPLONG := "UPTR"
           , LPSTR := "UPTR"
           , LPTSTR := "UPTR"
           , LPVOID := "UPTR"
           , LPWORD := "UPTR"
           , LPWSTR := "UPTR"
           , LRESULT := "PTR"
      Static PBOOL := "PTR"
           , PBOOLEAN := "PTR"
           , PBYTE := "PTR"
           , PCHAR := "PTR"
           , PCSTR := "PTR"
           , PCTSTR := "PTR"
           , PCWSTR := "PTR"
           , PDWORD32 := "PTR"
           , PDWORD64 := "PTR"
           , PDWORD := "PTR"
           , PDWORD_PTR := "PTR"
           , PDWORDLONG := "PTR"
           , PFLOAT := "PTR"
           , PHALF_PTR := "PTR"
           , PHANDLE := "UPTR"
           , PHKEY := "UPTR"
           , PINT32 := "UPTR"
           , PINT64 := "UPTR"
           , PINT := "UPTR"
           , PINT_PTR := "UPTR"
           , PLCID := "UPTR"
           , PLONG32 := "UPTR"
           , PLONG64 := "UPTR"
           , PLONG := "UPTR"
           , PLONG_PTR := "UPTR"
           , PLONGLONG := "UPTR"
           , POINTER_32 := "UINT"
           , POINTER_64 := "PTR"
           , POINTER_SIGNED := "PTR"
           , POINTER_UNSIGNED := "UPTR"
           , PSHORT := "UPTR"
           , PSIZE_T := "UPTR"
           , PSSIZE_T := "UPTR"
           , PSTR := "UPTR"
           , PTBYTE := "UPTR"
           , PTCHAR := "UPTR"
           , PTSTR := "UPTR"
           , PUCHAR := "UPTR"
           , PUHALF_PTR := "UPTR"
           , PUINT32 := "UPTR"
           , PUINT64 := "UPTR"
           , PUINT := "UPTR"
           , PUINT_PTR := "UPTR"
           , PULONG32 := "UPTR"
           , PULONG64 := "UPTR"
           , PULONG := "UPTR"
           , PULONG_PTR := "UPTR"
           , PULONGLONG := "UPTR"
           , PUSHORT := "UPTR"
           , PVOID := "UPTR"
           , PWCHAR := "UPTR"
           , PWORD := "UPTR"
           , PWSTR := "UPTR"
      Static SC_HANDLE := "UPTR"
           , SC_LOCK := "UPTR"
           , SERVICE_STATUS_HANDLE := "UPTR"
           , SIZE_T := "UPTR"
           , SSIZE_T := "PTR"
      Static TBYTE := (A_ISUNICODE ? "USHORT" : "UCHAR")
           , TCHAR := (A_ISUNICODE ? "USHORT" : "UCHAR")
      Static UHALF_PTR := (A_PtrSize = 8 ? "UINT" : "USHORT")
           , UINT32 := "UINT"
           , UINT_PTR := "UPTR"
           , ULONG32 := "UINT"
           , ULONG64 := "UINT64"
           , ULONG := "UINT"
           , ULONG_PTR := "UPTR"
           , ULONGLONG := "UINT64"
           , USN := "INT64"
      Static VOID := "PTR"
      Static WCHAR := "USHORT"
           , WORD := "USHORT"
           , WPARAM := "UPTR"
   }
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; CLASS Properties and Methods ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; ===================================================================================================================
   ; CONSTRUCTOR __New
   ; Parameters:        StructStr   - String describing the structure fields
   ;                    Pointer     - Optional: Pointer to the structure as returned from SendMessage or API-Calls
   ; Return values:     On success  - new object
   ;                    On failure  - False, ErrorLevel contains additional informations
   ; ===================================================================================================================
   __New(StructStr, Pointer = "") {
      Static AHKTypes := {CHAR: 1, SHORT: 2, INT: 4, INT64: 8, PTR: A_PtrSize
                        , UCHAR: 1, USHORT: 2, UINT: 4, UINT64: 8, UPTR: A_PtrSize}
      Static StructsP := {RECT: "{;LONG [4: Left, Top, Right, Bottom];};"
                        , POINT: "{;LONG [2: X, Y];};"
                        , POINTS: "{;SHORT [2: X, Y];};"}
      ; Create class variables -----------------------------------------------------------------------------------------
      This._DllStruct := ""   ; Structure variable                               (Binary)
      This._StructArr := []   ; Array of structure fields                        (Object)
      This._StructObj := {}   ; Object for field names                           (Object)
      This._Alloc := False    ; Did the class allocate memory?                   (BOOL)
      This._Ptr := 0          ; Structure pointer                                (Pointer)
      This._Size := 0         ; Structure size                                   (Integer)
      This.Error := False     ; Set to True in case of errors                    (BOOL)
      ; ----------------------------------------------------------------------------------------------------------------
      Align := FieldIndex := MaxLen := MaxStructLen := Pad := Ptr := Size := StructAlign := 0
      InStruct := False
      StructStr := RegExReplace(StructStr, "[\r\n]")
      StructStr := RTrim(StructStr, ";")
      Loop, Parse, StructStr, `;
      {
         If !(A_LoopField) {
            ErrorLevel := "Improper structure declaration!"
            Return False
         }
         StringUpper, Part, A_LoopField
         Part := RegExReplace(Trim(Part), "\s+", " ")
         Rep := ""
         If RegExMatch(Part, "\[(?P<ep>[^\]]+)\]$", R) {
            Rep := RegExReplace(Rep, "\s+")
            Part := RegExReplace(Part, "\s*\[.*$")
         }
         StringSplit, Parts, Part, %A_Space%
         If (Parts0 > 2) {
            ErrorLevel := "Improper field declaration: " . Part . "!"
            Return False
         }
         ; Check for alignment presetting
         If (Parts1 = "Align") {
            If (Parts0 = 2) && (StrLen(Parts2) = 1) && InStr("01248", Parts2) {
               If (InStruct) {
                  StructAlign := Parts2
               } Else {
                  Align := Parts2
               }
               Continue
            }
            ErrorLevel := "Invalid alignment value""" . Parts2 . """!"
            Return False
         }
         ; Check for explicit padding
         If (Parts1 = "Pad") {
            If (Parts0 = 2) && (StrLen(Parts2) = 1) && InStr("012345678", Parts2) {
               Size += Parts2
               Continue
            }
            ErrorLevel := "Invalid padding value""" . Parts2 . """!"
            Return False
         }
         ; Check for embedded structures
         If (Parts1 = "{") {  ; start of structure
            If (InStruct) {
               ErrorLevel := "Improper use of ""{""!"
               Return False
            }
            ; Set / initialize structure related variables
            InStruct := True
            MaxStructLen := 0
            StructAlign := Align
            Continue
         }
         If (Parts1 = "}") {  ; end of structure
            If !(InStruct) || (MaxStructLen = 0) {
               ErrorLevel := "Improper use of ""}""!"
               Return False
            }
            ; Align structure's size if required and reset structure related variables
            StructAlign := (StructAlign) && (StructAlign < MaxStructLen) ? StructAlign : MaxStructLen
            If (Pad := Mod(Size, StructAlign))
               Size += StructAlign - Pad
            MaxStructLen := 0
            InStruct := False
            StructAlign := 0
            Continue
         }
         ; 
         Cnt  := 1
         If (Rep) && !RegExMatch(Rep, "^\d+", Cnt) {
            ErrorLevel := "Improper repetition factor """ . Rep . """!"
            Return False
         }
         If (Parts0 = 2) {
            If (SubStr(Parts2, 1, 1) = "*") {
               Parts1 := "UPTR"
               Parts2 := RegExReplace(Parts2, "^\*+")
            }
         }
         Type := Parts1
         If This._WINTypes.HasKey(Parts1)
            Type := This._WINTypes[Parts1]
         If !AHKTypes.HasKey(Type) {
            ErrorLevel := "Invalid data type """ . Parts1 . """!"
            Return False
         }
         Len := AHKTypes[Type]
         If (Len > MaxLen)
            MaxLen := Len
         If (Len > MaxStructLen)
            MaxStructLen := Len
         If (Pad := Mod(Size, ((Align) && (Align < Len))? Align : Len))
            Size += Len - Pad
         Pos := Size
         If (Cnt > 1) {
            If (Parts1 = "WCHAR")
               Type := "WSTR"
            Else If (Parts1 = "CHAR")
               Type := "ASTR"
            Else If (Parts1 = "TCHAR")
               Type := (A_IsUnicode ? "WSTR" : "ASTR")
         }
         If (Type = "ASTR") || (Type = "WSTR") {
            Len := Cnt * (Type = "WSTR" ? 2 : 1)
            Rep := ""
            Cnt := 1
         }
         Names := {}
         If InStr(Rep, ":") {
            StringReplace, Rep, Rep, %Cnt%:
            StringSplit, Name, Rep, `,
            If (Name0 = Cnt) {
               Loop, %Name0%
                  Names[Name%A_Index%] := A_Index
            }
         }
         FieldIndex++
         This._StructArr[FieldIndex] := {"Type": Type, "Pos": Pos, "Len": Len, "Cnt": Cnt, "Names": Names}
         Size += (Len * Cnt)
         If (Parts0 = 2)
            This._StructObj[Parts2] := FieldIndex
      }
      Align := (Align) && (Align < MaxLen) ? Align : MaxLen
      If (Pad := Mod(Size, Align))
         Size += Align - Pad
      If (Pointer <> "") {
         This._Ptr := Pointer
         This._Size := Size
      } Else {
         If (This.SetCapacity("_DllStruct", Size) <> Size)
            Return False
         This._Size := Size
         Ptr := This.GetAddress("_DllStruct")
         If !(Ptr)
            Return False
         This._Ptr := Ptr
         This._Alloc := True
      }
      This.Base := This._Base
      If This._Alloc
         This.Init()
   }
}