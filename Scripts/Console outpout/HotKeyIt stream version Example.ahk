MsgBox % StdOutStream( "ping www.autohotkey.com", "StdOutStream_Callback" ) 
MsgBox % StdOutStream( "ipconfig /All" )

StdOutStream_Callback( data, n ) {
  Static D
  ToolTip % D .= data

  if ! ( n ) {
    Tooltip % D := ""
    Return "Callback says: Hi!"
  }
}