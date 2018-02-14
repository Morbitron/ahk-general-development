UrlDownloadToFile, https://gist.github.com/gimoya/5821469/raw/034b2766bbcbe70e2a8e93b72d1ec8723351a8f8/Veg%C3%96K-Abk%C3%BCrzungen, hotstrings.ahk
if(ErrorLevel || !FileExist("hotstrings.ahk") ) {
    msgbox, Download failed!
    ExitApp
}
Run, hotstrings.ahk