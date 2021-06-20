
; procedure animation v6 - 06/2015 - pb 5.30LTS


;{ util

;sprite
Procedure FreeSprite2(sprite)
  
  If IsSprite(sprite)
    FreeSprite(sprite)
  EndIf
  
EndProcedure
 
; text
Procedure DrawTextEx(x.f,y.f,text$, couleur.l=0, lineHeight.w=19)  
  Protected nbLine.i=1 ; il y a au moins une ligne
  newtxt${#MaxTxt} = text$
  nbLine + CountString(newtxt$,Chr(13)) ; Nombre de "saut" , au moins 1 
  For i = 1 To nbLine
    Line$ = StringField(newtxt$,i,Chr(13)) ; on découpe entre les chr(10)
    DrawText(x, y + ( (i-1)*lineHeight), Line$, couleur);,$0,$FFFFFF) ; On affiche , et on ajuste suivant l'itérateur 'i' et la hauteur de ligne
  Next
EndProcedure

;}


XIncludeFile "procedures\menu.pbi" ; menu, file, edition..

XIncludeFile "procedures\history.pbi" ; script, history

XIncludeFile "procedures\swatch.pbi"

XIncludeFile "procedures\roughboard.pbi"

XIncludeFile "procedures\gadgets.pbi"  

XIncludeFile "procedures\brush.pbi"

XIncludeFile "procedures\image.pbi"

XIncludeFile "procedures\imgfilters.pbi"

XIncludeFile "procedures\patterns.pbi"

XIncludeFile "procedures\paint.pbi"

XIncludeFile "procedures\layer.pbi" ; + paper, grid...

XIncludeFile "procedures\selection.pbi"


