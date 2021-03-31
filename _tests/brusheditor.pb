; Code by falsam 2015
; modified a lot by blendman in 03.2021
;{  Changes
;-- Changes

; 29.3.2021
; // new
; - brush : add fadeout parameters
; - save the brush image (when created)

; 27.3.2021
; // new
; - brush : pas
; - brush parameters : size, alpha, fadeIn (size), fadeout (alpha), rotation
; - brush : can change the brush-type (circle, Or image), colors
; - UI : trackbar For size, alpha, pas, preview brush image, color
; - menu/edit : clear the layer
;}


; EnableExplicit

Enumeration
  
  ; Window
  #MainForm
  
  ; Gadgets
  #Canvas= 0
  ; brush parameters
  #G_BrushColor
  #G_BrushPreview ; image for the brush preview
  #G_TB_Size
  #G_SG_Size
  #G_TB_Alpha
  #G_SG_Alpha
  #G_TB_Pas
  #G_SG_Pas
  #G_Combobox_Brush ; brush type
  #G_CB_BrushFadeOn 
  #G_TB_BrushSizeFadeIn
  #G_SG_BrushSizeFadeIn
  #G_TB_BrushSizeFadeout
  #G_SG_BrushSizeFadeout
  #G_TB_BrushAlphaFadeOut 
  #G_SG_BrushAlphaFadeOut
  
  ; image
  #Imagelayer = 0
  #imagelayer1
  
  #ImageBrushColor
  #ImageBrushPreview
  #ImageBrushFinal
  #ImagecopyBrushFinal
  
  #imagesave
  
  ; menu
  #menu_NewDoc = 0
  #menu_OpenDoc
  #menu_Importaslayer
  #menu_Save
  #menu_Saveaslayer
  #menu_ExportFullimage
  #menu_Clear
EndEnumeration

;{ structure
Structure Canvas
  LeftButtonDown.i
  RightButtonDown.i
EndStructure

Global Draw, This.Canvas, fadeOn, fadeOff, fadeAlpha, FadeSizeMAx, DocH, DocW
FadeSizeMAx  = 20

; fade = to get a fade

Structure VPoint
  x.f
  y.f
EndStructure
Global PreviousPoint.VPoint
Global CurrentPoint.VPoint, LastPoint.VPoint

; Global Dim Dot.Vpoint(0), NbDot = -1 ; not used, it's an array to store the dots, for example, to create a fade ON/off

Structure sBrush
  
  Pas.w ; space between two dots /100 : 100% -> space = brush\size
  Brush.a ; the id of the brush used
  
  Color.q
  
  Size.w
  FadeSize.a ; to kwow if we use the fadeOn (fade for size) or not
  FadeSizeOn.w
  FadeSizeOff.w
  
  ; the alpha
  Alpha.a
  FadeAlphaOutCur.w
  FadeAlphaOutMax.w
  
EndStructure
Global brush.sbrush
brush\size = 20
brush\pas = 100
brush\alpha = 100


Structure sLayer
  image.i
  name$
  blendmode.a
  alpha.a
  view.a
  lock.a
EndStructure
Global Dim layer.sLayer(0)
Global NbLayer = -1
;}

UsePNGImageDecoder()
UsePNGImageEncoder()
UseJPEGImageEncoder()
UseJPEGImageDecoder()

Macro distance(x1,y1,x2,y2)   
  Int(Sqr((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1)) )       
EndMacro
Macro direction(x1,y1,x2,y2) ; get angle
  ATan2((y2- y1),(x2- x1))
EndMacro


Declare EventDraw()

