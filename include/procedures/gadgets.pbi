
; gadgets, UI, paper, updates...



; ui & update

;{ Macro et procedures to create easily Gadgets 

; use text$ as argument and not lang(text$), so I can do : IE_btn2(id, icon, lang(text$)+text2$...) if needed.

; gadgets
Procedure IE_InsertBar(xx, u=4)
  Shared toolbarH  
  ; ImageGadget(#PB_Any,xx + u, 1, 1, OptionsIE\ToolBarH-2, ImageID(#IE_img_barre))
  xx+10
  ProcedureReturn xx
EndProcedure

Macro IE_btn2(id, icon, tip, x = 1, toggle=1)
  
  If x = 0
    xx = 5  
  EndIf
  
  If ButtonImageGadget(id, xx, yy, siz, siz, ImageID(icon), #PB_Button_Toggle * toggle)
    
    SetGadgetColor(id,#PB_Gadget_BackColor, OptionsIE\ThemeGadCol)
    GadgetToolTip(id, tip) ; ne pas mettre lang car on a les raccourcis dessus
    
    xx + (siz + u)
  EndIf
  
EndMacro
Macro IE_Btn(id, icon, tip)
  
  xx + 25      
  If ButtonImageGadget(id, xx, yy, 22, 22, ImageID(icon), #PB_Button_Toggle) 
    GadgetToolTip(id, tip)
  EndIf
  
EndMacro
Macro IE_Btn1(gad, icon, tip)
  ButtonImageGadget(gad, i, yy, 22, 22, ImageID(icon), #PB_Button_Toggle) 
  GadgetToolTip(gad, tip)
EndMacro
Macro AddSpinGadget(gadg,val,tip,x,y,w,h,min,max,flag)
  
  If SpinGadget(gadg,x,y,w,h,min,max,flag)
    SetGadgetState(gadg, val)
    GadgetToolTip(gadg, tip)
  EndIf
  
EndMacro
Macro AddCheckBox(gadg,x,y,w,h,nom,val,tip)
  
  If CheckBoxGadget(gadg, x,y,w,h, nom)
    SetGadgetState(gadg, val)
    GadgetToolTip(gadg, tip)
  EndIf
  
EndMacro
Macro AddButonImage(gadg,x,y,w,h,img,flag,tip)
  
  If ButtonImageGadget(gadg,x,y,w,h, ImageID(img),flag) 
    GadgetToolTip(gadg, tip)
  EndIf
  
EndMacro

Procedure AddSTringTBGadget(gadName,gadTB,gadSG,val,name$,tip$,x,y,wtb,wsg,min,max,wtg=30)
  
  ; string gadget, name and trackbar
  
  ; wtb = width for trackbar
  ; wsg = width of stringgagdet
  ; wtg = width for the text gadget
  
  ; to color the gadget
  color =  GetWindowColor(GetActiveWindow())
  
  ; To add a gadget Name+trackbar +stringgadget !! test pour ajouter un gadget "spécial : nom, trackbar et stringgadget
  h = 20
  If gadname <> -1
    If TextGadget(gadName, x+5, y, wtg, h, name$)
      SetGadgetColor(gadName, #PB_Gadget_BackColor, color)       
    EndIf 
  Else
    wtg = 0
  EndIf  
  
  If TrackBarGadget(gadTB, x+2+wtg, y, wtb, h, min, max)
    SetGadgetColor(gadTB, #PB_Gadget_BackColor, color)       
    SetGadgetState(gadTB, val)
    GadgetToolTip(gadTB, tip$)
    
    If StringGadget(GadSG,x+4+wtg+wtb, y, wsg, h, Str(val))  
      SetGadgetColor(GadSG, #PB_Gadget_BackColor, color)       
      SetGadgetText(GadSG, Str(val))
      GadgetToolTip(GadSG, tip$)
      ProcedureReturn 1
    EndIf
  EndIf
  
EndProcedure
Procedure AddCheckBox2(x,y,w,h,nom$,val,tip$)
  gad = CheckBoxGadget(#PB_Any, x,y,w,h,nom$)
  If gad
    SetGadgetState(gad, val)
    GadgetToolTip(gad, tip$) 
  EndIf
  ProcedureReturn gad
EndProcedure
Procedure AddButonImage2(x,y,w,h,img,flag,tip$)
  gad = ButtonImageGadget(#PB_Any,x,y,w,h, ImageID(img),flag) 
  If gad 
    GadgetToolTip(gad, tip$)
  EndIf
  ProcedureReturn gad
EndProcedure
Procedure AddButonImage3(id, x,y,w,h,img,flag,tip$)
  
  ; to create a butonimage
  ; I should replace AddButonImage2() by this procedure
  
  gad = ButtonImageGadget(id,x,y,w,h, ImageID(img),flag) 
  
  If gad 
    GadgetToolTip(id, tip$)
  EndIf
  ProcedureReturn gad
  
EndProcedure
Procedure AddButon2(x,y,w,h,txt$,flag,tip$)
  
  gad = ButtonGadget(#PB_Any,x,y,w,h, txt$,flag) 
  
  If gad 
    GadgetToolTip(gad, tip$)
  EndIf
  ProcedureReturn gad
  
EndProcedure
Procedure AddStringGadget(gad, x, y, w, h, text$, name$, tip$)
  
  If name$ <> ""
    w1 = Len(name$)*6
    gad2 = TextGadget(#PB_Any, x, y, w1, h, name$)
    x+w1
  EndIf
  
  If StringGadget(gad, x, y, w, h, text$)
    GadgetToolTip(gad, tip$)
  EndIf
  ProcedureReturn gad2
EndProcedure


Macro HideGad2(gad,state,value)
  If IsGadget(gad)
    HideGadget(gad,state)
  EndIf
  SetGadgetState(gad,value)  
EndMacro
Macro FreeGadget2(gad)
  
  If IsGadget(gad)
    FreeGadget(gad)
  EndIf
  
EndMacro

; Utile (create gadget)
Procedure TG(x,y,txt$,col=-1) 
  
  ; create textgadget
  
  ; a procedure to create a text gadget
  gad = TextGadget(#PB_Any,x,y,Len(txt$+":")*7,20,txt$+":")
  If col <> -1
    SetGadgetColor(gad,#PB_Gadget_BackColor,col)
  EndIf
  
  ProcedureReturn gad
  
EndProcedure
Procedure SG(x,y,w,txt$,col=-1) 
  ; create Stringgadget
  ; a procedure to create a string gadget
  
  gad = StringGadget(#PB_Any,x,y,w,20, txt$)
  If col <> -1
    SetGadgetColor(gad,#PB_Gadget_BackColor,col)
  EndIf
  ProcedureReturn gad
EndProcedure


;}


Procedure ResetAllSprites()
  
  FreeSprite2(#Sp_BrushOriginal)
  FreeSprite2(#Sp_BrushCopy)
  If LoadSprite(#Sp_BrushOriginal, OptionsIE\DirBrush$+Brush(Action)\brushname$,#PB_Sprite_AlphaBlending) : EndIf
  If CopySprite(#Sp_BrushOriginal, #Sp_BrushCopy,#PB_Sprite_AlphaBlending)  : EndIf
  
  FreeSprite2(#Sp_LayerTempo)
  
  If CreateSprite(#Sp_LayerTempo,doc\w,doc\h,#PB_Sprite_AlphaBlending) : EndIf
  
EndProcedure


; statusbar...
Procedure IE_StatusBarUpdate()
  StatusBarText(#statusbar, 0, Lang("Zoom")+" : "+Str(OptionsIE\zoom))
  StatusBarText(#statusbar, 1, Lang("Doc")+" : "+Str(Doc\w)+"/"+Str(Doc\h))
  StatusBarText(#Statusbar, 3, "")
EndProcedure
Procedure IE_StatusBarAdd()
  
  If CreateStatusBar(#statusbar,WindowID(0))
    AddStatusBarField(150)
    AddStatusBarField(200)
    AddStatusBarField(200)
    AddStatusBarField(200)
  EndIf
  IE_StatusBarUpdate()
  
EndProcedure



; convert rgb - hsv
Procedure RgbToHSV(r,g,b)
  
  R1.f = R
  R1/255    
  G1.f = G
  G1/255    
  B1.f = B
  B1/255
  
  Cmax.f = max3(R1, G1, B1)    
  Cmin.f = min3(R1, G1, B1)    
  delta.f = Cmax - Cmin
  
  
  ; Value calculation:  
  HSV\v = Cmax
  
  ; Saturation
  If Cmax <> 0 
    HSV\s = delta 
    HSV\s/ Cmax ;		// s
  Else 
    HSV\s = 0;
    HSV\h = -1;
    ProcedureReturn 
  EndIf
  
  ; HUE
  
  If  Delta = 0  ;//This is a gray, no chroma...
    
    HSV\H = 0   ;//HSV results from 0 To 1
    HSV\S = 0
    
  Else   ;//Chromatic Data...
    
    HSV\S = Delta / Cmax
    
    del_R.f = ( ( ( Cmax - R1 ) / 6 ) + ( Delta / 2 ) ) / Delta
    del_G.f = ( ( ( Cmax - G1 ) / 6 ) + ( Delta / 2 ) ) / Delta
    del_B.f = ( ( ( Cmax - B1 ) / 6 ) + ( Delta / 2 ) ) / Delta
    
    If  R1 = Cmax  
      HSV\H = del_B - del_G
    ElseIf G1 = Cmax  
      HSV\H = ( 1 / 3 ) + del_R - del_B
    ElseIf  B1 = Cmax  
      HSV\H = ( 2 / 3 ) + del_G - del_R
    EndIf
    
    If  HSV\H < 0  
      HSV\H + 1   
    ElseIf  HSV\H > 1  
      HSV\H - 1
    EndIf
    
    
    
  EndIf
  
  
  HSV\h * 360  ;				// degrees
  If HSV\h < 0 
    HSV\h + 360
  EndIf
  
  
  
EndProcedure
Procedure.i HSV2RGB(H.f,S.f,V.f) 
  
  Define.COLOUR  sat 
  
  While h < 0 
    h = h + 360 
  Wend 
  
  While h > 360 
    h = h - 360 
  Wend 
  
  If h < 120 
    sat\r = (120 - h) / 60.0 
    sat\g = h / 60.0 
    sat\b = 0 
  ElseIf h < 240 
    sat\r = 0 
    sat\g = (240 - h) / 60.0 
    sat\b = (h - 120) / 60.0 
  Else 
    sat\r = (h - 240) / 60.0 
    sat\g = 0 
    sat\b = (360 - h) / 60.0 
  EndIf 
  
  sat\r = MinF(sat\r, 1) 
  sat\g = MinF(sat\g, 1) 
  sat\b = MinF(sat\b, 1) 
  
  r = ((1 - s + s * sat\r) * v )*255
  g = ((1 - s + s * sat\g) * v )*255
  b = ((1 - s + s * sat\b) * v )*255
  
  ; Debug "RGB (d'après la teinte) : " + Str(R)+"/"+Str(G)+"/"+Str(B)
  
  ProcedureReturn RGB(r,g,b)    
EndProcedure 


; color & selector
Procedure UpdateColorImageBG_FG()
  w = GadgetWidth(#G_BrushColorFG)
  ; color select FrontGround color  (color_fg)
  If StartDrawing(ImageOutput(#ImageColorFG))
    ;Box(0,0,30,30,RGB(255,255,255))
    Box(0,0,w,w,Brush(Action)\ColorFG)
    StopDrawing()
  EndIf
  
  ; color select BackGround color (color_bg)
  If StartDrawing(ImageOutput(#ImageColorBG))
    ;Box(0,0,30,30,RGB(255,255,255))
    Box(0,0,w,w,Brush(Action)\Color)
    StopDrawing()
  EndIf 
  
  If SetGadgetState(#G_BrushColorFG,ImageID(#ImageColorFG)) : EndIf
  If SetGadgetState(#G_BrushColorBG,ImageID(#ImageColorBG)) : EndIf
  
EndProcedure
Procedure SetColor(mode = 0)
  
  ; If mode = 0
  ;Brush(Action)\color = CurrentColor
  ;EndIf  
  ;SetBrush()
  ;If ui\PanelBrush =0
  ;     If StartDrawing(ImageOutput(#IMAGE_Color))
  ;       Box(0, 0, 30,30, CurrentColor)
  ;       StopDrawing()
  ;       SetGadgetState(#GADGET_Color, ImageID(#IMAGE_Color))
  ;     EndIf 
  ;   Else
  UpdateColorImageBG_FG()
  ;EndIf
  ;ChangeBrushImage()   
  BrushResetColor()
  BrushUpdateImage(0,1)
  Brush(Action)\colorQ = Brush(Action)\color
  
  ;SetGadgetState(#GADGET_BrushPreview,ImageID(#IMAGE_BrushPreview))
  
EndProcedure
Procedure SetArcEnCiel()
  
  If StartDrawing(ImageOutput(#IMAGE_ColorArcEnCiel))
    r=255
    g=0
    b=0
    For i=0 To 255
      Select stage
        Case 0 
          g+6  
          If g>255 :g=255:stage+1: 
          EndIf
          
        Case 1 
          r-6  
          If r<0   :r=0  :stage+1: 
          EndIf
          
        Case 2
          b+6 
          If b>255 :b=255:stage+1: 
          EndIf
          
        Case 3 
          g-6 
          If g<0   :g=0  :stage+1: 
          EndIf
          
        Case 4 
          r+6 
          If r>255 :r=255:stage+1: 
          EndIf
          
        Case 5
          b-6 :
          If b<0   :b=0  :stage+1: 
          EndIf
          
      EndSelect
      For k=0 To #GetColor_ArcEnCiel_L-1
        Plot(k,i,RGB(r,g,b))
      Next
    Next
    StopDrawing()
  EndIf
  
EndProcedure
Procedure SetColorSelector(color,x=0,y=0,mode=0,txt=1)  
  
  Shared cursorX,cursorY
  
  R = Red(color)
  G = Green(color)
  B = Blue(color)
  
  ; mode = 0 : take the color from arc-en-ciel
  ; mode = 1 : take the color on the selector
  ; mode = 2 : take the color from the stringgadget (RGB value)
  ; mode = 3 : take the color from canvas or imageBG color
  ; mode = 4 : we only change the tool
  
  If mode <> 1 ; color taken from  ArcEnCiel | canvas | color imageBG| Text RGB :  we re-create the gradient color
    
    RGBtoHSV(R,G,B)  
    ; ça, c'est ok 
    ;Debug StrF(HSV\H,3)+"/"+StrF(HSV\V,3) + "/"+StrF(HSV\S,3)
    
    H = HSV2RGB(HSV\H,1,1) 
    
    R = Red(H)
    G = Green(H)
    B = Blue(H)
    
  EndIf
  
  If mode >= 2
    WG = GadgetWidth(#G_ColorSelector)-2
    HG = GadgetHeight(#G_ColorSelector)-2
    CursorX = WG * HSV\s
    CursorY = HG - HG * HSV\v
  EndIf
  
  
  ; Debug "Selector size : "+Str(GadgetWidth(#G_ColorSelector))+"/"+Str(GadgetHeight(#G_ColorSelector))
  
  If mode <> 1
    ResizeImage(#IMAGE_ColorSelector,256,256,#PB_Image_Raw)
    
    If StartDrawing(ImageOutput(#IMAGE_ColorSelector))
      Box(0,0,256,256,RGBA(255,255,255,255))    
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      For i = 0 To 255
        For j = 0 To 255
          Plot(i, j, RGBA($FF, $FF, $FF, i))
          Plot(i, j, RGBA(0, 0, 0, j))
        Next
      Next
      
      For i = 0 To 255
        For j = 0 To 255		    
          Plot(i, j, RGBA(R, G, B, i))
          Plot(i, j, RGBA(0, 0, 0, j))
        Next
      Next
      StopDrawing()
    EndIf
    
    If IsGadget(#G_ColorArcEnCielSelect)
      ResizeGadget(#G_ColorArcEnCielSelect,#PB_Ignore,y-6+GadgetY(#G_ColorArcEnCiel),#PB_Ignore,#PB_Ignore)
    EndIf  
    
    ;Debug Str(GadgetWidth(#G_ColorSelector))+"/"+Str(GadgetHeight(#G_ColorSelector))
    
    
  EndIf
  
  ; Debug "Cursor : "+Str(cursorX)+"/"+Str(cursorY)
  
  ;w = GadgetWidth(#G_ColorSelector)
  ;ResizeImage(#IMAGE_ColorSelector,w,w,#PB_Image_Smooth)
  
  If IsGadget(#G_ColorSelector)    
    If StartDrawing(CanvasOutput(#G_ColorSelector))
      Box(0,0,256,256,RGB(255,255,255))    
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      DrawImage(ImageID(#IMAGE_ColorSelector),0,0,GadgetWidth(#G_ColorSelector),GadgetHeight(#G_ColorSelector))
      ;DrawImage(ImageID(#IMAGE_ColorSelector),0,0)
      If mode =1
        DrawingMode(#PB_2DDrawing_Outlined)
        Circle(x,y,8,#White2)
        Circle(x,y,9,#Black2)
        CursorX = x
        CursorY = y
      Else 
        DrawingMode(#PB_2DDrawing_Outlined)
        Circle(cursorX,cursorY,8,#White2)
        Circle(cursorX,cursorY,9,#Black2)
      EndIf 
      StopDrawing()
    EndIf    
  EndIf 
  
  If txt = 1
    R = Red(color)
    G = Green(color)
    B = Blue(color)  
    SetGadgetText(#GADGET_ColorTxtR,Str(R))
    SetGadgetText(#GADGET_ColorTxtG,Str(G))
    SetGadgetText(#GADGET_ColorTxtB,Str(B))
  EndIf
  
EndProcedure
Procedure ColorSelect(x,y,selector=0)
  
  Shared cursorX,cursorY
  
  If selector = 0
    gad = #G_ColorArcEnCiel    
  Else
    gad = #G_ColorSelector
  EndIf
  
  ;If x>=0 And y>=0 And x<=GadgetWidth(gad) And y<=GadgetHeight(gad)
  
  If selector =0; arc en ciel
    
    ;     If StartDrawing(WindowOutput(#WinMain))
    ;       col = Point(WindowMouseX(#winmain),WindowMouseY(#winmain)) 
    ;       StopDrawing()
    ;     EndIf
    
    If StartDrawing(CanvasOutput(#G_ColorArcEnCiel))
      col = Point(x,y)        
      StopDrawing()
    EndIf
    
    ; Debug Str(cursorX)+"/"+Str(cursorY)
    
    If StartDrawing(CanvasOutput(#G_ColorSelector))
      Select OptionsIE\selectColor 
          
        Case 0 ; BG / base color, of the brush, box..
          Brush(Action)\color = Point(cursorX,cursorY)
          
        Case 1 ; FG color
          Brush(Action)\ColorFG  = Point(cursorX,cursorY)
          
      EndSelect
      
      StopDrawing()
    EndIf
    
  Else
    
    If StartDrawing(CanvasOutput(#G_ColorSelector))
      
      Select OptionsIE\selectColor 
          
        Case 0 ; BG / base color, of the brush, box..
               ;Brush(Action)\color  = Point(WindowMouseX(#winmain),WindowMouseY(#winmain))
          Brush(Action)\color  = Point(x,y)
          ; Brush(Action)\colorBG = Brush(Action)\color
          
        Case 1 ; FG color
               ;Brush(Action)\ColorFG  = Point(WindowMouseX(#winmain),WindowMouseY(#winmain))
          Brush(Action)\ColorFG  = Point(x,y)
          
      EndSelect
      StopDrawing()
    EndIf
    col = Brush(Action)\color
    
  EndIf
  
  
  Brush(Action)\ColorBG\R = Red(Brush(Action)\Color)
  Brush(Action)\ColorBG\G = Green(Brush(Action)\Color)
  Brush(Action)\ColorBG\B = Blue(Brush(Action)\Color)                      
  BrushChangeColor(1)
  color = RGBA(Brush(Action)\col\R,Brush(Action)\col\G,Brush(Action)\col\B,Brush(Action)\alpha)
  
  SetColor()
  SetColorSelector(col,x,y,selector,1)
  
  ;EndIf
  
EndProcedure
Procedure RGBToHLS(lCR.l, lCG.l, lCB.l, *lCH, *lCL, *lCS)
  
  ; By GallyHC
  
  ; ROUTINE DE CONSERTION DU RGB EN HLS.
  Define fCH.f
  Define fCS.f
  Define fCL.f
  Define lMin.l
  Define lMax.l
  Define lDif.l
  Define lSum.l
  Define lNmR.l
  Define lNmG.l
  Define lNmB.l
  
  If lCR < lCG
    If lCR < lCB
      lMin = lCR
    Else
      lMin = lCB
    EndIf
  Else
    If lCG < lCB
      lMin = lCG
    Else
      lMin = lCB
    EndIf
  EndIf
  If lCR > lCG
    If lCR > lCG
      lMax = lCR
    Else
      lMax = lCB
    EndIf
  Else
    If lCG > lCB
      lMax = lCG
    Else
      lMax = lCB
    EndIf
  EndIf
  lDif = lMax - lMin
  lSum = lMax + lMin
  fCL = lSum / 510
  If lMax = lMin
    fCH = 0
    fCS = 0
  Else
    lNmR = (lMax - lCR) / lDif
    lNmG = (lMax - lCG) / lDif
    lNmB = (lMax - lCB) / lDif
    If fCL <= 0.5
      fCS = lDif / lSum
    Else
      fCS = lDif / (510 - lSum)
    EndIf
    If lCR = lMax
      fCH = 60 * (6 + lNmB - lNmG)
    EndIf
    If lCG = lMax
      fCH = 60 * (2 + lNmR - lNmB)
    EndIf
    If lCB = lMax
      fCH = 60 * (4 + lNmG - lNmR)
    EndIf
  EndIf
  If fCH = 360
    fCH = 0
  EndIf
  fCH = (fCH / 360 *  #COLOR_SPECTRUM_SIZE_MAX)
  fCL = fCL *  #COLOR_SPECTRUM_SIZE_MAX
  fCS = fCS *  #COLOR_SPECTRUM_SIZE_MAX
  PokeL(*lCH, Int(fCH))
  PokeL(*lCL, Int(fCL))
  PokeL(*lCS, Int(fCS))
  
EndProcedure
Procedure RGBtoHSL2()
  
  With Brush(action)\Col
    RGBToHLS(\R, \G, \B, @Brush(action)\Col\H, @Brush(action)\Col\L, @Brush(action)\Col\S)
  EndWith
  
EndProcedure



; swatch 
; are in include\procedures\swatch.pbi

; selector color
Macro CreateColorSelector()
  
  ww = #GetColor_ArcEnCiel_L
  hh = PanelToolsW_IE-#GetColor_ArcEnCiel_L-10 ;  #GetColor_ArcEnCiel_H -(screenX+10 - #GetColor_ArcEnCiel_H)
  
  If CreateImage(#IMAGE_ColorSelector,hh,hh) : EndIf
  
  
  If CreateImage(#IMAGE_CursorColSeL,32,32,32,#PB_Image_Transparent) : EndIf
  If StartDrawing(ImageOutput(#IMAGE_CursorColSeL))
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    ;DrawingMode(#PB_2DDrawing_Outlined)
    ;Circle(16,16,14)
    Box(0,0,32,1,RGBA(255,255,255,0))
    Box(0,1,32,1,RGBA(255,255,255,255))
    StopDrawing()
  EndIf
  
  ; Arc en ciel
  If CreateImage(#IMAGE_ColorArcEnCiel,#GetColor_ArcEnCiel_L,256,32)
    SetArcEnCiel()
    ResizeImage(#IMAGE_ColorArcEnCiel,#GetColor_ArcEnCiel_L,#GetColor_ArcEnCiel_H)
  EndIf
  
  
  If CanvasGadget(#G_ColorArcEnCiel,5,10+i,ww,hh,#PB_Canvas_ClipMouse) : EndIf
  
  If CanvasGadget(#G_ColorSelector,ww+8,10+i,hh,hh+1,#PB_Canvas_ClipMouse) : EndIf
  
  x = GadgetX(#G_ColorArcEnCiel)    
  If ImageGadget(#G_ColorArcEnCielSelect,x-8,4,8,12,ImageID(#IMAGE_CursorColSeL)) : EndIf
  
  If StringGadget(#GADGET_ColorTxtR,30,148+i,35,20,Str(Brush(Action)\col\R)) : EndIf
  If StringGadget(#GADGET_ColorTxtG,70,148+i,35,20,Str(Brush(Action)\col\G)) : EndIf
  If StringGadget(#GADGET_ColorTxtB,110,148+i,35,20,Str(Brush(Action)\col\B)) : EndIf
  
  SetColorSelector(Brush(Action)\ColorBG)
  
  If StartDrawing(CanvasOutput(#G_ColorSelector))
    Box(0,0,hh,hh,RGB(255,255,255))    
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    DrawImage(ImageID(#IMAGE_ColorSelector),0,0)
    StopDrawing()
  EndIf    
  
  If StartDrawing(CanvasOutput(#G_ColorArcEnCiel))
    Box(0,0,ww,hh,RGB(255,255,255))    
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    DrawImage(ImageID(#IMAGE_ColorArcEnCiel),0,0)
    StopDrawing()
  EndIf 
  
  
EndMacro



; gadgets & updates gadgets
Procedure CreateToolPanel() ; to create the gadget for each tool when selected // pour créer les gadgets en fonction de l'outil choisi
  
  Shared ToolbarH  
  Shared PanelToolsW_IE, PanelToolsH_IE, PanelLayerW_IE, PanelLayerH_IE, BarAnimH_IE 
  Shared ScrolSwInt
  
  
  ClearGadgetItems(#G_PanelTool)
  ;   n = CountGadgetItems(#G_PanelTool)
  ;   For i = 0 To n
  ;     RemoveGadgetItem(#G_PanelTool,0)
  ;   Next i 
  
  
  OpenGadgetList(#G_PanelTool)
  ; add at least one panel item
  AddGadgetItem(#G_PanelTool,0, Lang("Gen"))
  
  
  ToolbarH = 30
  
  w = WindowWidth(#WinMain) - ScreenX
  h = WindowHeight(#WinMain) - 25 - ToolbarH
  
  h1 = 0 ; position in Y by default
  xx = 5 ; position in x by defaut
  wb = 55 ; width of some gadgets
  ub = 25 ; the height betwen two line of gagdets
  xb = wb+5+30 ; position for some gadgets
  xg = 2
  cbbh = 22 ; combobogadget height
  cbbw = 60 ; combobogadget width
  xa1 = 8
  wb2 = 40
  tbw = ScreenX-20-wb2-30
 
  
  ; to create the panel depending of the Action selected (brush, eraser, movelayer, transform layer....)
  Select Action
      
    Case #Action_Brush, #Action_eraser, #Action_Pen, #Action_CloneStamp
      ;{ Brush, eraser, pen, clone stamp
      
      
      ;AddGadgetItem(#G_PanelTool,0,Lang("Gen"))
      ;{ general parameters
      i = 0
      h1 = 10
      AddSTringTBGadget(#G_BrushSizeNameG, #G_BrushSizeTB, #G_BrushSizeSG, Brush(Action)\size,  lang("Size"), lang("Brush Size"),xx,h1+i,tbw,wb2,1,300) : i+25
      AddSTringTBGadget(#G_BrushAlphaNameG, #G_BrushAlphaTB, #G_BrushAlphaSG, Brush(Action)\Alpha,  lang("Alpha"), lang("Brush opacity"),xx,h1+i,tbw,wb2,1,255) : i+25
      AddSTringTBGadget(#G_BrushMixNameG, #G_BrushMixTB, #G_BrushMixSG, Brush(Action)\Mix,  lang("Mix"), lang("Brush Color mixing"),xx,h1+i,tbw,wb2,1,100) : i+25
      ;}
      
      ;{ Base parameters (size, image)
      AddGadgetItem(#G_PanelTool,-1, Lang("Base"))
      h1 = 0
      i=0
      If FrameGadget(#G_FrameSize,0,h1+3,ScreenX-15,75,Lang("Size"))
        i+20
      EndIf    
      AddSpinGadget(#G_BrushSize,Brush(Action)\size,lang("Brush Size"),xx,h1+i,wb,20,1,300,#PB_Spin_Numeric) : xx+wb+2
      AddSpinGadget(#G_BrushSizeMin,Brush(Action)\SizeMin,lang("Minimum Brush Size"),xx,h1+i,wb,20,1,300,#PB_Spin_Numeric) : xx+wb+2
      AddCheckBox(#G_BrushSizePressure,xx,h1+i,30,20,Lang("P"),Brush(Action)\sizepressure, lang("Size varie with Pressure"))    
      xx=5
      i+ub  
      AddSpinGadget(#G_BrushSizeW,Brush(Action)\SizeW,lang("Brush width"),xx,h1+i,wb,20,1,1000,#PB_Spin_Numeric) : xx+wb+2
      AddSpinGadget(#G_BrushSizeH,Brush(Action)\SizeH,lang("Brush height"),xx,h1+i,wb,20,1,1000,#PB_Spin_Numeric) : xx+wb+2
      AddCheckBox(#G_BrushSizeRand,xx,h1+i,25,20,Lang("R"),Brush(Action)\SizeRand,lang("Size Random"))
      i+ub + 10
      
      ; brush Shape (preview)
      If FrameGadget(#G_FrameBrushImage,0,h1+3+i,ScreenX-15,155,Lang("Shape"))
        i+20
      EndIf 
      If ImageGadget(#G_BrushPreview,ScreenX/2-60,h1+i,100,100,ImageID(#Img_PreviewBrush),#PB_Image_Border) 
        GadgetToolTip(#G_BrushPreview, lang("Clic to open the window brush image, to change the image of the tool (brush, eraser, pen...)"))
        UpdateBrushPreview()
      EndIf
      ;ButtonGadget(#G_BrushPrevious, 5,h1+i,15,105,"<")
      ;ButtonGadget(#G_BrushNext, GadgetX(#G_BrushPreview)+GadgetWidth(#G_BrushPreview)+3,h1+i,15,105,">") 
      i+110
      
      ComboBoxGadget(#G_BrushStrokeTyp,5,h1+i,65,cbbh)
      AddGadgetItem(#G_BrushStrokeTyp,0,lang("Image"))
      AddGadgetItem(#G_BrushStrokeTyp,1,lang("Circle"))
      GadgetToolTip(#G_BrushStrokeTyp, Lang("The brush shape"))
      SetGadgetState(#G_BrushStrokeTyp,0)
      
      AddCheckBox(#G_BrushTrim,75,h1+i,60,20,lang("Trim"),brush(action)\Trim, lang("Crop the image of the brush"))
      
      ;}
      
      If action=#Action_CloneStamp
        AddGadgetItem(#G_PanelTool,-1,Lang("Stamp"))
        i=3
        ; add parameter for source, alignment...
        ComboBoxGadget(#G_BrushSource,5,h1+i, 120,cbbh)
        AddGadgetItem(#G_BrushSource, -1, lang("Pattern"))
        AddGadgetItem(#G_BrushSource, -1, lang("Image"))
        SetGadgetState(#G_BrushSource, brush(action)\Source)
      EndIf
      
      
      AddGadgetItem(#G_PanelTool,-1,Lang("Tra"))
      ;{ alpha, aspect & flow
      i = 5
      If FrameGadget(#G_FrameAlpha,0,h1+3,ScreenX-15,80,Lang("Transparency"))
        i+20
      EndIf
      
      AddSpinGadget(#G_BrushAlpha,Brush(Action)\Alpha, lang("transparency of the brush"), xa1,h1+i,wb,20,0,255,#PB_Spin_Numeric)
      AddCheckBox(#G_BrushAlphaRand,GadgetX(#G_BrushAlpha)+wb+5,h1+i,ub,20, lang("Rand"),Brush(Action)\AlphaRand, lang("Transparency varie randomly"))    
      AddCheckBox(#G_BrushAlphaPressure,GadgetX(#G_BrushAlphaRand)+ub+5,h1+i,58,20, lang("Pressure"),Brush(Action)\alphaPressure, lang("Transparency varie with pressure"))    
      i+ub
      
      ; aspect
      If FrameGadget(#G_FrameAspect,0,h1+3+i,ScreenX-15,50,Lang("Aspect"))
        i+20
      EndIf 
      AddSpinGadget(#G_brushHardness, Brush(Action)\Hardness, lang("Hardness of the image"), 5,h1+i,wb,20,0,255,#PB_Spin_Numeric)
      AddSpinGadget(#G_brushSoftness, Brush(Action)\Softness, lang("Softness of the image"), 5+wb+xg,h1+i,wb,20,0,255,#PB_Spin_Numeric)
      CheckBoxGadget(#G_brushSmooth, 5+xg*2+wb*2,h1+i,65,20, lang("Smooth"))
      GadgetToolTip(#G_brushSmooth,lang("Smooth the image of the brush (or not).")) 
      i+ub+10
      ;}
      
      AddGadgetItem(#G_PanelTool,-1,Lang("Dyn"))
      ;{ dynamics
      i =5
      If FrameGadget(#G_FrameRot,0,h1+3,ScreenX-15,80,Lang("Rotation"))
        i+20
      EndIf   
      AddSpinGadget(#G_BrushRandRotate, Brush(Action)\randRot, lang("Random Rotation"),xa1,h1+i,wb,20,0,360,#PB_Spin_Numeric)
      i+ub    
      AddSpinGadget(#G_BrushRotate, Brush(Action)\rotate, lang("Rotation of the brush"),xa1,h1+i,wb,20,0,360,#PB_Spin_Numeric)
      AddCheckBox(#G_BrushRotateAngle,xa1+wb+5,h1+i,wb,20, lang("Angle"), Brush(Action)\RotateByAngle, lang("Rotate the brush in function of the Angle"))
      i+ub +10
      
      ; Stroke (trait)
      If FrameGadget(#G_FrameStroke,0,h1+3+i,ScreenX-15,75,Lang("Stroke"))
        i+20
      EndIf 
      AddSpinGadget(#G_BrushPas, Brush(Action)\pas, lang("Space between dots"), 5,h1+i,wb,20,0,1000,#PB_Spin_Numeric)
      AddSpinGadget(#G_brushIntensity, Brush(Action)\Intensity, lang("Intensity of the brush"), 5+xg+wb,h1+i,wb,20,-255,255,#PB_Spin_Numeric)
      i+ub
      
      If action <> #Action_CloneStamp
        ComboBoxGadget(#G_BrushStroke,5,h1+i,65,cbbh)
        AddGadgetItem(#G_BrushStroke,0,lang("Rough"))
        AddGadgetItem(#G_BrushStroke,1,Lang("Knife"))
        AddGadgetItem(#G_BrushStroke,2,Lang("Dash"))
        AddGadgetItem(#G_BrushStroke,3,Lang("Line"))
        AddGadgetItem(#G_BrushStroke,4,Lang("Gersam"))
        GadgetToolTip(#G_BrushStroke,Lang("Choose the type of curve for the stroke"))
        SetGadgetState(#G_BrushStroke,0)
        w2= GadgetWidth(#G_BrushStroke)
      EndIf
      AddCheckBox(#G_brushTrait, 5+xg+w2,h1+i,50,20, lang("Stroke"),Brush(Action)\Trait, lang("Use stroke for the brush")) 

      i+ub+10   
      
      ; Scater
      If FrameGadget(#G_FrameScatter,0,h1+3+i,ScreenX-15,50,Lang("Scatter"))
        i+20
      EndIf   
      AddSpinGadget(#G_BrushScatter, Brush(Action)\scatter, lang("Brush Scatter"), xa1,h1+i,wb,20,0,100,#PB_Spin_Numeric)
      i+ub+10
      
      
      If FrameGadget(#G_FrameMisc,0,h1+3+i,ScreenX-15,70,Lang("Misc"))
        i+20
      EndIf 
      ComboBoxGadget(#G_BrushSymetry,xa1,h1+i,70,20)
      GadgetToolTip(#G_BrushSymetry, Lang("Symetry"))
      SetGadgetState(#G_BrushSymetry, Brush(Action)\symetry)
      AddGadgetItem(#G_BrushSymetry,0, Lang("Inactive"))
      AddGadgetItem(#G_BrushSymetry,1, Lang("Vertical"))
      AddGadgetItem(#G_BrushSymetry,2, Lang("Horizontal"))
      AddGadgetItem(#G_BrushSymetry,3, Lang("Hor & Vert"))
      AddGadgetItem(#G_BrushSymetry,4, Lang("4 views"))
      SetGadgetState(#G_BrushSymetry,0)
     
      AddSpinGadget(#G_BrushFilter,Brush(Action)\filter, lang("Set the filter Type parameter (if used)"),xa1+2+GadgetWidth(#G_BrushSymetry),
                    h1+i,50,20,0,250,#PB_Spin_Numeric)
       i+ub
      ;}
      
      AddGadgetItem(#G_PanelTool,-1,Lang("Col"))
      ;{ color
      i =5
      If FrameGadget(#G_FrameColor,0,h1+3,ScreenX-15,110,Lang("Color"))
        i+20
      EndIf   
      AddSpinGadget(#G_BrushMix, Brush(Action)\mix,lang("Mixing color"), 5,h1+i,wb,20,0,100,#PB_Spin_Numeric)
      AddSpinGadget(#G_BrushVisco, Brush(Action)\Visco,lang("Viscosity"), 5+wb+2,h1+i,wb,20,0,1000,#PB_Spin_Numeric)
      AddCheckBox(#G_BrushLavage,5+wb*2+4,h1+i,45,20,lang("Wash"),Brush(Action)\Wash,lang("Wash the brush after paint"))
      i+ub
      ComboBoxGadget(#G_BrushMixLayer,5,h1+i,70,cbbh); ,"Inverse Mix",Brush(Action)\MixType,"Inverse the type of mixing")
      AddGadgetItem(#G_BrushMixLayer,0, Lang("All above"))
      AddGadgetItem(#G_BrushMixLayer,1, Lang("Layer Only"))
      AddGadgetItem(#G_BrushMixLayer,2, Lang("All layers"))
      ; AddGadgetItem(#G_BrushMixLayer,3, "Custom")
      GadgetToolTip(#G_BrushMixLayer,Lang("Define the layers to pick the colors"))
      SetGadgetState(#G_BrushMixLayer,brush(action)\MixLayer)
      ;ButtonGadget(#G_BrushMixLayerCustom,80,h1+i,20,20,"+")
      ;GadgetToolTip(#G_BrushMixLayerCustom,"Define the layers to pick the color. Only available if 'custom' is choose to define the layers for color mixing")
      i+ub
      
      ;AddCheckBox(#G_BrushMixTyp,5,h1+i,70,20,"Inverse Mix",Brush(Action)\MixType,"Inverse the type of mixing")
      ComboBoxGadget(#G_BrushMixTyp,5,h1+i,70,20); ,"Inverse Mix",Brush(Action)\MixType,"Inverse the type of mixing")
      GadgetToolTip(#G_BrushMixTyp, Lang("Choose the color blending type"))
      AddGadgetItem(#G_BrushMixTyp,0, Lang("Classic"))
      AddGadgetItem(#G_BrushMixTyp,1, Lang("Inverse"))
      AddGadgetItem(#G_BrushMixTyp,2, Lang( "Old"))
      AddGadgetItem(#G_BrushMixTyp,3, Lang("New"))
      SetGadgetState(#G_BrushMixTyp,brush(action)\MixType)
      i+ub + ub
      
      If FrameGadget(#G_FrameWater,0,i+h1+3,ScreenX-15,110, Lang("Water"))
        i+20
        AddSpinGadget(#G_BrushWater, Brush(Action)\Water,"Add water", 5,h1+i,wb,20,0,100,#PB_Spin_Numeric)
        
      EndIf 
      
      ;}
      
      ;}
      
    Case #Action_Fill
      ;{ fillarea
      If FrameGadget(#G_FrameSize,0,h1+3,ScreenX-15,80,Lang("Options"))
        i+20
        AddSpinGadget(#G_ActionY,Brush(action)\Alpha,lang("Set the transparency"),5,h1+i,wb,20,-100000,100000,#PB_Spin_Numeric)
        i+ub
        ; AddSpinGadget(#G_ActionX,Brush(action)\Size,lang("Tolerance"),5,h1+i,wb,20,1,500,#PB_Spin_Numeric)
      EndIf
      ;}
      
    Case #Action_Box, #Action_Circle, #Action_Line
      ;{
      If FrameGadget(#G_FrameSize,0,h1+3,ScreenX-15,50,Lang("Size"))
        i+20
        sizmin = 0
        Select  action 
          Case #Action_Box
            txt1$ = lang("Size of the round")
          Case #Action_Line
            txt1$ = lang("Size of the line")
            sizmin = 1
          Case #Action_Circle
            txt1$ = lang("Size of the line")
        EndSelect
        AddSpinGadget(#G_ActionX,Brush(action)\size,txt1$,5,h1+i,wb,20,sizmin,500,#PB_Spin_Numeric)
        ; AddSpinGadget(#G_LayerY,Brush(action)\AlphaFG,"Foreground Alpha",5+wb+xg,h1+i,wb,20,-100000,100000,#PB_Spin_Numeric)
        i+ub+15
        
      EndIf
      If FrameGadget(#G_FrameAlpha,0,h1+3+i,ScreenX-15,50,Lang("Transparency"))
        i+20          
        AddSpinGadget(#G_ActionY,Brush(action)\Alpha,lang("Set the transparency"),5,h1+i,wb,20,0,255,#PB_Spin_Numeric)
        If action <> #Action_Line   
          AddSpinGadget(#G_ShapeParam1,Brush(action)\AlphaFG, lang("Foreground Alpha"),5+wb+xg,h1+i,wb,20,0,255,#PB_Spin_Numeric)
        EndIf   
        i+ub+15    
      EndIf
      
      If FrameGadget(#G_FrameAspect,0,h1+3+i,ScreenX-15,90,Lang("Options"))
        i+20 
        If action = #Action_Line            
          ;AddCheckBox(#G_LayerXLock,xx,h1+i,58,20,Lang("Proportion"),OptionsIE\lockX,"Keep proportion") : i + 20   
          ;AddCheckBox(#G_LayerYLock,xx,h1+i,58,20,Lang("Lock Y"),OptionsIE\lockY,"Lock Y Direction") : i + 20 
          ;AddCheckBox(#G_LayerBorder,xx,h1+i,58,20,Lang("Layer border"),OptionsIE\lockY,"See layer border")    
          ;AddCheckBox(#G_ConfirmAction,xx,h1+i,Len(Lang("Confirm action"))*6+5,20,Lang("Confirm action"),OptionsIE\ConfirmAction,"Confirm action ?")    
          ComboBoxGadget(#G_ActionTyp,5,h1+i,100,20)
          AddGadgetItem(#G_ActionTyp,0, Lang("Linear"))
          AddGadgetItem(#G_ActionTyp,1, Lang("Radial"))
          AddGadgetItem(#G_ActionTyp,2, Lang("Speed"))
          SetGadgetState(#G_ActionTyp, Brush(action)\type)
          
        Else
          ; AddCheckBox(#G_ActionW,xx,h1+i,58,20,Lang("Outlined"),OptionsIE\ShapeParam,"Use outlined") : i + 20  
          AddSpinGadget(#G_ActionH,Brush(action)\ShapeOutSize,"Set the thick of the outline",5,h1+i,wb,20,0,255,#PB_Spin_Numeric)
          ; AddCheckBox(#G_ActionTyp,1,"Radial")
        EndIf    
      EndIf
      ;}
      
    Case #Action_Gradient
      ;{
      If FrameGadget(#G_FrameSize,0,h1+3,ScreenX-15,50,Lang("Transparency"))
        i+20          
        AddSpinGadget(#G_ActionX, Brush(action)\Alpha, lang("Background Alpha"),5,h1+i,wb,20,0,255,#PB_Spin_Numeric)
        AddSpinGadget(#G_ActionY, Brush(action)\AlphaFG, lang("Foreground Alpha"),5+wb+xg,h1+i,wb,20,0,255,#PB_Spin_Numeric)
        i+ub+15        
      EndIf
      If FrameGadget(#G_FrameAspect,0,h1+3+i,ScreenX-15,60,Lang("Gradient"))
        i+20  
        ComboBoxGadget(#G_ActionTyp,5,h1+i,100,cbbh)
        AddGadgetItem(#G_ActionTyp,0, Lang("Linear"))
        AddGadgetItem(#G_ActionTyp,1, Lang("Circular"))
        AddGadgetItem(#G_ActionTyp,2, Lang("Elliptic"))
        AddGadgetItem(#G_ActionTyp,3, Lang("Conical"))
        AddGadgetItem(#G_ActionTyp,4, Lang("Boxed"))
        SetGadgetState(#g_actionTyp, Brush(action)\type)
        i+ub+15
      EndIf
      
      If FrameGadget(#G_FrameAlpha,0,h1+3+i,ScreenX-15,90,Lang("Options"))
        i+20          
        AddCheckBox(#G_ActionXLock,xx,h1+i,100,20, lang("Proportion"),OptionsIE\lockX, lang("Keep proportion")) : i + 20   
        ;AddCheckBox(#G_ActionYLock,xx,h1+i,58,20,Lang("Lock Y"),OptionsIE\lockY,"Lock Y Direction") : i + 20 
        ;  AddCheckBox(#G_ActionBorder,xx,h1+i,58,20,Lang("Layer border"),OptionsIE\lockY,"See layer border")    
        AddCheckBox(#G_ConfirmAction,xx,h1+i,Len(Lang("Confirm action"))*7+20,20, lang("Confirm action"),OptionsIE\ConfirmAction, lang("Confirm action ?"))    
      EndIf    
      
      ;}
      
    Case #Action_Transform
      ;{ 
      If FrameGadget(#G_FrameSize,0,h1+3,ScreenX-15,50,Lang("Size"))
        i+20
        AddSpinGadget(#G_ActionX,Layer(Layerid)\w,lang("Layer Width"),5,h1+i,wb+10,20,-100000,100000,#PB_Spin_Numeric)
        AddSpinGadget(#G_ActionY,Layer(Layerid)\h,lang("Layer Height"),5+wb+10+xg,h1+i,wb+10,20,-100000,100000,#PB_Spin_Numeric)
        i + ub+15
      EndIf
      If FrameGadget(#G_FrameAlpha,0,h1+3+i,ScreenX-15,110,Lang("Options"))
        i+20          
        AddCheckBox(#G_ActionXLock,xx,h1+i,Len(Lang("Proportion"))*7+5,20,Lang("Proportion"),OptionsIE\lockX,lang("Keep proportion")) : i + 20   
        ;AddCheckBox(#G_ActionYLock,xx,h1+i,58,20,Lang("Lock Y"),OptionsIE\lockY,"Lock Y Direction") : i + 20 
        ;  AddCheckBox(#G_ActionBorder,xx,h1+i,58,20,Lang("Layer border"),OptionsIE\lockY,"See layer border")    
        AddCheckBox(#G_ConfirmAction,xx,h1+i,Len(Lang("Confirm action"))*7+5,20,Lang("Confirm action"),OptionsIE\ConfirmAction, lang("Confirm action ?"))  : i + 20      
        AddCheckBox(#G_ActionFullLayer,xx,h1+i,Len(Lang("All viewed layers"))*7+5,20,Lang("All viewed layers"),OptionsIE\ActionForAllLayers,lang("Transform all viewed layers"))    
      EndIf    
      ;}
      
    Case #Action_Rotate
      ;{ 
      If FrameGadget(#G_FrameSize,0,h1+3,ScreenX-15,50,Lang("Rotation"))
        i+20
        AddSpinGadget(#G_ActionX,Layer(Layerid)\Angle, lang("Angle"),5,h1+i,wb,20,-360,360,#PB_Spin_Numeric)
        ;AddSpinGadget(#G_ActionY,Layer(Layerid)\h,"Layer Height",5+wb+xg,h1+i,wb,20,-100000,100000,#PB_Spin_Numeric)
        i + ub+15
      EndIf
      If FrameGadget(#G_FrameAlpha,0,h1+3+i,ScreenX-15,90,Lang("Options"))
        i+20          
        ;AddCheckBox(#G_ActionXLock,xx,h1+i,58,20,Lang("Proportion"),OptionsIE\lockX,"Keep proportion") : i + 20   
        ;AddCheckBox(#G_ActionYLock,xx,h1+i,58,20,Lang("Lock Y"),OptionsIE\lockY,"Lock Y Direction") : i + 20 
        ;  AddCheckBox(#G_ActionBorder,xx,h1+i,58,20,Lang("Layer border"),OptionsIE\lockY,"See layer border")    
        AddCheckBox(#G_ConfirmAction,xx,h1+i,Len(Lang("Confirm action"))*7+5,20,Lang("Confirm action"),OptionsIE\ConfirmAction,lang("Confirm action ?")) : i + 20      
        AddCheckBox(#G_ActionFullLayer,xx,h1+i,Len(Lang("All viewed layers"))*7+5,20,Lang("All viewed layers"),OptionsIE\ActionForAllLayers,lang("Rotate all viewed layers"))
      EndIf    
      ;}
      
    Case #Action_Move
      ;{
      If FrameGadget(#G_FrameSize,0,h1+3,ScreenX-15,50,Lang("Position"))
        i+20
        
        AddSpinGadget(#G_ActionX,Layer(Layerid)\x,lang("Layer X position"),5,h1+i,wb,20,-100000,100000,#PB_Spin_Numeric)
        AddSpinGadget(#G_ActionY,Layer(Layerid)\y,lang("Layer y Position"),5+wb+xg,h1+i,wb,20,-100000,100000,#PB_Spin_Numeric)
        i + ub+15
      EndIf
      If FrameGadget(#G_FrameAlpha,0,h1+3+i,ScreenX-15,110,Lang("Options"))
        i+20          
        AddCheckBox(#G_ActionXLock,xx,h1+i,58,20, lang("Lock X"),OptionsIE\lockX, lang("Lock X Direction")) : i + 20   
        AddCheckBox(#G_ActionYLock,xx,h1+i,58,20, lang("Lock Y"),OptionsIE\lockY, lang("Lock Y Direction")) : i + 20 
        ;  AddCheckBox(#G_ActionBorder,xx,h1+i,58,20,Lang("Layer border"),OptionsIE\lockY,"See layer border")    
        AddCheckBox(#G_ConfirmAction,xx,h1+i,Len(Lang("Confirm action"))*7+5,20,Lang("Confirm action"),OptionsIE\ConfirmAction,lang("Confirm action ?"))   : i + 20   
        AddCheckBox(#G_ActionFullLayer,xx,h1+i,Len(Lang("All viewed layers"))*7+5,20,Lang("All viewed layers"),OptionsIE\ActionForAllLayers,lang("Move all viewed layers"))    
      EndIf    
      
      ;}
      
    Case #Action_Select
      ;{
;       If FrameGadget(#G_FrameSize,0,h1+3,ScreenX-15,50,Lang("Options"))
;         i+20
;         AddSpinGadget(#G_ActionX, 0, lang("X position"),5,h1+i,wb,20,-100000,100000,#PB_Spin_Numeric)
;         AddSpinGadget(#G_ActionY, 0, lang("y Position"),5+wb+xg,h1+i,wb,20,-100000,100000,#PB_Spin_Numeric)
;         i + ub+15
;       EndIf     
      If FrameGadget(#G_FrameAspect,0,h1+3+i,ScreenX-15,60,Lang("Type"))
        i+20  
        ComboBoxGadget(#G_ActionTyp,5,h1+i, 100, cbbh)
        AddGadgetItem(#G_ActionTyp,0, Lang("Rectangle"))
        AddGadgetItem(#G_ActionTyp,1, Lang("Circle"))
        ;  AddGadgetItem(#G_ActionTyp,2, Lang("All layers above")) wip, to be finished
        SetGadgetState(#G_ActionTyp, brush(#Action_Select)\type)
        GadgetToolTip(#G_ActionTyp, Lang("Define the type of selection"))
        i+ub+15
      EndIf
      ;}
      
    Case #action_pipette
      ;{ 
      If FrameGadget(#G_FrameAspect,0,h1+3+i,ScreenX-15,60,Lang("Type"))
        i+20  
        ComboBoxGadget(#G_ActionTyp,5,h1+i, 100, cbbh)
        AddGadgetItem(#G_ActionTyp,0, Lang("Layer only"))
        AddGadgetItem(#G_ActionTyp,1, Lang("All layers"))
        ;  AddGadgetItem(#G_ActionTyp,2, Lang("All layers above")) wip, to be finished
        SetGadgetState(#G_ActionTyp, brush(#action_pipette)\type)
        GadgetToolTip(#G_ActionTyp, Lang("Define the layers to pick the colors"))
        i+ub+15
      EndIf
      ;}
      
    Case #Action_Zoom
      ;{
      If FrameGadget(#G_FrameSize, 0, h1+3, ScreenX-15, 50, Lang("Zoom center"))
        i+20
        ComboBoxGadget(#G_ActionTyp,5,h1+i, 100, cbbh)
        AddGadgetItem(#G_ActionTyp,0, Lang("Default (0,0)"))
        AddGadgetItem(#G_ActionTyp,1, Lang("Zoom on mouse"))
        AddGadgetItem(#G_ActionTyp,2, Lang("Center of canvas"))
        SetGadgetState(#G_ActionTyp, brush(#Action_Zoom)\type)
        GadgetToolTip(#G_ActionTyp, Lang("Define the center for the zoom"))
        i + ub+15
      EndIf
      ;}
      
  EndSelect
  
  CloseGadgetList()
  
  
  ; change the color, in function of the tools
  If action < #Action_Line Or action > #Action_Fill
    Brush(action)\color = Brush(#Action_Brush)\color
    Brush(action)\Col\R = Brush(#Action_Brush)\Col\R
    Brush(action)\Col\G = Brush(#Action_Brush)\Col\G
    Brush(action)\Col\B = Brush(#Action_Brush)\Col\B
    Brush(action)\ColorFG = Brush(#Action_Brush)\ColorFG
  EndIf
  
  
  
  
EndProcedure
Procedure UpdateUIShowHide(fullUi=0, update=1)
  
  ; to update the UI (show/hide panel)
  
  ; check if we hide full UI (with tab for example)
  If fullUi = 1
    OptionsIE\ShowPanelColors   = OptionsIE\ShowFullUI
    OptionsIE\ShowPanelToolparameters = OptionsIE\ShowFullUI
    OptionsIE\ShowPanelLayers   = OptionsIE\ShowFullUI
    OptionsIE\ShowPanelswatchs  = OptionsIE\ShowFullUI
  EndIf
  
  
  ; splitters left
  If OptionsIE\ShowPanelToolparameters Or OptionsIE\ShowPanelColors
    HideGadget(#G_SplitToolCol, 0)
  ElseIf OptionsIE\ShowPanelToolparameters= 0 And OptionsIE\ShowPanelColors = 0
    HideGadget(#G_SplitToolCol, 1)
  EndIf
  
  ; Panel colors
  HideGadget(#G_PanelCol, 1-OptionsIE\ShowPanelColors)
  SetMenuItemState(#Menu_Main, #menu_ShowColor, OptionsIE\ShowPanelColors)
  
  ;  tools parameters
  HideGadget(#G_PanelTool, 1-OptionsIE\ShowPanelToolparameters)
  SetMenuItemState(#Menu_Main, #menu_ShowToolParameters, OptionsIE\ShowPanelToolparameters)
  
  
  ; splitters Right
  If OptionsIE\ShowPanelLayers Or OptionsIE\ShowPanelswatchs
    HideGadget(#G_SplitLayerRB, 0)
  ElseIf OptionsIE\ShowPanelLayers= 0 And OptionsIE\ShowPanelswatchs = 0
    HideGadget(#G_SplitLayerRB, 1)
  EndIf
  
  ; panel layer
  HideGadget(#G_PanelLayer, 1-OptionsIE\ShowPanelLayers)
  SetMenuItemState(#Menu_Main, #menu_ShowLayers, OptionsIE\ShowPanelLayers)
  
  ; panel swatch
  HideGadget(#G_PanelSwatch, 1-OptionsIE\ShowPanelswatchs)
  SetMenuItemState(#Menu_Main, #menu_ShowSwatchs, OptionsIE\ShowPanelswatchs)
  
  
  ; then update the canvas/screen size 
  If update 
    IE_UpdateGadget(0)
  EndIf

EndProcedure
Procedure IE_GadgetAdd()
  
  ; procédure qui sert à ajouter les gadgets (panel, toolbar...) au lancement de l'application
  
  Shared ToolbarH  
  Shared PanelToolsW_IE, PanelToolsH_IE, PanelLayerW_IE, PanelLayerH_IE, BarAnimH_IE 
  Shared ScrolSwInt
  
  
  ToolbarH = OptionsIE\ToolbarH -6 
  If toolbarH <= 10
    toolbarH = 30
  EndIf
  
  wp1 = 175
  
  w = WindowWidth(#WinMain) - wp1 ; ScreenX
  h = WindowHeight(#WinMain) - 25 - ToolbarH
  
  h1 = 0
  xx = 5
  wb = 45
  ub = 25
  xb = 80
  xg = 2
  bw = 22
  
  ; toolbar top :: toolbar du haut
  If ContainerGadget(#G_ToolBar, 0, -1, W+ScreenX, ToolBarH, #PB_Container_BorderLess)
    
    SetGadgetColor(#G_ToolBar,#PB_Gadget_BackColor,OptionsIE\ThemeGadCol)
    
    siz = ToolBarH -2
    u = 2
    
    ComboBoxGadget(#G_IE_Type,  xx, (ToolBarH - 24)/2, 70, 22)
    
    AddGadgetItem(#G_IE_Type, #ToolType_Brush,  Lang("Brush"))
    AddGadgetItem(#G_IE_Type, #ToolType_Pen,    Lang("Pen"))
    AddGadgetItem(#G_IE_Type, #ToolType_Eraser, Lang("Eraser"))
    AddGadgetItem(#G_IE_Type, #ToolType_Light,  LAng("Light"))
    AddGadgetItem(#G_IE_Type, #ToolType_Dark,   Lang("Dark"))
    AddGadgetItem(#G_IE_Type, #ToolType_Color,  Lang("Color"))
    AddGadgetItem(#G_IE_Type, #ToolType_Shape,  Lang("Shape"))
    AddGadgetItem(#G_IE_Type, #ToolType_Water,  Lang("Water"))
    AddGadgetItem(#G_IE_Type, #ToolType_Smudge, Lang("Smudge") )
    AddGadgetItem(#G_IE_Type, #ToolType_Glass,  Lang("Glass") )   
    AddGadgetItem(#G_IE_Type, #ToolType_Noise,  Lang("Noise") )   
    AddGadgetItem(#G_IE_Type, #ToolType_Pixel,  Lang("Pixel") )   
    AddGadgetItem(#G_IE_Type, #ToolType_Blur,   Lang("Blur"))    
    AddGadgetItem(#G_IE_Type, #ToolType_Sol,    Lang("Solarize") )   
    AddGadgetItem(#G_IE_Type, #ToolType_Line,   Lang("Line") )   
    
    GadgetToolTip(#G_IE_Type, Lang("Filter of the brush."))
    SetGadgetState(#G_IE_Type, Brush(Action)\Type)
    
    xx + GadgetWidth(#G_IE_Type) +10
    xx = IE_InsertBar(xx)
    
    yy = 0
    
    IE_btn2(#G_IE_Pen,        #ico_IE_Pen,        Lang("Pen")+" (P)")
    IE_btn2(#G_IE_Brush,      #ico_IE_Brush,      Lang("Brush")+" (B)")
    IE_btn2(#G_IE_Spray,      #ico_IE_Spray,      Lang("Spray")+" (S)")
    IE_btn2(#G_IE_Tampon,     #ico_IE_Tampon,     LAng("Clone stamp tool")+" (T)")
    IE_btn2(#G_IE_Particles,  #ico_IE_Particles,  Lang("Particles")+" (P)")
    
    xx = IE_InsertBar(xx)
    IE_btn2(#G_IE_Line,       #ico_IE_Line,       Lang("Line"))
    IE_btn2(#G_IE_Box,        #ico_IE_Box,        Lang("Box"))
    IE_btn2(#G_IE_Circle,     #ico_IE_Circle,     Lang("Ellipse"))
    IE_btn2(#G_IE_Shape,      #ico_IE_Shape,      Lang("Shape"))
    
    xx = IE_InsertBar(xx)
    IE_btn2(#G_IE_Fill,       #ico_IE_Fill,       Lang("Fill bucket")+" (K)")
    IE_btn2(#G_IE_Gradient,   #ico_IE_Gradient,   Lang("Gradient")+" (G)")
    
    xx = IE_InsertBar(xx)
    IE_btn2(#G_IE_Text,       #ico_IE_Text,       Lang("Text")+" (T)")
    
    xx = IE_InsertBar(xx)
    IE_btn2(#G_IE_Eraser,     #ico_IE_Eraser,     Lang("Eraser")+" (E)")
    IE_btn2(#G_IE_Clear,      #ico_IE_Clear,      Lang("Clear")+" (Ctrl +W)",1,0)
    
    xx = IE_InsertBar(xx)
    IE_btn2(#G_IE_Pipette,    #ico_IE_Pipette,    Lang("Pick color"))
    
    
    
    xx = IE_InsertBar(xx)
    IE_btn2(#G_IE_Move,       #ico_IE_Move,       Lang("Move tool")+" (V)")
    IE_btn2(#G_IE_Transform,  #ico_IE_Scale,      Lang("Transform tool")+" (Ctrl+T)")
    IE_btn2(#G_IE_Rotate,     #ico_IE_Rotate,     Lang("Rotate tool")+" (R)")
    
    IE_btn2(#G_IE_Select,     #ico_IE_Select,     Lang("Selection tool")+" (M)")
    
    IE_btn2(#G_IE_Hand,       #ico_IE_Hand,       Lang("Hand tool") + " (H)")
    IE_btn2(#G_IE_Zoom,       #ico_IE_Zoom,       Lang("Zoom")+" (Ctrl clic, ctrl +/- ) (Z)")
    
    ; on modifie le bouton du tool actif
    For i =#G_IE_Pen To #G_IE_Zoom
      If Action = i - #G_IE_Pen
        SetGadgetState(i,1)
        Break
      EndIf
    Next i
    
    CloseGadgetList()
  EndIf
  
  
  ; panel tool parameters
  ;If ContainerGadget(#G_Cont_Brush,0,ToolbarH,ScreenX-5,PanelToolsH_IE) 
  If PanelGadget(#G_PanelTool, 0, ToolbarH, wp1, PanelToolsH_IE) ;h-25)
    SetGadgetColor(#G_PanelTool,#PB_Gadget_BackColor,OptionsIE\ThemeGadCol)
    CloseGadgetList()
    CreateToolPanel() ; create the panel tool (action dy default = brush, so the panel with the brush parameters are created
  EndIf
  ;CloseGadgetList()
  ;EndIf
  
  
  ; panel colors
  If PanelGadget(#G_PanelCol, 0, toolbarH+PanelToolsH_IE+5, wp1, H-25-PanelToolsH_IE)
    
    SetGadgetColor(#G_PanelCol, #PB_Gadget_BackColor, OptionsIE\ThemeGadCol)
    AddGadgetItem(#g_PanelCol, 0, Lang("Color"))
    ; color
    xa=20
    ColW = 48
    i=5
    ImageGadget(#G_BrushColorBG,5+xa,h1+i,ColW,ColW,ImageID(#ImageColorBG),#PB_Image_Border)
    GadgetToolTip(#G_BrushColorBG,lang("Background color"))
    ImageGadget(#G_BrushColorFG,5+colW+xa+5,h1+i,ColW,ColW,ImageID(#ImageColorFG),#PB_Image_Border) 
    GadgetToolTip(#G_BrushColorFG, lang("Foreground color"))
    UpdateColorImageBG_FG()
    i+60
    
    CreateColorSelector()
    
    AddGadgetItem(#g_PanelCol,1,Lang("Gradient"))
    
    
    
    CloseGadgetList()
  EndIf
  
  h = WindowHeight(#WinMain) -50-ToolbarH
  If SplitterGadget(#G_SplitToolCol, 0, ToolbarH, wp1, h, #G_PanelTool, #G_PanelCol) : EndIf
  
  
  ; canvas preview renderings & drawings
  If CanvasGadget(#G_CanvasMain, ScreenX-100000*(1-OptionsIE\UseCanvas), ScreenY, CanvasW, CanvasH, 
                  #PB_Canvas_Border|#PB_Canvas_Keyboard)
    
  EndIf
  
  
  ; panel layer, presets, options (paper)
  If PanelGadget(#G_PanelLayer, 0, 0, wp1-5, PanelLayerH_IE)
    
    SetGadgetColor(#G_PanelLayer,#PB_Gadget_BackColor,OptionsIE\ThemeGadCol)
    
    AddGadgetItem(#G_PanelLayer,0,Lang("Layers"))
    ;{ layers
    yy=5
    i =5
    If ComboBoxGadget(#G_LayerBM, i, yy, 100, 20) : yy=yy+25
      
      AddGadgetItem(#G_LayerBM, #SetBm_normal, lang("Normal"))
      
      AddGadgetItem(#G_LayerBM, #SetBm_Darken, Lang("Darken"))
      AddGadgetItem(#G_LayerBM, #SetBm_multiply, Lang("Multiply"))
      AddGadgetItem(#G_LayerBM, #SetBm_ColorBurn, Lang("ColorBurn"))
      AddGadgetItem(#G_LayerBM, #SetBm_LinearBurn, Lang("LinearBurn"))
      
      AddGadgetItem(#G_LayerBM, #SetBm_Add, Lang("Additive"))
      AddGadgetItem(#G_LayerBM, #SetBm_Screen, Lang("Screen"))
      AddGadgetItem(#G_LayerBM, #SetBm_Lighten, Lang("Lighten"))
      AddGadgetItem(#G_LayerBM, #SetBm_ClearLight, Lang("Clearlight"))
      
      AddGadgetItem(#G_LayerBM, #Setbm_Overlay, Lang("Overlay"))
      AddGadgetItem(#G_LayerBM, #SetBm_LinearLight, Lang("LinearLight"))
      
      
      AddGadgetItem(#G_LayerBM, #SetBm_Invert, Lang("Inverse"))
      If OptionsIE\Debbug = 1
        AddGadgetItem(#G_LayerBM, #SetBm_custom, "Custom")
      EndIf
      ;AddGadgetItem(#G_LayerBM, -1, "Dissolve")
      ;AddGadgetItem(#G_LayerBM, -1, "Difference")
      ;AddGadgetItem(#G_LayerBM, -1, "Exclusion")
      ;AddGadgetItem(#G_LayerBM, -1, "Hardlight")
      ;AddGadgetItem(#G_LayerBM, -1, "Colorlight")
      
      GadgetToolTip(#G_LayerBM, Lang("Blending Mode"))
    EndIf
    
    ;AddCheckBox(#G_LayerView,i,yy,40,20,"View",1,"To set the visibility of the layer")      
    ;AddCheckBox(#G_LayerLocked,i+40,yy,40,20,"Lock",0,"To lock the layer")  ; : yy=yy+25
    ;AddCheckBox(#G_LayerAlphaLock,i+80,yy,60,20,"Alpha Lock", 0,"To lock the alpha of the layer. When you paint, you only change the color")  : yy=yy+25
    
    If TrackBarGadget(#G_LayerAlpha,i-2,yy,100,20,0,255)
      GadgetToolTip(#G_LayerAlpha,Lang("Layer Alpha"))
    EndIf
    AddSpinGadget(#G_LayerAlphaSpin,255, lang("Layer Opacity"),GadgetX(#G_LayerAlpha)+GadgetWidth(#G_LayerAlpha),yy,43,20,0,255,#PB_Spin_Numeric)
    yy=yy+25
    
    IE_Btn1(#G_LayerView,         #ico_LayerView,       lang("View layer"))  : i+ub
    IE_Btn1(#G_LayerLockAlpha,    #ico_LayerLockAlpha,  lang("Lock Alpha"))  : i+ub
    IE_Btn1(#G_LayerLockMove,     #ico_LayerLockMove,   lang("Lock Move"))   : i+ub
    IE_Btn1(#G_LayerLockPaint,    #ico_LayerLockPaint,  lang("Lock Paint"))  : i+ub
    IE_Btn1(#G_LayerLocked,       #ico_LayerLocked,     lang("Lock Layer"))  : i+ub
    yy + 25
    i = 5
    
    
    
    w1 = PanelLayerH_IE - yy -10 +20
    If w1> 220
      w1 = 220
    EndIf
    
    If ScrollAreaGadget(#G_LayerList, i, yy, ScreenX-25, w1-20, ScreenX-45, 200, 10, #PB_ScrollArea_Single) 
      If CanvasGadget(#G_LayerListCanvas, 0, 0, ScreenX-20, 200)
      EndIf
      CloseGadgetList()
    EndIf      
    yy+GadgetHeight(#G_LayerList)+5
    
    
    
    ; If ListViewGadget(#G_LayerList, i,yy,ScreenX-30,w1-20) : yy=yy+210 : EndIf
    ;If ScrollAreaGadget(#G_Layer,10,yy,130,w1-20,108,w1)
    ; ListViewGadget(#G_LayerList, 0,0,108,w1) : yy=yy+210
    ;CloseGadgetList()
    ;EndIf
    
    wbtn=bw + 1
    
    If ButtonGadget(#G_LayerAdd,i,yy,bw,bw,"+") : i+wbtn : EndIf
    If ButtonGadget(#G_LayerDel,i,yy,bw,bw,"-") : i+wbtn : EndIf
    AddButonImage(#G_LayerMoveup,   i,yy,bw,bw,#ico_LayerUp,    #PB_Button_Default, lang("Move the layer up"))   : i+wbtn
    AddButonImage(#G_LayerMovedown, i,yy,bw,bw,#ico_LayerDown,  #PB_Button_Default, lang("Move the layer down")) : i+wbtn
    AddButonImage(#G_LayerMaskAlpha,i,yy,bw,bw,#ico_LayerMask,  #PB_Button_Default, lang("Add A mask alpha"))    : i+wbtn
    AddButonImage(#G_LayerProp,     i,yy,bw,bw,#ico_Prop,       #PB_Button_Default, lang("Layer Properties"))    : i+wbtn
    yy + 25
    If OptionsIE\Debbug = 1
      AddSpinGadget(#G_layerbm1,blend1,"",10,yy,40,20,#PB_Sprite_BlendZero,#PB_Sprite_BlendInvertDestinationAlpha,#PB_Spin_Numeric)
      AddSpinGadget(#G_layerbm2,blend2,"",60,yy,40,20,#PB_Sprite_BlendZero,#PB_Sprite_BlendInvertDestinationAlpha,#PB_Spin_Numeric)
    EndIf
    ;}
    
    
    AddGadgetItem(#G_PanelLayer, 1, Lang("Presets"))
    ;{ presets
    xx= 5
    AddButonImage(#G_PresetReloadBank,xx,10,bw,bw,#ico_Merge,   #PB_Button_Default, lang("Refresh the bank presets"))  : xx+wbtn
    AddButonImage(#G_PresetChangeBank,xx,10,bw,bw,#ico_Open,    #PB_Button_Default, lang("Open a bank presets"))       : xx+wbtn
    AddButonImage(#G_PresetSavePreset,xx,10,bw,bw,#ico_Save,    #PB_Button_Default, lang("Save the current preset") )  : xx+wbtn
    AddButonImage(#G_PresetSavePresetAs,xx,10,bw,bw,#ico_Export,#PB_Button_Default, lang("Export the current preset")) : xx+wbtn
    
    If TreeGadget(#G_PresetTG,5,40,ScreenX-20,PanelLayerH_IE-105)
      OpenPresetBank()
    EndIf
    TextGadget(#G_PresetName,5,45+GadgetHeight(#G_PresetTG),w-20,20, Lang("Brush name"),#PB_Text_Border)
    
    ;}
    
    
    AddGadgetItem(#G_PanelLayer,2,Lang("Options"))
    ;{ Options
    yy = 10
    FrameGadget(#PB_Any,10,yy,ScreenX-20,110, Lang("Paper"))
    yy + 20
    If  ListViewGadget(#G_ListPaper,20,yy,ScreenX-50, 80)
      IE_UpdatePaperList()
      YY+GadgetHeight(#G_ListPaper) +20
    EndIf
    
    ; Paper alpha
    wp = 30
    If AddSTringTBGadget(#G_PaperAlphaName,#G_PaperAlpha,#G_PaperAlphaSG, paper\alpha, 
                         lang("Alpha"), lang("Alpha of the background"),0,yy,ScreenX-50-wp,wp,0,255)
      YY+GadgetHeight(#g_paperAlpha)
    EndIf
    
    ; Paper Scale 
    If AddSTringTBGadget(#G_PaperScaleName, #G_PaperScale, #G_PaperScaleSG, paper\scale, 
                         lang("Scale"), Lang("Scale of the background"),0,yy,ScreenX-50-wp,wp,1,200)
      YY+GadgetHeight(#G_PaperScale)
    EndIf
    
    If AddSTringTBGadget(#G_PaperIntensityName,#G_PaperIntensity,#G_PaperIntensitySG, paper\intensity, 
                         Lang("Contrast"), Lang("Contrast of the background"),0,yy,ScreenX-50-wp,wp,1,1000)
      YY+GadgetHeight(#G_PaperIntensity)
    EndIf
    
    
    If AddSTringTBGadget(#G_PaperBrightnessName,#G_PaperBrightness,#G_PaperBrightnessSG, paper\brightness, 
                         Lang("Brightness"), Lang("Brightness of the background"),0,yy,ScreenX-50-wp,wp,1,100)
      YY+GadgetHeight(#G_PaperIntensity)
    EndIf
    
    
    
    ;}
    
    
    CloseGadgetList()
  EndIf
  
  
  h - PanelLayerH_IE -25
  
  ;If PanelGadget(#G_PanelSwatch, w+10,ToolbarH+PanelLayerH_IE+5,ScreenX-10,h)
  If PanelGadget(#G_PanelSwatch, 0, 0, wp1-5, h)
    
    SetGadgetColor(#G_PanelSwatch,#PB_Gadget_BackColor,OptionsIE\ThemeGadCol)
    
    h = ToolbarH+PanelLayerH_IE+5
    
    AddGadgetItem(#G_PanelSwatch,0,Lang("Swatch"))
    yy = 5
    i = 5
    bw = 22
    wbt = 23
    AddButonImage(#G_SwatchNew,i,yy,bw,bw,  #ico_New,#PB_Button_Default,    lang("Create a new swatch")) :  i=i+wbt
    AddButonImage(#G_SwatchOpen,i,yy,bw,bw,  #ico_Open,#PB_Button_Default,  lang("Open a swatch"))       :  i=i+wbt
    AddButonImage(#G_SwatchMerge,i,yy,bw,bw,  #ico_Merge,#PB_Button_Default,lang("Merge a swatch"))      :  i=i+wbt
    AddButonImage(#G_SwatchSave,i,yy,bw,bw,  #ico_Save,#PB_Button_Default,  lang("Save the swatch"))     :  i=i+wbt
    AddButonImage(#G_SwatchExport,i,yy,bw,bw,  #ico_Export,#PB_Button_Default,lang("Export the swatch")) :  i=i+wbt
    AddButonImage(#G_SwatchEdit,i,yy,bw,bw,  #ico_Prop,#PB_Button_Default,  lang( "Edit the swatch"))    :  i=i+wbt
    
    wsa = PanelLayerW_IE-20
    i=5
    ScrolSwInt = 25
    If ScrollAreaGadget(#G_SA_Swatch,i,30,wsa,h-180,wsa-ScrolSwInt,h-180)
      If CanvasGadget(#G_SwatchCanvas,0,0,wsa, h-180)
        CreateSwatch()        
      EndIf      
      CloseGadgetList()
    EndIf
    
    ; The roughboard/ scratch Board
    AddGadgetItem(#G_PanelSwatch,1,Lang("Rough"))
    yy = 5
    i = 5
    bw = 22
    AddButonImage(#G_RBNew,i,yy,bw,bw, #ico_New,#PB_Button_Default,         lang("Create a new roughboard"))                    :  i=i+wbt
    AddButonImage(#G_RBPaint,i,yy,bw,bw, #ico_IE_Pipette,#PB_Button_Default,lang("Draw or pick the color (on the roughboard)")) :  i=i+wbt
    AddButonImage(#G_RBOpen,i,yy,bw,bw,  #ico_Open,#PB_Button_Default,      lang("Open an image on the roughboard"))            :  i=i+wbt
    AddButonImage(#G_RBSave,i,yy,bw,bw,  #ico_Save,#PB_Button_Default,      lang("Save the roughboard"))                        :  i=i+wbt
    AddButonImage(#G_RBExport,i,yy,bw,bw,  #ico_Export,#PB_Button_Default,  lang("Export the roughboard"))                      :  i=i+wbt
    
    i=5
    If ScrollAreaGadget(#G_SA_Rb,i,30,wsa,h-180,wsa-ScrolSwInt,h-180)
      If CanvasGadget(#G_RoughtBoard,0,0,PanelLayerW_IE-10,h-50)
        If OptionsIE\RB_Img$ = "" Or LoadImage(#image_RB, OptionsIE\RB_Img$ ) = 0
          ; MessageRequester(Lang("Error"), Lang("Unable to load the roughboard image"))
          
          If CreateImage(#image_RB, 100,200) = 0            
            
            MessageRequester(Lang("Error"), Lang("Unable to create the roughboard image"))
            
          Else
            
            If StartDrawing(ImageOutput(#image_RB))
              Box(0, 0, OutputWidth(), OutputHeight(), RGB(255, 255, 255))
              StopDrawing()
            EndIf
            
          EndIf
        EndIf        
        w1 = ImageWidth(#image_RB)
        h1 = ImageHeight(#image_RB)
        ResizeGadget(#G_RoughtBoard,#PB_Ignore,#PB_Ignore,w1,h1)
        SetGadgetAttribute(#G_SA_Rb,  #PB_ScrollArea_InnerWidth ,w1)
        SetGadgetAttribute(#G_SA_Rb,  #PB_ScrollArea_InnerHeight ,h1)
        If StartDrawing(CanvasOutput(#G_RoughtBoard))
          DrawImage(ImageID(#image_RB),0,0)
          StopDrawing()
        EndIf
        
      EndIf
      CloseGadgetList()
    EndIf
    
    
    
    AddGadgetItem(#G_PanelSwatch,2,Lang("Pattern"))
    yy = 5
    i = 5
    bw = 22
    AddButonImage(#G_patternAdd,i,yy,bw,bw, #ico_New,#PB_Button_Default,         lang("Add a new pattern"))                    :  i=i+wbt
    
    i=5
    ; add a scrollarea and canvasfor patterns
    If ScrollAreaGadget(#G_SA_Pattern,i,30,wsa,h-180,wsa-ScrolSwInt,h-180)
      
      If CanvasGadget(#G_PatternCanvas,0,0,PanelLayerW_IE-10,h-50)
        
        CreatePatterns()
        
      EndIf  
      
      CloseGadgetList()
    EndIf
    
    
    
    CloseGadgetList()
  EndIf
  
  
  h = WindowHeight(#WinMain) - 50 - ToolbarH
  If SplitterGadget(#G_SplitLayerRB, W+10, ToolbarH, wp1-5, h, #G_PanelLayer, #G_PanelSwatch)
    SetGadgetState(#G_SplitLayerRB, PanelLayerH_IE)
  EndIf
  ; If SplitterGadget(#G_SplitLayerRB,WindowWidth(0)-150,ToolbarH, ScreenX-10,600,#G_PanelLayer,#G_PanelSwatch,#PB_Splitter_Separator) : EndIf
  
  
EndProcedure
Procedure IE_UpdateGadget(gadget=1)
  
  
  Shared ToolbarH  
  Shared PanelToolsW_IE, PanelToolsH_IE, PanelLayerW_IE, PanelLayerH_IE, BarAnimH_IE 
  
  
  ; resize the container which contain the screen // on resize le container qui contient le screen
  PanelRight = 1
  PanelLeft = 1
  screenx2 = 175
  x1 = PanelToolsW_IE+15
  If (OptionsIE\ShowPanelColors=0 And OptionsIE\ShowPanelToolparameters = 0)
    PanelLeft = 0
    ScreenX =0
    x1 = 0
  Else
    screenX = 175
  EndIf
  If (OptionsIE\ShowPanelLayers=0 And OptionsIE\ShowPanelswatchs = 0)
    PanelRight = 0
  EndIf
  
  
  ; resize splitters
  x = WindowWidth(#WinMain) - screenx2 +5
  h = WindowHeight(#WinMain) - ToolbarH - 50 ; StatusBarHeight(#Statusbar)
  If gadget = 1
    ResizeGadget(#G_SplitToolCol, #PB_Ignore, #PB_Ignore, #PB_Ignore, h)
    ResizeGadget(#G_SplitLayerRB, x, #PB_Ignore, #PB_Ignore, h)
  EndIf
  
  
  ; define the w and H of the container-Screen
  oldW = GadgetWidth(#G_ContScreen) 
  H = WindowHeight(#WinMain) - StatusBarHeight(#Statusbar)-12 - OptionsIE\ToolbarH -6
  W = WindowWidth(#WinMain) - ScreenX2 * panelRight - (ScreenX+10)*panelLeft
  
  ; resize the container screen
  ResizeGadget(#G_ContScreen, x1 - 100000 * OptionsIE\UseCanvas, #PB_Ignore, w, h)
  ResizeGadget(#G_CanvasMain, x1 - 100000 * (1-OptionsIE\UseCanvas), #PB_Ignore, w, h)
  
  ; need to move the layer position 
  If gadget=0
    If screenX = 0
      CanvasX + 180
    Else
      CanvasX - 180
    EndIf
    ScreenUpdate()
  EndIf
  
EndProcedure

Procedure IE_SaveSplitter(LayerH,ToolH, BarH)
  
  Shared PanelToolsW_IE, PanelToolsH_IE, PanelLayerW_IE, PanelLayerH_IE, BarAnimH_IE 
  PanelToolsH_IE = ToolH
  PanelLayerH_IE = LayerH
  BarAnimH_IE = BarH
  
EndProcedure
Procedure UpdateGadgetLayer(id)
  
  SetGadgetState(#G_LayerAlpha,     Layer(Id)\alpha)
  SetGadgetState(#G_LayerView,      Layer(Id)\view)
  SetGadgetState(#G_LayerLocked,    Layer(Id)\locked)
  SetGadgetState(#G_LayerLockAlpha, Layer(Id)\LockAlpha)
  SetGadgetState(#G_LayerLockMove,  Layer(Id)\LockMove)
  SetGadgetState(#G_LayerLockPaint, Layer(Id)\LockPaint)
  bm = Layer_GetBm(id)          
  SetGadgetState(#G_LayerBM, bm)
  
EndProcedure



; paper & utils (grid..) are now in layer.pbi

; update general UI
Procedure UpdateBrushPreview()
  
  tmp = CopyImage(#BrushOriginal,#PB_Any)
  If tmp >0
    ResizeImage(tmp,98,98)
    If StartDrawing(ImageOutput(tmp))
      DrawingMode(#PB_2DDrawing_AlphaClip)
      Box(0,0,98,98,RGBA(0,0,0,255))
      StopDrawing()
    EndIf
    
    If StartDrawing(ImageOutput(#Img_PreviewBrush))
      ;       DrawImage(ImageID(#Img_paper),0,0,100,100)
      DrawImage(ImageID(#Img_checker),0,0,100,100)
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      Box(0, 0, 100, 100, RGBA(240, 240, 240, 220))
      DrawAlphaImage(ImageID(tmp),1,1)
      StopDrawing()
    EndIf    
    SetGadgetState(#G_BrushPreview, ImageID(#Img_PreviewBrush))
    FreeImage2(tmp)
  EndIf
  
EndProcedure
Procedure UpdateBrushImagePreview()
  
  ; to update the brush editor preview of the final brush image (with all changes)
  
  tmp = CopyImage(#BrushCopy, #PB_Any)
  If tmp >0
    ResizeImage(tmp,98,98)
    If StartDrawing(ImageOutput(tmp))
      DrawingMode(#PB_2DDrawing_AlphaClip)
      Box(0,0,98,98,RGBA(0,0,0,255))
      StopDrawing()
    EndIf
    
    If StartDrawing(ImageOutput(#Img_PreviewBrushFinal))
      
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      DrawImage(ImageID(#Img_checker),0,0,100,100)
      Box(0, 0, 100, 100, RGBA(240, 240, 240, 100))
      DrawAlphaImage(ImageID(tmp),1,1)
      StopDrawing()
    EndIf    
    SetGadgetState(#G_brushImageFinal, ImageID(#Img_PreviewBrushFinal))
    FreeImage2(tmp)
  EndIf 
  
 
  tmp = CopyImage(#BrushCopy, #PB_Any)
  If tmp >0
    ResizeImage(tmp,32,32)
    If StartDrawing(ImageOutput(tmp))
      DrawingMode(#PB_2DDrawing_AlphaClip)
      Box(0,0,98,98,RGBA(0,0,0,255))
      StopDrawing()
    EndIf
  EndIf
  
  
  
  If StartDrawing(ImageOutput(#Img_PreviewBrushFinalStroke))
    
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    w1 = Round( OutputWidth()/100, #PB_Round_Up)
    For i =0 To w1
      DrawImage(ImageID(#Img_checker),i*100,0,100,100)
    Next
    Box(0, 0, OutputWidth(), OutputHeight(), RGBA(240, 240, 240, 100))
    
    ; then draw th brushimage 
    w1 = (OutputWidth()-20)
    size.d=0
    Repeat
      
      If sizeok = 0
        If size < 0.98
          size +0.02+Brush(Action)\Pas*0.01
        Else
          sizeok = 1
        EndIf
      Else
        If i > 250
          If size > 0.02
            size -0.02
          EndIf
        EndIf
      EndIf
      
      brushsiz.d = 32* size 
      b.d = (brushsiz * Brush(Action)\Pas*0.01) * Brush(Action)\SizeW*0.01
      b2.d = brushsiz *8 * 0.01
      If Brush(Action)\RotateByAngle
        angle = Brush(Action)\RotateByAngle + Rnd(Brush(Action)\randRot)
      Else
        angle = Rnd(Brush(Action)\randRot) + Brush(Action)\randRot
      EndIf
      
      
      ;If angle >0
        temp1 = RotateImageEx2(ImageID(tmp),angle+Rnd(Brush(Action)\randRot)) 
      ;Else
        ;temp1= CopyImage(tmp, #PB_Any)
      ;EndIf
      www = ImageWidth(temp1) * b2
      hhh = ImageHeight(temp1) * b2
      ResizeImage(temp1,www,hhh,1-Brush(Action)\Smooth)
      
      ; then draw the image
      DrawAlphaImage(ImageID(temp1),10+j,OutputHeight()/2-hhh/2, brush(action)\alpha)
      ;If angle>0
        FreeImage2(temp1)
      ;EndIf
      j+b
      i+1
      
    Until j > w1
    
    StopDrawing()
  EndIf    
  SetGadgetState(#G_brushImageFinalStroke, ImageID(#Img_PreviewBrushFinalStroke))
  
  FreeImage2(tmp)
  
EndProcedure
Procedure SetToolParamToGad()
  
  ; first, we delete the gadget item of panel tool and recreate it
  CreateToolPanel()
  
  ; d'abord, on cache tous les gadgets liés aux paramètres des outils
  ;   For i = #G_FirstParamBrush+1 To #G_LastParamBrush-1
  ;     If IsGadget(i)
  ;       HideGadget(i,1)
  ;     EndIf
  ;   Next i
  
  ; on update  
  With Brush(Action)
    
    Select Action
        
        ; autre dessins
      Case #Action_Spray
        
        
      Case #Action_Particles
        
        
      Case #Action_Box
        ;HideGad2(#G_FrameAlpha,0,0)
        ;HideGad2(#G_BrushAlpha,0,Brush(Action)\Alpha)
        
      Case #Action_Circle
        ;HideGad2(#G_BrushAlpha,0,Brush(Action)\Alpha)
        ;HideGad2(#G_FrameAlpha,0,0)
        
        
      Case #Action_Line
        ;HideGad2(#G_BrushAlpha,0,Brush(Action)\Alpha)
        ;HideGad2(#G_FrameAlpha,0,0)
        
      Case #Action_Fill
        
        
      Case #Action_Gradient
        ;HideGad2(#G_BrushAlpha,0,Brush(Action)\Alpha)
        ;HideGad2(#G_FrameAlpha,0,0)
        
      Case #Action_Shape
        
        
      Case #Action_Clear
        
        
        ; transformation
      Case #Action_Move
        
        
      Case #Action_Transform
        
        
      Case #Action_Rotate
        
        
      Case #Action_Select
        
        
        ; Canvas
      Case #Action_Zoom
        
        
      Case #Action_Hand
        
        
      Case #Action_Text
        
      Case #Action_Pipette
        
        
      Case #Action_brush, #Action_eraser, #Action_Pen, #Action_CloneStamp
        
        ; on réaffiche toutes les options des brosses
        ;       For i = #G_FirstParamBrush+1 To #G_LastParamBrush-1
        ;         If IsGadget(i)
        ;           HideGadget(i,0)
        ;         EndIf
        ;       Next i
        
        ;{ puis on mets à jours les paramètres de l'outil
        
        ; size
        SetGadgetState(#G_BrushSize,\Size)
        SetGadgetState(#G_BrushSizeH,\sizeH)
        SetGadgetState(#G_BrushSizeW,\SizeW)
        SetGadgetState(#G_BrushSizePressure,\Sizepressure)
        SetGadgetState(#G_BrushSizeMin,\SizeMin)
        SetGadgetState(#G_BrushSizeRand,\SizeRand)
        
        ; alpha
        SetGadgetState(#G_BrushAlpha,\Alpha)
        ; SetGadgetState(#G_BrushAlphaMin,\AlphaMin)
        SetGadgetState(#G_BrushAlphaPressure,\AlphaPressure)
        SetGadgetState(#G_BrushAlphaRand,\AlphaRand)
        
        ; dynamics
        SetGadgetState(#G_BrushScatter,\Scatter)
        SetGadgetState(#G_BrushRandRotate,\RandRot)
        SetGadgetState(#G_BrushRotate,\Rotate)
        SetGadgetState(#G_BrushRotateAngle,\RotateByAngle)
        
        ; stroke
        SetGadgetState(#G_brushIntensity,\Intensity)
        SetGadgetState(#G_BrushStroke,\Stroke)
        SetGadgetState(#G_BrushSymetry,\symetry)
        SetGadgetState(#G_brushSoftness,\Softness)
        SetGadgetState(#G_brushHardness,\Hardness)
        SetGadgetState(#G_BrushPas,\Pas)
        SetGadgetState(#G_brushTrait,\Trait)
        
        ; misc
        SetGadgetState(#G_BrushSymetry,\symetry)
        ; on update l'image
        BrushUpdateImage(1,1)
        
        ; color
        SetGadgetState(#G_BrushMix,\Mix)
        SetGadgetState(#G_BrushMixTyp,\MixType)
        SetGadgetState(#G_BrushMixLayer,\MixLayer)
        SetGadgetState(#G_BrushVisco,\Visco)
        ; SetGadgetState(#G_BrushWater,\Water)
        SetGadgetState(#G_BrushLavage,\Wash)
        SetGadgetState(#G_BrushWater, \Water)
        
        ;}
        
        
        
    EndSelect
    
  EndWith
  
  
EndProcedure
Procedure UpdateTool(Gad)
  
  If gad <> #G_IE_Clear
    
    OptionsIE\Shape  = 0
    OldAction = Action
    
    For i = #G_IE_Pen To #G_IE_Zoom
      SetGadgetState(i,0)
    Next i
    SetGadgetState(gad,1)
    Action = gad - #G_IE_Pen
    
    ; set layer type
    Select Action
        
      Case #Action_Text
        OptionsIE\LayerTyp = #Layer_TypText
        
      Default          
        OptionsIE\LayerTyp = #Layer_TypBitmap
        
    EndSelect
    
    
    If action <> OldAction
      
      Layer_ValidChange(OldAction)
      
      If OldAction = #Action_Transform Or OldAction = #Action_Move Or OldAction = #Action_Rotate
        If OptionsIE\ActionForAllLayers =1 
          oldLayerId = layerid
          For i = 0 To ArraySize(layer())
            If i <> layerid               
              If layer(i)\View=1 And layer(i)\Locked =0 
                layerid = i
                Layer_ValidChange(OldAction)
              EndIf
            EndIf
          Next i
          layerid = oldLayerId
        EndIf
      EndIf
      
      Select Action 
          
        Case #Action_Transform, #Action_Move          
          layer(layerId)\selected = 1
          Newpainting = 1      
          ScreenUpdate()
          
        Case #Action_Eraser
          Brush(Action)\Type  = #ToolType_Eraser
          
        Case #Action_Brush
          Brush(Action)\Type  = #ToolType_Brush
          
        Case #Action_Pen
          Brush(Action)\Type  = #ToolType_Pen
          
      EndSelect
      
    EndIf
    
  Else
    
    Layer_Clear(LayerId)
    
  EndIf
  
  If action <> OldAction
    SetToolParamToGad()
  EndIf
  
  If action <= #Action_Fill
    SetColor()
    SetColorSelector(brush(action)\color,0,0,4,1)
  EndIf
  
  
EndProcedure
Procedure UpdateColorFG()
  
  If StartDrawing(ImageOutput(#ImageColorFG))
    Box(0,0,100,100,Brush(Action)\ColorFG)
    StopDrawing()
  EndIf
  ;   If StartDrawing(ImageOutput(#ImageColorBG))
  ;     Box(0,0,100,100,Brush(Action)\Color)
  ;     StopDrawing()
  ;   EndIf
  SetGadgetState(#G_BrushColorFG,ImageID(#ImageColorFG))
  SetGadgetState(#G_BrushColorBG,ImageID(#ImageColorBG))
  
EndProcedure


; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 841
; FirstLine = 103
; Folding = AAAAAOAADAAAAAAAwlAAAAAAAAABwIGAAAAAAAAA-
; DisableDebugger
; EnableUnicode