;{ Screen & sprites


Procedure FPS()
  Shared ze_second, ze_fps
  
  ss = Second(Date())
  ze_fps+1
  
  If ze_second <> ss
    ze_second = ss
    SetWindowTitle(0,"Animatoon "+#ProgramVersion+" - "+doc\name$+" - FPS: "+Str(ze_FPS)+
                     " /stroke :"+Str(strokeId)+"/"+Str(ArraySize(Stroke(strokeID)\dot())))
    ze_fps=0
  EndIf
  
EndProcedure

; for tablet
Procedure MyWindowCallback(WindowID, Message, wParam, lParam)
  
  
  Result = #PB_ProcessPureBasicEvents
  
  If Message = #WT_PACKET
    If WTPacket(lParam,wParam, @pkt.PACKET)
      ;WTPacket(lParam,wParam, 0)
      
      If (pkt\pkX = pkX_old) And (pkt\pkY = pkY_old) And (pkt\pkNormalPressure = pkNormalPressure_old)
        ProcedureReturn 0
      EndIf
      
      ;SetGadgetText(#textinfo,"pkButtons: "       + RSet(Hex(pkt\pkButtons),8,"0") )
      ;SetGadgetText(#textinfo+1,"pkX: "               + Str(pkt\pkX               ))
      ;SetGadgetText(#textinfo+2,"pkY: "               + Str(pkt\pkY               ))
      ;SetGadgetText(#textinfo+3,"pkZ: "               + Str(pkt\pkZ               ))
      ;SetGadgetText(#textinfo+4,"pkNormalPressure: "  + Str(pkt\pkNormalPressure  ))
      ;SetGadgetText(#textinfo+5,"pkTangentPressure: " + Str(pkt\pkTangentPressure ))
      
      If pkt\pkNormalPressure
        LastElement( Pakets() )
        AddElement ( Pakets() )
        Pakets() = pkt                 
      EndIf
      
      pkX_old              = pkt\pkX
      pkY_old              = pkt\pkY
      pkNormalPressure_old = pkt\pkNormalPressure
    EndIf
    ProcedureReturn 0
  EndIf
  
  ProcedureReturn Result
EndProcedure

; utile sprite
Procedure SpriteToImage(Sprite)
;   ; attention, windows only
;   hDC=StartDrawing(SpriteOutput(Sprite))
;   bmp.BITMAP\bmWidth=SpriteWidth(Sprite)
;   bmp\bmHeight=SpriteHeight(Sprite)
;   bmp\bmPlanes=1
;   bmp\bmBitsPixel=GetDeviceCaps_(hDC,#BITSPIXEL)
;   bmp\bmBits=DrawingBuffer()
;   bmp\bmWidthBytes=DrawingBufferPitch()
;   hBmp=CreateBitmapIndirect_(bmp)
;   StopDrawing()
;   ;Debug hBmp
;   ProcedureReturn hBmp
EndProcedure
Procedure CreateSelection()
  
  FreeSprite2(#Sp_Select)
  If OptionsIE\SelectionType = #selectionCircle
    w = 2
    h = 2 
  EndIf
  
  If CreateSprite(#Sp_Select, OptionsIE\SelectionW+w,  OptionsIE\SelectionH+h,#PB_Sprite_AlphaBlending)
    
    If StartDrawing(SpriteOutput(#Sp_Select))
      DrawingMode(#PB_2DDrawing_AllChannels)
      ;  Box(0,0,OptionsIE\SelectionW,OptionsIE\SelectionH,RGBA(0,0,0,0))
      Layer_DrawSelection(0, 0)
      
      DrawingMode(#PB_2DDrawing_Outlined)
      
      ; la sélection
      Layer_DrawSelection(0, 0, RGBA(255,0,0,255))
      
      StopDrawing()
    EndIf
    
  EndIf
  
EndProcedure


; Canvas main (for rendering/drawing)
Procedure CanvasMain_Update_()
  
  
  ;update the main canvas for rendering the drawins
  If OptionsIE\useCanvas
    
    If Not IsImage(#Img_PaperForMainCanvas)
      If CreateImage(#Img_PaperForMainCanvas, doc\w, doc\h)
        PaperUpdate()
      EndIf
    EndIf
    
    If StartDrawing(CanvasOutput(#G_CanvasMain))
      
      ; The canvas background grey color
      DrawingMode(#PB_2DDrawing_AllChannels)
      Box(0, 0, OutputWidth(), OutputHeight(), RGBA(100, 100, 100, 255)) 
        
      ; DrawingMode(#PB_2DDrawing_AlphaBlend)
      
;       ClipOutput(0, 0, OutputWidth(), OutputHeight())
      
      
      ; draw the paper
      ; the color
      Box(canvasX, canvasY, doc\w, doc\h, paper\color) 
      
      ; the background paper
      ; supprimer cette image et la remplacer par une boucle next-for.
      DrawAlphaImage(ImageID(#Img_PaperForMainCanvas), canvasX, canvasY, paper\alpha)
;        ; DrawingMode(#PB_2DDrawing_AlphaBlend )
;         For i=0 To (doc\w/w)
;           For j = 0 To (doc\h/h)
;             DrawImage(ImageID(tempImgPaper),i*w,j*h)
;           Next j 
;         Next i       
      
      ; draw the layers
      For i=0 To ArraySize(layer())
        If Layer(i)\view And layer(i)\alpha >0
          Layer_Draw_OnCanvas(i)
          If i = layerId
            If OptionsIE\Shape=1 
              ; DrawAlphaImage(#Sp_LayerTempo, canvasX, canvasY, layer(layerid)\alpha)  
            EndIf
          EndIf  
        EndIf
      Next i
      
      
      ; draw the utils (grid...)
      
      
      
      StopDrawing()
    EndIf
    
    ; If NewPainting = 1
    ;     ;Layer(layerId)\Haschanged = 1
    ; EndIf
     
  EndIf
  
EndProcedure

; main canvas (update, drawing..)
Procedure CanvasDraw(useCanvasPosition=1)
  
  Shared useCanvasPosition2
  ; draw on the canvas
  Protected x, y
  
  Z.d = OptionsIE\Zoom * 0.01
  x = 0
  y = 0
  If useCanvasPosition
    x = canvasX
    y = canvasY
  EndIf
  useCanvasPosition2 = useCanvasPosition
  
  x1 = setmin(x, 0)
  x1 = max (X1, CanvasW); GadgetWidth(#G_CanvasMain)) 
  y1 = setmin(y, 0)
  y1 = max (y1, CanvasH) ; GadgetHeight(#G_CanvasMain))
  

  ; the background paper
  DrawingMode(#PB_2DDrawing_AllChannels)
  ; the color
  Box(x, y, doc\W, doc\H, RGBA(Red(paper\Color), Green(paper\Color), Blue(paper\Color), 255))
  
  ; the paper texture
  If paper\alpha> 0
      
      w = ImageWidth(#Img_PaperForMainCanvas)
      h = ImageHeight(#Img_PaperForMainCanvas)
      
      DrawingMode(#PB_2DDrawing_AlphaClip)
      
      w1 = doc\w
      h1 = doc\h
      If CanvasW > w
        w1 = CanvasW -x1
      EndIf
      If CanvasH > h
        h1 = CanvasH -y1
      EndIf
      
      If useCanvasPosition
        ClipOutput(x, y, w1, h1)
      EndIf
    
      If Doc\w > w And doc\h> h
        For i=0 To (doc\w/w)
          For j = 0 To (doc\h/h)
            DrawAlphaImage(ImageID(#Img_PaperForMainCanvas), x + i*w, Y + j*h, paper\alpha)
          Next j 
        Next i  
      Else
        If Doc\w > w And doc\h<=H
          For i=0 To (doc\w/w)
            DrawAlphaImage(ImageID(#Img_PaperForMainCanvas), x + i*w, Y , paper\alpha)
          Next i  
        ElseIf Doc\w <= w And doc\h>H
          For j = 0 To (doc\h/h)
            DrawAlphaImage(ImageID(#Img_PaperForMainCanvas), x , Y + j*h, paper\alpha)
          Next j 
        Else
          DrawAlphaImage(ImageID(#Img_PaperForMainCanvas), x, Y, paper\alpha)
        EndIf
        
      EndIf
    EndIf
    
    If useCanvasPosition
      ClipOutput(0, 0, GadgetWidth(#G_CanvasMain), GadgetHeight(#G_CanvasMain))
    EndIf
    
  ; the layers
  For i = 0 To ArraySize(layer())
    If layer(i)\view And layer(i)\alpha > 0
      Layer_Draw_OnCanvas(i)
    EndIf
  Next
  
  
  
  
EndProcedure
Procedure CanvasUpdate(useMini=0)
  
  If OptionsIE\useCanvas = 1
    x = canvasX
    y = canvasY
    
    If StartDrawing(CanvasOutput(#G_CanvasMain))
      DrawingMode(#PB_2DDrawing_AllChannels) 
      ; the greybackground
      Box(0, 0, GadgetWidth(#G_CanvasMain),  GadgetHeight(#G_CanvasMain), RGB(100, 100, 100))
      
      ClipOutput(0, 0, GadgetWidth(#G_CanvasMain), GadgetHeight(#G_CanvasMain))
      
      If useMini = 0
        CanvasDraw()
      Else
        DrawAlphaImage(ImageID(#ImagecanvasMini), x, y, 255)
      EndIf
      
      StopDrawing()
    EndIf
  EndIf
  

EndProcedure
Procedure Canvas_SetImageforMove()
  
  ; Shared CanvasHasChanged
  If OptionsIE\usecanvas = 1
    If CanvasHasChanged
      If StartDrawing(ImageOutput(#ImagecanvasMini))
        CanvasDraw(0)
        StopDrawing()
      EndIf
      CanvasHasChanged = 0
      ; ResizeImage(#ImagecanvasMini, docW/3, docH/3)
    EndIf
  EndIf
  
  
EndProcedure
Procedure Canvas_CreateImageMiniForMove(create=1)
  
  FreeImage2(#ImagecanvasMini)
   
  If create = 1
    If OptionsIE\usecanvas = 1
      If Not IsImage(#ImagecanvasMini)
        If CreateImage(#ImagecanvasMini, Doc\w, doc\h, 32, #PB_Image_Transparent) 
          If StartDrawing(ImageOutput(#ImagecanvasMini))
            CanvasDraw(0)
            StopDrawing()
          EndIf
        EndIf
      EndIf
    EndIf
  EndIf
  
EndProcedure



; screen
Macro DrawUtil()
  
  
  ; Selection
  If OptionsIE\Selection = 2
    ZoomSprite(#Sp_Select, OptionsIE\SelectionW*z,OptionsIE\SelectionH*z)
    ;SpriteBlendingMode(#PB_Sprite_BlendSourceAlpha, #PB_Sprite_BlendInvertSourceAlpha)
    ;DisplayTransparentSprite(#Sp_Select,canvasX+OptionsIE\SelectionX*z,canvasY+OptionsIE\SelectionY*z)
    SpriteBlendingMode(#PB_Sprite_BlendInvertDestinationColor, #PB_Sprite_BlendInvertSourceColor)
    DisplayTransparentSprite(#Sp_Select,canvasX+OptionsIE\SelectionX*z,canvasY+OptionsIE\SelectionY*z)
  EndIf
  
  ; grid 
  
  If OptionsIE\grid
    SpriteQuality(1)
    ZoomSprite(#Sp_grid, Doc\W*z, Doc\H*z)
    SpriteBlendingMode(#PB_Sprite_BlendSourceAlpha, #PB_Sprite_BlendInvertSourceAlpha) 
    DisplayTransparentSprite(#Sp_grid, canvasX,canvasY)
    SpriteQuality(OptionsIE\SpriteQuality)
  EndIf 
 
  
EndMacro

Procedure ScreenDraw()
  
  If OptionsIE\UseCanvas = 0
    
    z.d = OptionsIE\zoom * 0.01
    
    ; on update le screen
    ClearScreen(RGB(120,120,120))
    
    ; the paper
    PaperDraw() ; THe color, in layers.pbi
    
    ; les calques
    Layer_DrawAll() ; in layers.pbi
    
    
    ; les utilitaires
    
    ; sélection, cadre (quand transform par exemple)
    Layer_DrawBorder(LayerId) ; <- draw selection in real time here
    DrawUtil()
    
  EndIf
  
  
EndProcedure
Procedure SetAlphaMask(i)
  
  If OptionsIE\SelectAlpha = 1 
    
    If layer(i)\Bm = #Bm_Normal
      DrawingMode(#PB_2DDrawing_AlphaChannel)
      DrawAlphaImage(ImageID(#Img_AlphaSel),0,0)  
      DrawingMode(#PB_2DDrawing_CustomFilter)
      CustomFilterCallback(@Filtre_MaskAlpha())
      ;DrawingMode(#PB_2DDrawing_AlphaClip)
    Else
      DrawingMode(#PB_2DDrawing_AllChannels)
      DrawAlphaImage(ImageID(#Img_AlphaSel),0,0)  
      DrawingMode(#PB_2DDrawing_AlphaClip)
    EndIf
    
    If (layer(i)\MaskAlpha >= 1 And layer(i)\MaskAlpha < 3)
      ; DrawingMode(#PB_2DDrawing_AlphaChannel)
      DrawAlphaImage(ImageID(Layer(i)\ImageAlpha),0,0)    
      
      ;DrawingMode(#PB_2DDrawing_CustomFilter)
      ;CustomFilterCallback(@Filtre_MaskAlpha())
      
      ;Else
      ;DrawingMode(#PB_2DDrawing_AlphaBlend)
    EndIf
    
  Else  
    
    If (layer(i)\MaskAlpha >= 1 And layer(i)\MaskAlpha < 3)
      DrawingMode(#PB_2DDrawing_AlphaChannel)
      DrawAlphaImage(ImageID(Layer(i)\ImageAlpha),0,0)    
      
      If layer(i)\Bm = #Bm_Normal
        DrawingMode(#PB_2DDrawing_CustomFilter)
        CustomFilterCallback(@Filtre_MaskAlpha())
      Else
        DrawingMode(#PB_2DDrawing_AlphaClip)
      EndIf
      
    Else
      DrawingMode(#PB_2DDrawing_AlphaBlend)
    EndIf
  EndIf
  
EndProcedure

Procedure ScreenUpdate(updateLayer=0, updateCanvas = 0)
  
  z.d = OptionsIE\zoom * 0.01
  
  If OptionsIE\UseCanvas = 0
    
    ;{ use screen for rendering surface
    If NewPainting = 1
      
      ; Layer(layerId)\Haschanged = 1
      
      If layer(layerId)\Typ <> #Layer_TypText
      
        w = Layer(Layerid)\w
        h = Layer(Layerid)\h
        
        NewPainting = 0
        
        If layer(layerId)\bm = #Bm_Normal
          alpha= 255
        Else
          alpha = layer(layerId)\Alpha 
        EndIf
        
        If StartDrawing(SpriteOutput(layer(LayerId)\Sprite))
          ; on l'efface
          DrawingMode(#PB_2DDrawing_AlphaChannel)
          Box(0, 0, w, h, RGBA(0,0,0,0))
          ; puis on redessine tout
          
          ; DrawingMode(#PB_2DDrawing_AlphaBlend)
          SetAlphaMask(LayerId)
          
          Select layer(LayerId)\bm 
            Case #Bm_Normal          
              ; SetAlphaMask()
              Layer_DrawImg(LayerId, alpha)
              
            Case #Bm_Add, #Bm_Clearlight, #Bm_Screen, #Bm_Colorlight, #Bm_Lighten
              Box(0,0,w,h,RGBA(0,0,0,255))
              ; DrawAlphaImage(ImageID(Layer(LayerId)\ImageBM),0,0)
              ; SetAlphaMask()
              Layer_DrawImg(LayerId, alpha)
              
            Case #Bm_Darken, #Bm_Multiply, #Bm_LinearBurn
              Box(0,0,w,h,RGBA(255,255,255,255))
              ; SetAlphaMask()
              Layer_DrawImg(LayerId, alpha)
              
            Case #bm_overlay
              ;, #Bm_LinearBurn
              ; Box(0,0,w,h,RGBA(0,0,0,255))
              Box(0,0,w,h,RGBA(60,60,60,255))
              ; DrawAlphaImage(ImageID(Layer(LayerId)\ImageBM),0,0,layer(layerid)\alpha)
              ; SetAlphaMask()
              Layer_DrawImg(LayerId, layer(layerid)\alpha)
              
            Default 
              ; DrawingMode(#PB_2DDrawing_AlphaBlend)
              Box(0,0,w,h,RGBA(255,255,255,255-layer(LayerId)\alpha))
              ; DrawAlphaImage(ImageID(Layer(LayerId)\ImageBM),0,0,layer(layerid)\alpha)
              ; SetAlphaMask()
              Layer_DrawImg(LayerId, layer(layerid)\alpha)
              
          EndSelect
          
          StopDrawing()
        EndIf
        
      EndIf
    
    EndIf
  
    ; draw on the screen
    ScreenDraw()  
    
    If OptionsIE\Selection <> 1
      
      ; show the screen / on affiche l'ecran
      FlipBuffers()
      
    EndIf
    
    ;}
    
  Else
    
    ;If updateCanvas
      ; update the canvas if used
      CanvasUpdate()
    
    ;EndIf
    
  EndIf
  
EndProcedure
Procedure ScreenZoom()
  
  ; zoom on the screen
  z.d = OptionsIE\zoom * 0.01
  
  IE_StatusBarUpdate()
  BrushUpdateImage(0,1)
  BrushUpdateColor()
  
    
  ; then check the zoom type
  Select brush(#Action_Zoom)\Type
      
    Case 0 
      ; by default in 0, 0
      
      
    Case 1 
      ; zoom on mouse --- WIP !!! don't work :(
      CanvasX = mx - OldCanvasX
      CanvasY = my - OldCanvasY
      ; CanvasX = OldCanvasX + ((mx - OldCanvasX)* (Z - 1.0) + (Z * Abs(CanvasX))) * -1 
      ; CanvasY = OldCanvasY + ((my - OldCanvasY)* (Z - 1.0) + (Z * Abs(CanvasY))) * -1
      
      ; Vx = x + ((Mx - x) * (ZFactor - 1.0) + (ZFactor * Abs(Vx))) * -1
      ; Vy = Y + ((My - y) * (ZFactor - 1.0) + (ZFactor * Abs(Vy))) * -1
      
      
    Case 2 
      ; zoom on center of the canvas
      CanvasX = ScreenWidth()/2 - (doc\w*z)/2
      CanvasY = ScreenHeight()/2 - (doc\h*z)/2
      
  EndSelect
  

  If OptionsIE\UseCanvas = 0
    If NewPainting= 1    
      NewPainting = 0
      If StartDrawing(SpriteOutput(layer(LayerId)\Sprite))
        DrawingMode(#PB_2DDrawing_AlphaChannel)
        Box(0,0,doc\w,doc\w,RGBA(0,0,0,0))
        DrawingMode(#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(ImageID(Layer(LayerId)\image),0,0)
        StopDrawing()
      EndIf
      
    EndIf
    
    ScreenDraw()
    FlipBuffers() ; show the screen // affiche l'ecran
  Else
    
  EndIf

EndProcedure
Procedure ScreenResize(w, h)
  
  ScreenResized = 0
  
  CanvasW = w
  CanvasH = h
  
  For i = 0 To ArraySize(layer())
    FreeSprite2(layer(i)\Sprite)
  Next i
  
  FreeSprite2(#Sp_Paper)
  
  ; on ferme l'écran
  CloseScreen()
  
  If OpenWindowedScreen(WindowID(#WinMain), ScreenX, ScreenY, CanvasW, CanvasH)=0
    MessageRequester("Error","unable to open a new screen ! (Please report this bug with your OS and graphic card.)")
    End
  EndIf
  
  PaperInit(0)
  ResetAllSprites()
  
  For i = 0 To ArraySize(layer())
    layer(i)\Sprite = CreateSprite(#PB_Any, doc\w,doc\h,#PB_Sprite_AlphaBlending)
  Next i
  
  ; puis, j'update chaque layer
  For i = 0 To ArraySize(layer())
    NewPainting = 1
    LayerId = i
    ScreenUpdate(1)
  Next i
  
  
EndProcedure

;}


;{ linux
CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  
  ; for the screen in a gadget
  Procedure XDisplayFromWindowID(*Window.GtkWidget) 
    *gdkwindowobj._GdkWindowObject = *Window\window
    *impl.GdkDrawableImplX11 = *gdkwindowobj\impl
    *screen.GdkScreenX11 = *impl\screen
    ProcedureReturn *screen\xdisplay       
  EndProcedure  
  
CompilerEndIf
;}



XIncludeFile "procedures\window.pbi"


; IDE Options = PureBasic 5.61 (Windows - x86)
; CursorPosition = 369
; FirstLine = 47
; Folding = gAAynAAAAcrvBA5
; EnableXP
; Executable = ..\_old\animatoon_screen0.22.exe
; SubSystem = openGL
; DisableDebugger
; EnableUnicode