Procedure.l RotateImageEx2(ImageID, Angle.f, Mode.a=2) ; Rotation d'une image d'un angle en ° - rotation of an image, in degres.
  
  Shared ImageBrushW.w, ImageBrushH.w
  ; Procedure par Le Soldat inconnu - Merci
  ; By LSI, but windows Only
  
  Protected bmi.BITMAPINFO, bmi2.BITMAPINFO, hdc.l, NewImageID, Mem, n, nn, bm.BITMAP
  
  ;   If IsImage(NewImageID)
  ;     FreeImage(NewImageID)
  ;   EndIf
  
  
  Angle = Angle * #PI / 180 ; On convertit en radian
  
  Cos.f = Cos(Angle)
  Sin.f = Sin(Angle)
  
  ; CouleurFond = Brush\Color ; 0
  
  GetObject_(ImageID, SizeOf(BITMAP), @bm.BITMAP) ; windows only; is there a version for linux, mac os ?
  
  bmi\bmiHeader\biSize = SizeOf(BITMAPINFOHEADER)
  bmi\bmiHeader\biWidth = bm\bmWidth
  bmi\bmiHeader\biHeight = bm\bmHeight
  bmi\bmiHeader\biPlanes = 1
  bmi\bmiHeader\biBitCount = 32
  
  bmi2\bmiHeader\biSize = SizeOf(BITMAPINFOHEADER)
  ;   Select Mode
  ;     Case 1
  ;       bmi2\bmiHeader\biWidth = bm\bmWidth
  ;       bmi2\bmiHeader\biHeight = bm\bmHeight
  ;     Case 2
  bmi2\bmiHeader\biWidth = Round(Sqr(bm\bmWidth * bm\bmWidth + bm\bmHeight * bm\bmHeight), 1)
  bmi2\bmiHeader\biHeight = bmi2\bmiHeader\biWidth
  ;     Default
  ;       bmi2\bmiHeader\biWidth = Round(bm\bmWidth * Abs(Cos) + bm\bmHeight * Abs(Sin), 1)
  ;       bmi2\bmiHeader\biHeight = Round(bm\bmHeight * Abs(Cos) + bm\bmWidth * Abs(Sin), 1)
  ;   EndSelect
  bmi2\bmiHeader\biPlanes = 1
  bmi2\bmiHeader\biBitCount = 32
  
  Mem = AllocateMemory(bm\bmWidth * bm\bmHeight * 4)
  If Mem
    Mem2 = AllocateMemory(bmi2\bmiHeader\biWidth * bmi2\bmiHeader\biHeight * 4)
    If Mem2
      hdc = CreateCompatibleDC_(GetDC_(ImageID)) ; windows only
      If hdc
        GetDIBits_(hdc, ImageID, 0, bm\bmHeight, Mem, @bmi, #DIB_RGB_COLORS) ; on envoie la liste dans l'image / windows only
        DeleteDC_(hdc)                                                       ; windows only
      EndIf
      
      CX1 = bm\bmWidth - 1
      CY1 = bm\bmHeight - 1
      CX2 = bmi2\bmiHeader\biWidth - 1
      CY2 = bmi2\bmiHeader\biHeight - 1
      
      Mem01 = Mem + bm\bmWidth * 4
      Mem10 = Mem + 4
      Mem11 = Mem01 + 4
      
      Mem2Temp = Mem2
      
      For nn = 0 To CY2
        y1b.l = nn * 2 - CY2
        Temp1.f = CX1 - y1b * Sin
        Temp2.f = CY1 + y1b * Cos
        For n = 0 To CX2
          x1b.l = n * 2 - CX2
          
          x1.f = (Temp1 + x1b * Cos) / 2
          y1.f = (Temp2 + x1b * Sin) / 2
          
          x2.l = x1
          y2.l = y1
          
          If x1 < x2
            x2 - 1
          EndIf
          If y1 < y2
            y2 - 1
          EndIf
          
          x2b = x2 + 1
          y2b = y2 + 1
          
          If x2b >= 0 And x2 <= CX1 And y2b >= 0 And y2 <= CY1 ; On filtre si on est completement en dehors de l'image
            
            fx.f = x1 - x2
            fy.f = y1 - y2
            f00.f = (1 - fx) * (1 - fy)
            f01.f = (1 - fx) * fy
            f10.f = fx * (1 - fy)
            f11.f = fx * fy
            
            MemTemp = (x2 + y2 * bm\bmWidth) * 4
            
            If x2 >= 0 And x2 <= CX1
              If y2 >= 0 And y2 <= CY1
                c00 = PeekL(Mem + MemTemp)
              Else
                c00 = 0
              EndIf
              If y2b >= 0 And y2b <= CY1
                c01 = PeekL(Mem01 + MemTemp)
              Else
                c01 = 0
              EndIf
            Else
              c00 = 0
              c01 = 0
            EndIf
            If x2b >= 0 And x2b <= CX1
              If y2 >= 0 And y2 <= CY1
                c10 = PeekL(Mem10 + MemTemp)
              Else
                c10 = 0
              EndIf
              If y2b >= 0 And y2b <= CY1
                c11 = PeekL(Mem11 + MemTemp)
              Else
                c11 = 0
              EndIf
            Else
              c10 = 0
              c11 = 0
            EndIf
            
            Channel00 = c00 >> 24 & $FF
            Channel01 = c01 >> 24 & $FF
            Channel10 = c10 >> 24 & $FF
            Channel11 = c11 >> 24 & $FF
            Alpha = Channel00 * f00 + Channel01 * f01 + Channel10 * f10 + Channel11 * f11
            
            Channel00 = c00 >> 16 & $FF
            Channel01 = c01 >> 16 & $FF
            Channel10 = c10 >> 16 & $FF
            Channel11 = c11 >> 16 & $FF
            Bleu = Channel00 * f00 + Channel01 * f01 + Channel10 * f10 + Channel11 * f11
            
            Channel00 = c00 >> 8 & $FF
            Channel01 = c01 >> 8 & $FF
            Channel10 = c10 >> 8 & $FF
            Channel11 = c11 >> 8 & $FF
            Vert = Channel00 * f00 + Channel01 * f01 + Channel10 * f10 + Channel11 * f11
            
            Channel00 = c00 & $FF
            Channel01 = c01 & $FF
            Channel10 = c10 & $FF
            Channel11 = c11 & $FF
            Rouge  = Channel00 * f00 + Channel01 * f01 + Channel10 * f10 + Channel11 * f11
            
            PokeL(Mem2Temp, Rouge | Vert << 8 | Bleu  << 16 | Alpha << 24)
            
          Else
            PokeL(Mem2Temp, 0)
          EndIf
          
          Mem2Temp + 4
          
        Next
      Next
      
      ; On crée la nouvelle image
      NewImageID = CreateImage(#PB_Any, bmi2\bmiHeader\biWidth, bmi2\bmiHeader\biHeight, 32)
      ImageBrushW = bmi2\bmiHeader\biWidth
      ImageBrushH = bmi2\bmiHeader\biHeight
      
      hdc = CreateCompatibleDC_(GetDC_(ImageID(NewImageID)))
      If hdc
        SetDIBits_(hdc, ImageID(NewImageID), 0, bmi2\bmiHeader\biHeight, Mem2, @bmi2, #DIB_RGB_COLORS) ; on envoie la liste dans l'image
        DeleteDC_(hdc)
      EndIf
      
      FreeMemory(Mem2)
    EndIf
    FreeMemory(Mem)
    
    ; NewImageID = UnPreMultiplyAlpha(NewImageID)
    
  EndIf
  
  ProcedureReturn NewImageID
EndProcedure
Procedure UpdateBrush()
  
  Define color.q
  
  
  If IsImage(#ImagecopyBrushFinal)
    FreeImage(#ImagecopyBrushFinal)
  EndIf
  
  CopyImage(#ImageBrushFinal, #ImagecopyBrushFinal)
  
  If StartDrawing(ImageOutput(#ImagecopyBrushFinal))
    
    DrawingMode(#PB_2DDrawing_AlphaClip)
    color = brush\color
    Box(0,0,OutputWidth(), OutputHeight(), RGBA(Red(color),Green(color),Blue(color),255))
    
    StopDrawing()
  EndIf
  
  
EndProcedure

Procedure Addtrackbar(id, x, y, w, h, min, max, val, tip$)
  
  Define w1 = 45
  
  TrackBarGadget(id, x, y, w-w1-10, h, min, max)
  SetGadgetState(id, val)
  GadgetToolTip(id, tip$)
  
  StringGadget(id+1, x+w-w1-10, y, w1,h,Str(val))
  GadgetToolTip(id+1, tip$)
  
EndProcedure
Procedure AddStringGadget(id, x, y, w, h, text$, tip$)
  
  StringGadget(id, x, y, w, h, text$)
  GadgetToolTip(id, tip$)

EndProcedure

Procedure StateGadgetBrush()
  
  Define eventgadget.i, color.q
  
  eventgadget = EventGadget()
  
  Select EventGadget
      
    Case #G_Combobox_Brush
      brush\Brush = GetGadgetState(EventGadget)
      
    Case #G_BrushColor
      If EventType() =  #PB_EventType_LeftClick       
        color = ColorRequester(brush\color)
        If color >=0
          brush\color = Color
          If StartDrawing(ImageOutput(#ImageBrushColor))
            Box(0,0,OutputWidth(), OutputHeight(), color)
            StopDrawing()
          EndIf
          SetGadgetState(#G_BrushColor, ImageID(#ImageBrushColor))
          UpdateBrush()
        EndIf
      EndIf
      
    Case #G_SG_BrushAlphaFadeOut
      brush\FadeAlphaOutMax = Val(GetGadgetText(EventGadget))
      
    Case #G_CB_BrushFadeOn
      brush\FadeSize = GetGadgetState(EventGadget)
      
    Case #G_SG_Size
      brush\size = Val(GetGadgetText(#G_SG_Size))
      SetGadgetState(#G_TB_Size,  brush\size)
      UpdateBrush()
      
    Case #G_SG_Alpha
      brush\Alpha = Val(GetGadgetText(#G_SG_Alpha))
      SetGadgetState(#G_TB_Alpha, brush\Alpha)
      
    Case #G_SG_Pas
      brush\pas = Val(GetGadgetText(#G_SG_Pas))
      SetGadgetState(#G_TB_Pas,  brush\Pas)
      
    Case #G_TB_Size
      brush\size = GetGadgetState(EventGadget)
      SetGadgetText(#G_SG_Size, Str( brush\size))
      UpdateBrush()
      
    Case #G_TB_Alpha
      brush\Alpha = GetGadgetState(EventGadget)
      SetGadgetText(#G_sg_Alpha, Str(brush\Alpha))
      
    Case #G_TB_Pas
      brush\Pas = GetGadgetState(EventGadget)
      SetGadgetText(#G_sg_Pas, Str( brush\Pas))
  EndSelect
  
  
EndProcedure
Procedure UpdateCanvas()
  
  If StartDrawing(CanvasOutput(#Canvas))
    DrawingMode(#PB_2DDrawing_AllChannels)
    Box(0,0, OutputWidth(), OutputHeight(), RGBA(255,255,255,255))
    ; DrawAlphaImage(ImageID(#imagelayer1), 0, 0) ; uncomment it if you use 2 layers 
    DrawAlphaImage(ImageID(#imagelayer), 0, 0)
    
    StopDrawing()
  EndIf
  
EndProcedure
Procedure Event_Menu()
  
  Select EventMenu()
      
    Case #menu_ImportAsLayer
      filename$ = OpenFileRequester("Save", "", "Images|*.png;*.jpg", 0)
      If filename$ <> ""
        temp = LoadImage(#PB_Any, filename$)
        If temp
          If StartDrawing(ImageOutput(#Imagelayer))
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(ImageID(temp), 0,0)
            StopDrawing()
          EndIf
          FreeImage(temp)
        EndIf
        UpdateCanvas()
      EndIf
      
    Case #menu_ExportFullimage, #menu_Saveaslayer
      filename$ = SaveFileRequester("Save", "", "PNG|*.png|JPG|*.jpg", 0)
      If filename$ <> ""
        If CreateImage(#ImageSave, Docw, DocH, 32, #PB_Image_Transparent)
          If StartDrawing(ImageOutput(#imagesave))
            If EventMenu() = #menu_Saveaslayer
              DrawAlphaImage(ImageID(#Imagelayer), 0,0)
            Else
              ; draw all layers ! 
            EndIf
            StopDrawing()
          EndIf
        EndIf
        
        ext$ = ""
        pos = SelectedFilePattern()
        If pos = 0
          flag = #PB_ImagePlugin_PNG  
          If GetExtensionPart(filename$) <> "png"
            ext$ = ".png"
          EndIf
        Else
          flag = #PB_ImagePlugin_JPEG  
          If GetExtensionPart(filename$) <> "jpg"
            ext$ = ".jpg"
          EndIf
        EndIf
        
        If SaveImage(#ImageSave, filename$+ext$, flag) : EndIf
        FreeImage(#ImageSave)
      EndIf
      
    
      
    Case #menu_Clear
      If StartDrawing(ImageOutput(#Imagelayer))
        DrawingMode(#PB_2DDrawing_AllChannels)
        Box(0, 0, OutputWidth(), OutputHeight(), RGBA(0,0,0,0))
        StopDrawing()
      EndIf
      UpdateCanvas()
      
  EndSelect
  
  
EndProcedure



If ExamineDesktops()
  winW = DesktopWidth(0)
  winH = DesktopHeight(0)
EndIf

If OpenWindow(#MainForm, 0, 0, WinW, WinH, "Paintoon", #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_Maximize)
  
  
  CreateMenu(0, WindowID(#MainForm))
  MenuTitle("File")
  MenuItem(#menu_ImportAsLayer, "Import as layer")
  MenuBar()
  MenuItem(#menu_Saveaslayer, "Save the current layer")
  MenuItem(#menu_ExportFullimage, "Export the full image")
  MenuTitle("Edit")
  MenuItem(#menu_Clear, "Clear the layer")
  AddKeyboardShortcut(0,#PB_Shortcut_Control|#PB_Shortcut_X, #menu_Clear)
  
  Define y.w = 10, w.a = 200, i=0, h1 = 25
  AddTrackbar(#G_TB_Size, 10, y, w, 20, 1, 500, brush\size, "size of the brush") : y+h1
  AddTrackbar(#G_TB_Alpha, 10, y, w, 20, 0, 255, brush\Alpha, "Alpha of the brush") : y+h1
  AddTrackbar(#G_TB_Pas, 10, y, w, 20, 1, 500, brush\Pas, "Pas (space between two dots for the brush (in % of the current size)") : y+h1
  AddStringGadget(#G_SG_BrushAlphaFadeOut, 10, y, 60, 20, Str(brush\FadeAlphaOutMax), "Alpha fade out (max)") : y+h1
  CheckBoxGadget(#G_CB_BrushFadeOn, 10, Y, w, 20, "Fade the size at start") : y+30
  
  If CreateImage(#ImageBrushColor,  60, 60) : EndIf
  ImageGadget(#G_BrushColor, w/2 - 30, y, 60, 60, ImageID(#ImageBrushColor)) : y+70
  
  
  
  
  ; If LoadImage(#ImageBrushFinal, "brush7.png") : EndIf ; use your own brush image if you want to test ;)
  
  If Not IsImage(#ImageBrushFinal)
    If CreateImage(#ImageBrushFinal, 60, 60, 32, #PB_Image_Transparent)
      
      If StartDrawing(ImageOutput(#ImageBrushFinal))
        DrawingMode(#PB_2DDrawing_AllChannels)
        For i = 0 To 20
          x1 = Random(30)-Random(30)
          y1 = Random(30)-Random(30)
          a = 100+Random(155)
          Circle(30+x1, 30+y1, 2+Random(10), RGBA(0,0,0,a))
        Next
        StopDrawing()
      EndIf
      file$ = GetCurrentDirectory()+"brush"+FormatDate("%dd%mm%yyyy%hh%mm%ss", Date())  +".png"
      Debug file$
      SaveImage(#ImageBrushFinal, file$,#PB_ImagePlugin_PNG      )         
    EndIf
  EndIf
  updatebrush()
  
  
  If CreateImage(#ImageBrushPreview, 60,60)
    If StartDrawing(ImageOutput(#ImageBrushPreview))
      Box(0,0,OutputWidth(), OutputHeight(), RGB(255,255,255))
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      DrawAlphaImage(ImageID(#ImagecopyBrushFinal), 0,0)
      StopDrawing()
    EndIf
    ImageGadget(#G_BrushPreview, w/2 - 30, y, 60,60, ImageID(#ImageBrushPreview), #PB_Image_Border ) : y+ImageHeight(#ImageBrushPreview)+10
  EndIf
  
  ComboBoxGadget(#G_Combobox_Brush, 10, y, 180, 20)
  AddGadgetItem(#G_Combobox_Brush, 0, "Circle")
  AddGadgetItem(#G_Combobox_Brush, 1, "Brush")
  SetGadgetState(#G_Combobox_Brush, 0)
  
  
  
  If CanvasGadget(#Canvas, w+10, 0, 1024-w-10, 768) : EndIf
  
  
  ; The image for layer
  ; If CreateImage(#Imagelayer, 1024-w-10, 768, 32, #PB_Image_Transparent) : EndIf
  docW = 1500
  docH = 1500
  
  
  If CreateImage(#Imagelayer,docW, docH, 32, #PB_Image_Transparent) : EndIf
  
  UpdateCanvas()
  
  
  ; bind event
  BindGadgetEvent(#Canvas, @EventDraw())
  BindEvent(#PB_Event_Gadget, @StateGadgetBrush())
  BindEvent(#PB_Event_Menu, @Event_Menu())
  
  Repeat : Until WaitWindowEvent(0) = #PB_Event_CloseWindow
EndIf

Procedure EventDraw()
  
  Protected Distance, first
  Protected CountPoint, N
  
  Protected x = GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX)
  Protected y = GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY)
  
  Protected NextPointX.f, NextPointY.f
  Protected DeltaX.f, DeltaY.f
  
  Define direction.d, interval.d, pas.d, distBetween2dot.d, thesize.w, Thealpha.a
  Define x1.d, y1.d, x2.f, y2.f, X3.f, y3.f, nextDot.i, color.q
  
  ; define the alpha of the brush
  ; alpha could be drawn on another image and this would be : drawalphaimage(image, 0,0, brush\alpha)
  Thealpha = Brush\alpha - (brush\FadeAlphaOutCur/(1+brush\FadeAlphaOutMax/10)) 
  If Thealpha < 0
    Thealpha = 0
  EndIf
  
  
  With This
    
    Select EventType()
        
      Case #PB_EventType_LeftButtonDown
        \LeftButtonDown = #True
        PreviousPoint\x = x
        PreviousPoint\Y = y
        If first = 0
          First = 1
          Draw = #True
          If brush\FadeSize = 0
            fadeOn = FadeSizeMAx
          EndIf
        EndIf
        
      Case #PB_EventType_LeftButtonUp
        \LeftButtonDown = #False
        CurrentPoint\x = x
        CurrentPoint\Y = y
        fadeOn = 0
        Draw = #False
        First = 0
        brush\FadeAlphaOutCur = 0
        
      Case #PB_EventType_MouseMove   
        Draw = #False
        If \LeftButtonDown ; Or \RightButtonDown)
          ; Thealpha = Brush\alpha- (brush\FadeAlphaOutCur/(1+brush\FadeAlphaOutMax/10))
          If Thealpha >0  And Thealpha <=255
            Draw = #True
            If brush\FadeSize = 0
              fadeOn = FadeSizeMAx
            Else
              If fadeOn <= FadeSizeMAx
                fadeOn + 1
                Thesize = (brush\size*fadeOn)/FadeSizeMAx
              EndIf
            EndIf
            
            CurrentPoint\x = x
            CurrentPoint\Y = y
            ;           nbdot +1
            ;           ReDim dot(nbdot)
            ;           dot(nbdot)\x = x
            ;           dot(nbdot)\y = y
          EndIf
        EndIf
        
    EndSelect
    
    ; Drawing
    If Draw
      
     
      ; pas = to calculate the distance between two dots -> brush\Pas = 100 ->pas = 1 (100%) -> dist = brush\size, brush\Pas = 50 -> dist = brush\size/2...
      Pas = brush\Pas/100
      
      
      ; calcul the size, with the fade-size On
      Thesize = (brush\size * fadeOn)/FadeSizeMAx
      
      If thesize >=1 And Thealpha > 0 And thealpha <=255
        
        x1 = PreviousPoint\x
        y1 = PreviousPoint\y   
        x2 = CurrentPoint\x
        y2 = CurrentPoint\y
        
        Color = brush\color
        
        ; update the brush image
        UpdateBrush()
        ResizeImage(#ImagecopyBrushFinal, thesize, thesize,#PB_Image_Raw )
        
        
        ; the distancebetween Two dots
        distBetween2dot = Thesize*Pas
        
        ;distance between two vectors
        Distance = Distance(x1,y1, x2,y2)
        
        ; number of dots to draw
        CountPoint = Distance/(Pas*Thesize)
        ; Debug CountPoint
        
        If StartDrawing(ImageOutput(#Imagelayer))
          DrawingMode(#PB_2DDrawing_AlphaBlend)
          
          If distBetween2dot <= distance And CountPoint > 0 And first = 0
            
            direction = direction(x1, y1, x2, y2)
            
            For N = 1 To CountPoint
              
              If brush\FadeAlphaOutMax > 0
                Thealpha = Brush\alpha- (brush\FadeAlphaOutCur/(1+brush\FadeAlphaOutMax/10))
                If Thealpha >0 And thealpha <= 255
                  brush\FadeAlphaOutCur+1
                EndIf
              EndIf
              
              ; then draw the dots
              x3 = x1 + n * distBetween2dot * Sin(direction)
              y3 = y1 + n * distBetween2dot * Cos(direction)
              If brush\Brush = 0
                Circle(x3, y3, Thesize/2, RGBA(Red(color), Green(color), Blue(color), Thealpha))
              Else
                temp = RotateImageEx2(ImageID(#ImagecopyBrushFinal), Random(360))
                DrawAlphaImage(ImageID(temp), x3-Thesize/2, y3-Thesize/2, Thealpha)
                FreeImage(temp)
              EndIf
              
            Next
            
            PreviousPoint\x = x3
            PreviousPoint\y = y3
            
          Else
            
            If first = 1
              If brush\FadeSize = 0
                
                If brush\FadeAlphaOutMax > 0
                  Thealpha = Brush\alpha- (brush\FadeAlphaOutCur/(1+brush\FadeAlphaOutMax/10))
                  If Thealpha >0 And thealpha <= 255
                    brush\FadeAlphaOutCur+1
                  EndIf
                EndIf
                
                ; then draw the dots
                If brush\Brush = 0
                  Circle(x1, y1, Thesize/2, RGBA(Red(color), Green(color), Blue(color), Thealpha))
                Else
                  temp =  RotateImageEx2(ImageID(#ImagecopyBrushFinal), Random(360))
                  DrawAlphaImage(ImageID(temp), x1-Thesize/2, y1-Thesize/2, Thealpha)
                  FreeImage(temp)
                EndIf
                
              EndIf
            EndIf
            
          EndIf
          
          StopDrawing()
        EndIf
        
        UpdateCanvas()
      EndIf
      
    EndIf
    
  EndWith
  
EndProcedure
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 615
; FirstLine = 91
; Folding = DBAAAC0-jO-d---
; EnableXP