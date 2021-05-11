
;-- variables
Global ScreenX.w, ScreenY.w, NewPainting.a, ScreenResized.a

Global CanvasX.w, CanvasY.w, OldCanvasX.w, OldCanvasY.w, CanvasW.w, CanvasH.w, CanvasHasChanged.a 
; canvasX, canvasY : position of the canvas (and the layers, grid...)
; OldCanvasX, OldCanvasY : old position of canvas, need for zoom and pan.
; CanvasHasChanged : if we have paint or do a modification on canvas (if optionsie\usecanvas =1)
; NewPainting : needed to know if we have paint again, after moving the canvas for example.

; position nof the container-screen
ScreenX = 175
ScreenY = 40


Global MouseX_Old.d, MouseY_Old.d, x, y, mx, my, LayerId.a 
; mx, my : position of mouse in the canvas-screen

Global blend1,blend2 ; temporary // temporaire
; Global xx,yy,StartX1,StartY1

;{ for tablet (wacom or other)
Global WTInfo.WTInfo_
Global WTOpen.WTOpen_
Global WTPacket.WTPacket_
Global WTClose.WTClose_
Global WTQueueSizeSet.WTQueueSizeSet_
Global pkY_old, pkX_old, pkNormalPressure_old
Global NewList Pakets.PACKET()
;}

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 7
; Folding = -
; EnableXP
; EnableUnicode