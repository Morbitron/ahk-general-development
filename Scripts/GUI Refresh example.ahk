#SingleInstance force
BGpic = L752307914.jpg
Tilepic = gearscolor.png
Tilepic2 = gearsgreyscale.png

;-------get images-----------
IfNotExist, L752307914.jpg
UrlDownloadToFile http://img.freecodesource.com/formspring-backgrounds/images/bg/L752307914.jpg, L752307914.jpg
IfNotExist, gearscolor.png
UrlDownloadToFile http://img2.imageshack.us/img2/8574/gearscolor.png, gearscolor.png
IfNotExist, gearsgreyscale.png
UrlDownloadToFile http://img2.imageshack.us/img2/6049/gearsgrayscale.png, gearsgreyscale.png

;-------gui frame------------
Gui, Add, Picture, vPic0 w280 h300 x1 y1, %BGpic%

Gui, Add, Picture, BackgroundTrans vPic2 w160 h160 x60 y100, %TilePic2%
Gui, Add, Picture, BackgroundTrans vPic1 w160 h160 x60 y100, %TilePic%

Gui, Add, Button, x10 y10 w80 vCycling gCycling, Cycle Tile
Gui, Show, w280 h300,

; settimer, mouse_loc, 100 ; <------ enable change on mouse movement
return

;------test button----------
Cycling:  ; updating one over another, eg as in a picture for each droplist choice
Loop 10
   {
sleep 1000
GuiControl,show,Pic1
sleep 1000
GuiControl,hide,Pic1
   }
return

;-------------bye-------------------
Esc::ExitApp
GuiClose:
ExitApp

;-------- change the picture based on mouse movement -------

mouse_loc:
mousegetpos, x

tooltip
;tooltip %x% %prevx%
if prevx=%x%
return

y++
if y&1 ; odd or even
GuiControl,show,Pic1
else
GuiControl,hide,Pic1

prevx=%x%

return

f12::reload	; <---- easier to make changes and test