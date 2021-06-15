; layers


; Utilitaires (grid, marker,repere...)
Macro UpdateGrid()
  ;z.d = OptionsIE\zoom * 0.01
  
  If StartDrawing(SpriteOutput(#Sp_Grid))
    DrawingMode(#PB_2DDrawing_AlphaChannel)
    Box(0,0,doc\w,doc\h,RGBA(0,0,0,0))
    
    
    DrawingMode(#PB_2DDrawing_AlphaBlend)  
    
    u.d = (doc\w/OptionsIE\gridW);/(doc\zoom/100)
    v.d = (doc\h/OptionsIE\gridH);/(doc\zoom/100)
                                 ; MessageRequester("",Str(u) + "/"+Str(v) + "/"+Str(OptionsIE\gridW))
    c = OptionsIE\gridColor
    col = RGBA(Red(c),Green(c),Blue(c),255)
    For i = 0 To u
      For j = 0 To v
        Line(i * OptionsIE\gridW   ,0,1,doc\h ,col)
        Line(0,j * OptionsIE\gridH  , doc\w ,1,col)
      Next j
    Next i  
    StopDrawing()
  EndIf 
EndMacro
Macro CreateGrid()
  
  ; to create the gris
  FreeSprite2(#Sp_Grid)
  
  If CreateSprite(#Sp_Grid, doc\w, doc\h,#PB_Sprite_AlphaBlending) 
    UpdateGrid()
  EndIf
EndMacro


; paper
Procedure IE_UpdatePaperList()
  
  ; to update the list of paper
  size =0
  If ExamineDirectory(0, GetCurrentDirectory() + "data\paper\", "*.*")  
    
    While NextDirectoryEntry(0)
      
      If DirectoryEntryType(0) = #PB_DirectoryEntry_File
        
        Name$ = DirectoryEntryName(0)
        AddGadgetItem(#G_ListPaper, -1, Name$)
        
        ReDim Thepaper(size)
        Thepaper(size)\name$ = Name$
        size = ArraySize(Thepaper())+1
      EndIf
      
    Wend
    FinishDirectory(0)
    
  EndIf
  
EndProcedure
Procedure PaperDraw()
  
  SpriteBlendingMode(#PB_Sprite_BlendSourceAlpha, #PB_Sprite_BlendInvertSourceAlpha)
  z.d = OptionsIE\zoom*0.01
  
  ; draw the color of the background
  ZoomSprite(#Sp_PaperColor,doc\w*z,doc\h*z)
  DisplayTransparentSprite(#Sp_PaperColor,CanvasX,CanvasY, 255)
  
  ;   draw the paper
  SpriteBlendingMode(#PB_Sprite_BlendSourceAlpha, #PB_Sprite_BlendInvertSourceAlpha) ; multiply
  ZoomSprite(#Sp_Paper,doc\w*z,doc\h*z)
  DisplayTransparentSprite(#Sp_Paper,CanvasX,CanvasY, paper\alpha)
  
EndProcedure
Procedure PaperUpdate(load=0)
  
  
  ; if we load a new image for the background
  If load >= 1 Or Not IsImage(  #Img_Paper)
    
    If LoadImage(#Img_Paper, GetCurrentDirectory() + "data\Paper\"+OptionsIE\Paper$)
      
      If load = 1
        
        If IsGadget(#G_paperScale)
          SetGadgetState(#G_paperScale, 10)
        EndIf
        
        ; create the elements needed
        If OptionsIE\UseCanvas = 0
          
          ; create sprites for the screen
          FreeSprite2(#Sp_Paper)
          FreeSprite2(#Sp_PaperColor)
          If CreateSprite(#Sp_Paper, doc\w, doc\h, #PB_Sprite_AlphaBlending) = 0
            MessageRequester(Lang("error"), Lang("Unable to create paper (sprite)"))
          EndIf
          If CreateSprite(#Sp_PaperColor, 10, 10, #PB_Sprite_AlphaBlending) = 0
            MessageRequester(Lang("error"), Lang("Unable to create paper (spritecolor)"))
          EndIf
          
        Else
          
          ; create images for the canvas
          FreeImage2(#Img_PaperForMainCanvas)
          If CreateImage(#Img_PaperForMainCanvas, doc\w, doc\h)
          EndIf
          
        EndIf
        
       EndIf
       
     EndIf
     
  EndIf
  
  ; define some variable
  z.d = 1 ; OptionsIE\zoom*0.01
  scale.d = 1
  
  ; than change the image on the sprite.
  If IsGadget(#G_paperScale)
    
    If paper\scale <1
      paper\scale = GetGadgetState(#G_paperScale)
    EndIf
    
    scale = paper\scale
    scale = scale /10
  Else
    scale = paper\scale
    scale = scale /10
    ;     Debug "paperscale gadget pas ok"
  EndIf
  ;    Debug "paperscale "+StrD(scale)
  
  
  ; <------- attention : need to check if scale isn't too large or not enough large
  
  
  
  ; create a tempImage for paper.
  tempImgPaper = CopyImage(#Img_Paper, #PB_Any)
  
  
  w = ImageWidth(#Img_Paper)
  h = ImageHeight(#Img_Paper)
  w1.d= ImageWidth(#Img_Paper) * scale
  h1.d = ImageHeight(#Img_Paper) * scale
  If w1 > 5000
    w1= 5000
  EndIf
  If h1 > 5000
    h1= 5000
  EndIf
  
  If IsImage(tempImgPaper)
    
    ; resize the image 
    ResizeImage(tempImgPaper, w1, h1)
    ; tempImgPaper = UnPreMultiplyAlpha(tempImgPaper) ; not need because image has no alpha chanel ^^, it's a bacground.
    w = ImageWidth(tempImgPaper)
    h = ImageHeight(tempImgPaper)
    
    If paper\intensity >1 Or paper\brightness >1
      Echelle.d = (400+paper\intensity)/400
      EchelleB.d = paper\brightness/100 ; 0.2
      
      If StartDrawing(ImageOutput(tempImgPaper))
        For i= 0 To OutputWidth()-1
          For j=0 To OutputHeight()-1
            col = Point(i,j)
            r = (Red(col) * Echelle  + 127 * (1 - Echelle)) * EchelleB
            g = (Green(col)* Echelle  + 127 * (1 - Echelle))* EchelleB
            b = (Blue(col)* Echelle  + 127 * (1 - Echelle)) * EchelleB
             Check0(r)
             Check0(g)
             Check0(b)
            Plot(i,j,RGB(r,g,b))
          Next
        Next
        StopDrawing()
      EndIf
      ; tempImgPaper = IE_Contrast(tempImgPaper, paper\intensity, 100, 1)
    EndIf
    
    ;      MessageRequester("paper", Str(w)+"/"+Str(h)+"|"+Str(SpriteWidth(#Sp_Paper))+"/"+Str(SpriteHeight(#Sp_Paper)))
    
    ; update the color of the BG
    If OptionsIE\UseCanvas = 0
      
      If StartDrawing(SpriteOutput(#Sp_PaperColor))
        Box(0, 0, OutputWidth(), OutputHeight(), paper\color) ;RGBA(Red(paper\color), Green(paper\Color), Blue(paper\Color), 255))
        StopDrawing()
      EndIf
      
      ; draw on the sprite the new background
      If StartDrawing(SpriteOutput(#Sp_Paper))
        DrawingMode(#PB_2DDrawing_AlphaBlend )
        For i=0 To (doc\w/w)*z +1
          For j = 0 To (doc\h/h)*z +1
            DrawImage(ImageID(tempImgPaper),i*w,j*h)
          Next j 
        Next i       
        
        StopDrawing()
        
      EndIf
   
    Else
     
      ; update the paper image for maincanvas
      If StartDrawing(ImageOutput(#Img_PaperForMainCanvas))
        DrawingMode(#PB_2DDrawing_AlphaBlend )
        For i=0 To (doc\w/w)
          For j = 0 To (doc\h/h)
            DrawImage(ImageID(tempImgPaper),i*w,j*h)
          Next j 
        Next i       
        StopDrawing()
      EndIf
      
    EndIf
    
    ; delete tempImage
    FreeImage(tempImgPaper)
    
  EndIf
  
  freeimage2(#Img_Paper)
  

EndProcedure
Procedure PaperCreate(delete=0)
  
  ; to create the papaer sprite
  If IsImage(#img_paper)
    
    ; need to recreate the sprite (if we change
    If delete =1
      If IsSprite(#Sp_Paper)
        FreeSprite(#Sp_Paper)
      EndIf
    EndIf
    
    If OptionsIE\usecanvas = 0
      
      If Not IsSprite(#Sp_Papercolor)
        If CreateSprite(#Sp_Papercolor, 10, 10, #PB_Sprite_AlphaBlending)
        EndIf
      EndIf
      
      If CreateSprite(#Sp_Paper, doc\w, doc\h, #PB_Sprite_AlphaBlending)
        ;       If StartDrawing(SpriteOutput(#Sp_Paper))
        ;         DrawImage(ImageID(#Img_Paper),0,0)
        ;         StopDrawing()
        ;       EndIf      
        PaperUpdate() 
      Else
        MessageRequester(Lang("error"), Lang("Unable to create paper (sprite)"))
      EndIf
    Else
      
      If Not IsImage(#Img_PaperForMainCanvas)
        If CreateImage(#Img_PaperForMainCanvas, doc\w, doc\h)
        EndIf
      EndIf
      
    EndIf
  
  EndIf
  
EndProcedure
Procedure PaperInit(load=1)
  
  If load=1
    If LoadImage(#Img_Paper,GetCurrentDirectory() + "data\Paper\"+OptionsIE\Paper$)=0
      MessageRequester(lang("Error"), lang("Unable to load the image paper"))
      OptionsIE\Paper$ = "paper0.png"
      If LoadImage(#Img_Paper,GetCurrentDirectory() + "data\Paper\"+OptionsIE\Paper$)=0
        If CreateImage(#img_paper, 64, 64) = 0
          MessageRequester(lang("Error"), lang("Unable to create the image paper"))
        Else
          If StartDrawing(ImageOutput(#img_paper))
          EndIf
          
        EndIf
        
      EndIf
    EndIf
  EndIf
  
  ; create the color background
  If OptionsIE\usecanvas = 0
    If Not IsSprite(#Sp_PaperColor)
      If CreateSprite(#Sp_PaperColor, 10, 10, #PB_Sprite_AlphaBlending)
        If StartDrawing(SpriteOutput(#Sp_PaperColor))
          Box(0,0, OutputWidth(), OutputHeight(), RGBA(255,255,255,255))
          StopDrawing()
        EndIf    
      EndIf
    EndIf
  EndIf
  
;   ; create the paper
;   PaperCreate()
;   
;   ; Create a temporary layer/sprite, for temporary operation (selection, box, circle...)
;   ; puis, je crée le layertempo, un sprite pour les opérations comme sélection, box, cercle, gradient, etc...
;   CreateLayertempo()
  
  ; create the paper and layertemporary
  RecreateLayerUtilities()
  

  
EndProcedure
; WindowBackgroundEditor() : see include\procedures\window.pbi




; others sprite/image thant the layer, but drawn on the screen/canvas (sprite temporary, paper...)
Procedure CreateLayertempo_(create=0)
  
  ; free the sprite
  If IsSprite(#sp_LayerTempo)
    FreeSprite(#sp_LayerTempo)
  EndIf
  
  If IsSprite(#sp_LayerSelection)
    FreeSprite(#sp_LayerSelection)
  EndIf
  
  ; recreate the sprite for layer temporary operation - like box, circle, gradient...
  If create = 1
    If CreateSprite(#Sp_LayerTempo,doc\w,doc\h,#PB_Sprite_AlphaBlending) 
      If StartDrawing(SpriteOutput(#Sp_LayerTempo))
        DrawingMode(#PB_2DDrawing_AlphaChannel)
        Box(0,0,doc\w,doc\h,RGBA(0,0,0,255))
        Box(0,0,doc\w,doc\h,RGBA(0,0,0,0))
        StopDrawing()
      EndIf    
    EndIf
  EndIf
  
EndProcedure
Procedure RecreateLayerUtilities()
  
  ; needed when : crop, resize, newdoc, opendoc...
  CreateLayertempo_()
  
  ; recreate the paper
  PaperUpdate(1) 
  
  ; recreate the grid ?
  ; CreateGrid() 
  
  ; and other sprite ??
  
  ; For canvas
  Canvas_CreateImageMiniForMove()

EndProcedure


; layers getspriteimage
Procedure Layer_SetSpriteToImage_(mode=0) 
  
  ; not used, because sprite image has sometimes white or black background needed for some blendmode (multiply, add...)
  
  ; to copy the image of the sprite on the image of the layer (to have the same result as the preview rendering !!!)
  If ArraySize(layer()) <= LayerId And layerid >=0
    
    If Layer(layerId)\Haschanged
      If Layer(layerId)\CopySpritetoImg = 0
        Layer(layerId)\CopySpritetoImg = 1
        
        If mode = 0
          
          name$ = GetCurrentDirectory()+"\save\"+"temp_spriteImg.png"
          If SaveSprite(Layer(LayerId)\Sprite, name$,#PB_ImagePlugin_PNG)
            temp = LoadImage(#PB_Any, name$)
            If temp <> 0
              FreeImage2(Layer(LayerId)\Image)
              Layer(LayerId)\Image = temp
            EndIf
          EndIf
          
        ElseIf mode=1
          
          ; copy the pixels form the sprite
          If StartDrawing(SpriteOutput(Layer(layerid)\sprite))
            W = OutputWidth()
            H = OutputHeight()
            ; create an array to stock the pixels of the sprite
            Dim spritepixels(w*h)
            ; get the buffer
            buffer = DrawingBuffer ()
            
            For i = 0 To W-1 ; for each line
              For j = 0 To H-1 ; for each column
                spritepixels(i+j*w) = Point(i,j)
              Next
            Next
            StopDrawing()
          EndIf
          
          ; paste the pixels on the current layer image
          If StartDrawing(ImageOutput(Layer(LayerId)\image))
            For i = 0 To W-1 ; for each line
              For j = 0 To H-1 ; for each column
                Plot(i,j, spritepixels(i+j*w))
              Next
            Next
            StopDrawing()
          EndIf
          
          FreeArray(spritepixels())
        EndIf
        
      EndIf
    EndIf
    
  EndIf

EndProcedure
Procedure Layer_SetHasChanged()
  Layer(layerId)\Haschanged = 1
  Layer(layerId)\CopySpritetoImg = 0
EndProcedure


; Layer UI & gadget
Procedure Layer_importImage(update=1)
  
  filename$ = OpenFileRequester(lang("Import Image as a new layer"),"","Allformat|*png;*.jpg;*.bmp|png|*.png|jpg|*.jpg|bmp|*.bmp|",0,#PB_Requester_MultiSelection )
  
  If filename$ <>""
    While filename$
      
      temp = LoadImage(#PB_Any,Filename$)
      If temp  = 0
        MessageRequester(Lang("Error"), lang("Unable to load the image as new layer : "+Filename$))
      Else
        
        ; on ajoute un layer
        Layer_Add()
        
        ; et on dessine l'image dessus.
        If StartDrawing(ImageOutput(layer(LayerId)\image))
          DrawingMode(#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(ImageID(temp),0,0)
          StopDrawing()
        EndIf
        
        If update
          NewPainting = 1
          ScreenUpdate()
        EndIf
        
        FreeImage2(temp)
      EndIf
      
      filename$ = NextSelectedFileName()
    Wend
  EndIf
 
EndProcedure
Procedure Layer_UpdateList(all=-1)
  
  ; update the layer UI
  ; should be 26
  h = ImageHeight(#Img_LayerCenterSel) 
  
  ; verify the height needed to draw all layers
  hl = (ArraySize(layer())+1) *(h+1)
  If hl > 200
    ResizeGadget(#G_LayerListCanvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, hl)
    SetGadgetAttribute(#G_LayerList, #PB_ScrollArea_InnerHeight , hl+10)
  ElseIf hl < 200
    If GadgetHeight(#G_LayerListCanvas) <> 200
      ResizeGadget(#G_LayerListCanvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, 200)
      SetGadgetAttribute(#G_LayerList, #PB_ScrollArea_InnerHeight , 200)
    EndIf
  EndIf
  
  If StartDrawing(CanvasOutput(#G_LayerListCanvas))
    
    ; the canvas grey background
    Box(0, 0, OutputWidth(), OutputHeight(), RGB(160, 160, 160))
    
    ; for the checker image (for layer image preview)
    s = 19
    checker = CopyImage(#Img_Checker,#PB_Any)
    ResizeImage(checker, s, s) 
    
    ; temporaire
    all = -1
    
    ; draw the image For each layer    
    If all <> -1
      ; just the layerID
      i = layerId
      Box(0, 1+layer(i)\ordre * (h+1), OutputWidth(), h, RGB(100, 100, 100))
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(40, 2, layer(i)\name$, RGB(255, 255, 255))
      
    Else
      
      ; draw all layer
      For i = ArraySize(layer()) To 0 Step -1
        
        pos = ArraySize(layer()) - layer(i)\ordre
        
        xx1 = 0
        yy1 = 1+pos *(h+1)
        If layer(i)\MaskAlpha =2 ; on dessine sur l'apha du calque
          d=1
        EndIf
        ; a box for BG layer (not selected)
;         Box(0, 1+pos *(h+1), OutputWidth(), h, RGB(120, 120, 120))
;         
;         ; if layer is selected
;         If i = layerid
;           Box(0, 1+pos *(h+1), OutputWidth(), h, RGB(100, 100, 100))
;         EndIf
        
        If i = layerId
          DrawImage(ImageID(#Img_LayerCenterSel), xx1, yy1)
        Else
          DrawImage(ImageID(#Img_LayerCenter), xx1, yy1)
        EndIf
        
        
        ; the image for layer\view
        If layer(i)\view
          ; Box(2, 5+pos*(h+1), 20, 20, RGB(220, 220, 220))
          DrawAlphaImage(ImageID(#ico_LayerEye),5,8+pos*(h+1))
        EndIf
        
        ; the image of the layer 
        DrawImage(ImageID(checker), 23,3+yy1)
        
        ; the image for layer\lock
        If layer(i)\locked
         ;  Box(150, 5+pos*(h+1), 20, 20, RGB(250, 120, 0))
          DrawAlphaImage(ImageID(#ico_LayerLocked),104,4+pos*(h+1))
        EndIf
        
         DrawingMode(#PB_2DDrawing_Transparent)
         DrawText(44+d*22, 4+pos*(h+1), layer(i)\name$, RGB(255, 255, 255))
         
      Next
    EndIf
    
    StopDrawing()
  EndIf
  
  FreeImage2(checker)
  
  ; IE_UpdateLayerUi() 
  
EndProcedure
Procedure IE_UpdateLayerUi() 
  
  Layer_UpdateList()
  
;   n = ArraySize(layer())
;   
;   If OpenGadgetList(#G_LayerList)
;     
;     For i =0 To n
;       Layer_updateUi(i)  
;     Next
;     CloseGadgetList()
;     
;   EndIf
;   
  
EndProcedure

Procedure Layer_UpdateUi(i)
  
  Layer_UpdateList(i)
  
  
;   
;   useUI = 0
;   If useUI  = 1
;     ; to update the layer UI (image for view, preview layer, lock...)
;     n =ArraySize(layer())
;     
;     With layer(i)
;       
;       nom${12} = \Name$
;       s = 19
;       temp = CopyImage(\Image,#PB_Any)
;       ResizeImage(temp, s, s)
;       
;       checker = CopyImage(#Img_Checker,#PB_Any)
;       ResizeImage(checker, s, s) 
;       
;       ; d'abord, on update l'image du gadget-layer
;       If StartDrawing(ImageOutput(\ImgLayer))
;         DrawingMode(#PB_2DDrawing_Default)
;         If i = layerId
;           
;           DrawImage(ImageID(#Img_LayerCenterSel),0,0)
;         Else
;           DrawImage(ImageID(#Img_LayerCenter),0,0)
;         EndIf
;         
;         If \MaskAlpha =2 ; on dessine sur l'apha du calque
;           d=1
;         EndIf
;         
;         DrawingMode(#PB_2DDrawing_Outlined)
;         Box(22+d*20,2,s+2,s+2,RGBA(0, 0, 0, 255))
;         
;         DrawingMode(#PB_2DDrawing_Default)
;         Box(23+d*20,3, s, s,RGBA(80,80,80, 255))
;         
;         DrawingMode(#PB_2DDrawing_AlphaBlend) 
;         If \View =1
;           DrawAlphaImage(ImageID(#ico_LayerEye),5,8)
;         EndIf 
;         
;         
;         
;         DrawImage(ImageID(checker), 23,3)
;         DrawAlphaImage(ImageID(temp), 23,3)
;         
;         If \MaskAlpha >=1
;           FreeImage2(temp)
;           temp = CopyImage(\ImageAlpha,#PB_Any)
;           ResizeImage(temp,s,s)
;           StopDrawing()
;           If StartDrawing(ImageOutput(temp))
;             DrawingMode(#PB_2DDrawing_AlphaClip)
;             Box(0,0,s,s,RGBA(255,255,255,255))
;             If \MaskAlpha =3
;               DrawingMode(#PB_2DDrawing_AlphaBlend)
;               Line(0,0,s,s,RGBA(255,0,0,255))
;               Line(0,s,0,0,RGBA(255,0,0,255))
;             EndIf
;             StopDrawing()
;           EndIf
;           If StartDrawing(ImageOutput(\ImgLayer))
;           EndIf        
;           DrawAlphaImage(ImageID(temp), 44,3) 
;           d=1
;         EndIf
;         
;         DrawingMode(#PB_2DDrawing_Transparent)  
;         DrawText(44+d*22,4,nom$) 
;         
;         DrawingMode(#PB_2DDrawing_AlphaBlend)  
;         If \Locked =1
;           DrawAlphaImage(ImageID(#ico_LayerLocked),104,4)
;         EndIf 
;         
;         StopDrawing()           
;       EndIf
;       
;       FreeImage2(temp)
;       FreeImage2(checker)
;       
;       ; creation ou update du gadget pour le layer 
;       If IsGadget(\IG_LayerMenu)  And \IG_LayerMenu > #G_LastGadget
;         
;         If StartDrawing(CanvasOutput(\IG_LayerMenu))
;           DrawImage(ImageID(\ImgLayer), 0, 0)
;           StopDrawing()
;         EndIf
;         ResizeGadget(\IG_LayerMenu, #PB_Ignore, 1 + 26*(n-\Ordre), #PB_Ignore, #PB_Ignore)
;         
;       Else
;         
;         \IG_LayerMenu = CanvasGadget(#PB_Any, 0 , 1 + 26*(n-\Ordre), 220, 25)
;         If StartDrawing(CanvasOutput(\IG_LayerMenu))
;           DrawImage(ImageID(\ImgLayer), 0, 0)
;           StopDrawing()
;         EndIf
;       EndIf
;       
;       
;     EndWith
;     
;   EndIf
;   
;   
EndProcedure

Procedure Layer_SetGadgetState()
  
  i = layerID
  If i >=0 And i <= ArraySize(layer())
    SetGadgetState(#G_LayerLocked, layer(i)\Locked)
    SetGadgetState(#G_LayerAlpha, layer(i)\alpha)
    SetGadgetState(#G_LayerAlphaSpin, layer(i)\alpha)
    SetGadgetState(#G_LayerView, layer(i)\view)
    SetGadgetState(#G_LayerBM, layer(i)\Bm)
    SetGadgetState(#G_LayerLockMove, layer(i)\LockMove)
    SetGadgetState(#G_LayerLockPaint, layer(i)\LockPaint)
    SetGadgetState(#G_LayerLockAlpha, layer(i)\LockAlpha)
  EndIf

EndProcedure
Procedure Layer_GetLayerId()
  
  ; we clic on the layer UI
  
  h = ImageHeight(#Img_LayerCenterSel)+1
  lx = GetGadgetAttribute(#G_layerListcanvas, #PB_Canvas_MouseX)
  ly = GetGadgetAttribute(#G_layerListcanvas, #PB_Canvas_MouseY)

  Select EventType()
      
    Case #PB_EventType_LeftDoubleClick
      If Lx > 45 And Lx <= 80
        name$ = InputRequester("Name", "Name of the layer : ", "")
        If name$ <> ""
          layer(layerId)\name$ = name$
          Layer_UpdateUI(-1)
        EndIf
      ElseIf Lx > 80 
        ; layer properties
        WindowLayerProp()
      EndIf
      
    Case #PB_EventType_LeftButtonDown
      pos = ly/h
      i = ArraySize(layer())- pos
      ; Debug i
      If i <0
        i = 0
      ElseIf i> ArraySize(layer())
         i = ArraySize(layer())
      EndIf
      
      If Lx < 20
        ; view
        Layer(i)\View = 1 - Layer(i)\View
        CanvasHasChanged = 1
      Else
        ;         If i <> LayerId 
        ;           If Layer(layerId)\Haschanged
        ;             Layer_SetSpriteToImage()
        ;           Else 
        ;             If Layer(layerId)\CopySpritetoImg = 0
        ;               Layer(layerId)\CopySpritetoImg = 1
        ;             EndIf
        ;           EndIf
        ;         Else
        ;           Layer_SetSpriteToImage()
        ;         EndIf
        layerId = i
        testlayer(LayerId)
      EndIf
    
      ; Debug pos
      Layer_SetGadgetState()
      Layer_UpdateUI(-1)
      ScreenUpdate() 
      ; Canvas_SetImageforMove()
      
  EndSelect
  
EndProcedure



; Layer text
Procedure Layer_UpdateText(i=0,w=0,h=0,mode=0)
  
  ; mode = 2 : only when creating the layer (layer_add())
  With  Layer(i)
    
    
    If StartDrawing(ImageOutput(\Image))      
      DrawingFont(FontID(\FontID))
      H = TextHeight(\Text$)
      W = TextWidth(\Text$)
      ;Debug "nouvelle taille avant calcul : "+Str(W)+"/"+Str(H)
      StopDrawing()
    EndIf
    
    If W > 0 And H > 0
      \W = W
      \H = H
      \NewW = \W
      \NewH = \H
      \CenterX = \W/2
      \CenterY = \H/2
      ResizeImage(\Image,\w,\h)
      ; ResizeImage(\ImageBM,\w,\h)
    EndIf
    
    ; then we draw the text on the sprite and image
    If StartDrawing(ImageOutput(\Image))
      ; DrawingMode(#PB_2DDrawing_AllChannels)
      ; Box(0, 0, \W, \H, RGBA(0,0,0,255))
      DrawingMode(#PB_2DDrawing_AlphaChannel)
      Box(0, 0, \W, \H, RGBA(0,0,0,0))
      
      DrawingFont(FontID(\FontID))
      DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Transparent)
      DrawText(0, 0,\Text$, RGBA(Red(\FontColor),Green(\FontColor),Blue(\FontColor),255))    
      StopDrawing()
    EndIf
    
    
    If mode <> 2 ; mode = 2 : for layer_add() only
      
      FreeSprite2(\sprite)
      \sprite = CreateSprite(#PB_Any,\w,\h,#PB_Sprite_AlphaBlending)
      
      If StartDrawing(SpriteOutput(\Sprite))
        Box(0,0,\w,\h,RGBA(255,255,255,255))
        DrawingMode(#PB_2DDrawing_AlphaChannel)
        Box(0,0,\w,\h,RGBA(0,0,0,0))
        DrawingMode(#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(ImageID(\image),0,0)
        StopDrawing()
      EndIf 
      ; ZoomSprite(\sprite,\w,\h)
      
    EndIf
    
    
  EndWith
  
EndProcedure
Procedure Layer_ChangeText()
  
  
  With layer(layerid)
    text$ = InputRequester(Lang("Text"),Lang("New Text"),\Text$)
    FontRequester( \FontName$, \FontSize,#PB_FontRequester_Effects,\FontColor,\FontStyle)  
    \FontName$ = SelectedFontName()
    \FontSize  = SelectedFontSize()
    \FontStyle = SelectedFontStyle()
    \FontColor = RGB(Red(brush(action)\Color),Green(brush(action)\Color),Blue(brush(action)\Color)) ; SelectedFontColor()
    FreeFont(\FontID)
    \FontID = LoadFont(#PB_Any,\FontName$,\FontSize,\FontStyle)
    
    Layer_UpdateText(LayerId,0,0,2)
    
    FreeSprite2(\sprite)
    \sprite = CreateSprite(#PB_Any,\w,\h,#PB_Sprite_AlphaBlending)
    
    If StartDrawing(SpriteOutput(\Sprite))
      Box(0,0,\w,\h,RGBA(255,255,255,255))
      DrawingMode(#PB_2DDrawing_AlphaChannel)
      Box(0,0,\w,\h,RGBA(0,0,0,0))
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      DrawAlphaImage(ImageID(\image),0,0)
      StopDrawing()
    EndIf
  EndWith
  
  ScreenUpdate()
  
  
EndProcedure





; add, delete
Procedure Layer_Add(x=0,y=0,txt$="")
  
  Shared OpenLayer
  
  Select OptionsIE\LayerTyp
      
    Case #Layer_TypText 
      If openmenu = 0
        FontRequester("Arial", 12, #PB_FontRequester_Effects)  
        FontName$ = SelectedFontName()
        FontSize  = SelectedFontSize()
        ; Debug FontSize
        FontStyle = SelectedFontStyle()
        FontColor = brush(action)\color ; SelectedFontColor()
      EndIf
      
  EndSelect
  
  ReDim layer(LayerNb)
  n = ArraySize(layer())
  LayerId = n
  
  
  With layer(n)
    
    \typ = OptionsIE\LayerTyp
    
    \id = LayerIdMax ; id unique, même si on supprime un layer
    
    ; \ImgLayer = CreateImage(#PB_Any, 220,25) ; for the gadget
    
    \bm = #Bm_Normal
    \view = 1
    \alpha = 255
    \ordre = n
    \h = Doc\h
    \w = Doc\w
    
    Select \typ 
        
      Case #Layer_TypBG
        \name$ = "Background"+Str(LayerIdMax)
        \W_Repeat = 100
        \H_Repeat = 100
        Debug "bg !!!"
        
      Case #Layer_TypBitmap
        \name$ = "Layer"+Str(LayerIdMax)
        
      Case   #Layer_TypText
        \FontName$ = FontName$
        \FontSize  = FontSize
        \FontStyle = FontStyle
        \FontColor = FontColor
        \FontID = LoadFont(#PB_Any,\FontName$,\FontSize,\FontStyle)
        
        \w = 32
        \h = 32
        \name$ = "Text"+Str(LayerIdMax)
        \Text$ = txt$
        \x = x
        \y = y
        
      Default 
        \name$ = "Layer"+Str(LayerIdMax)
        
    EndSelect
    
    \NewW = \w
    \NewH = \h
    \CenterX = \w/2
    \CenterY = \h/2
    
    
    If \typ = #Layer_TypBG
      \Image = CreateImage(#PB_Any,\W_Repeat,\H_Repeat,32,#PB_Image_Transparent)
      ;Debug ImageWidth(\image)
    Else
      If OpenLayer = 0
        \Image = CreateImage(#PB_Any,\w,\h,32,#PB_Image_Transparent)
      EndIf
    EndIf
    
    ;{ set the images
    \ImageBM = -1
    \ImageAlpha = -1
    ; \Image = -1
    
    ; \ImageBM = CreateImage(#PB_Any,\w,\h,32,#PB_Image_Transparent)
    ;     \ImageAlpha = CreateImage(#PB_Any,\w,\h,32,#PB_Image_Transparent)
    ;     
    ;     If StartDrawing(ImageOutput(\ImageAlpha))
    ;       ;Box(0,0,\w,\h,RGBA(255,255,255,0))    
    ;       DrawingMode(#PB_2DDrawing_AlphaChannel)
    ;       ; Circle(\w/2,\h/2,50,RGBA(0,0,0,255))
    ;       Box(0,0,\w,\h,RGBA(0,0,0,0)) ; on efface tout
    ;       Box(0,0,\w,\h,RGBA(0,0,0,255)) ; et on révèle tout
    ;       
    ;       StopDrawing()
    ;     EndIf
    
    ;     If StartDrawing(ImageOutput(\Image))
    ;       Box(0,0,\w,\h,RGBA(255,255,255,255))    
    ;       DrawingMode(#PB_2DDrawing_AlphaChannel)
    ;       Box(0,0,\w,\h,RGBA(0,0,0,0))
    ;       StopDrawing()
    ;     EndIf
    ;}
    
    
    If \Typ = #Layer_TypText
      Layer_UpdateText(n,0,0,2)
    EndIf
    
    
    ; create the sprite only if we use the screen
    If OptionsIE\UseCanvas = 0
      
      \sprite= CreateSprite(#PB_Any, \w, \h, #PB_Sprite_AlphaBlending)
      If openlayer = 0
        If StartDrawing(SpriteOutput(\Sprite))
          Box(0,0,\w,\h,RGBA(255,255,255,255))
          DrawingMode(#PB_2DDrawing_AlphaChannel)
          Box(0,0,\w,\h,RGBA(0,0,0,0))
          DrawingMode(#PB_2DDrawing_AlphaBlend)
          Layer_DrawImg(LayerId,255)  
          StopDrawing()
        EndIf
      EndIf
      
    EndIf
    
    ; Debug "sprite size : "+Str(SpriteWidth(\sprite))+"/"+Str(SpriteHeight(\Sprite))
    ; Debug "Image size : "+Str(ImageWidth(\Image))+"/"+Str(ImageHeight(\Image))
    
    
    
  EndWith  
  
  ; SortStructuredArray(layer(), #PB_Sort_Ascending, OffsetOf(sLayer\ordre),  TypeOf(sLayer\ordre))
  ; SetGadgetState(#G_LayerList,LayerId)
   
  UpdateGadgetLayer(LayerId) ; set the parameters of the new layer( bm, opacity...)
  
  If openlayer = 0
    IE_UpdateLayerUi() 
  EndIf
  ; on ajoute 1 au nombre total de layers
  LayerNb + 1
  
  ; idem pour layer IDmax, c'est un nombre qu'on garde, pour avoir des id unique pour les calques.
  LayerIdMax + 1
  
EndProcedure
Procedure Layer_Delete()
  
  ; DeleteArrayElement(layer(), layerid)
  ; FreeGadget2(layer(LayerId)\IG_LayerMenu)
  
  FreeImage2(layer(LayerId)\Image)
  FreeImage2(layer(LayerId)\ImageBM)
  FreeImage2(layer(LayerId)\ImageAlpha)
  FreeImage2(layer(LayerId)\ImageTemp)
  FreeSprite2(layer(LayerId)\Sprite)
  
  If layerid <ArraySize(layer())
    
    For a=layerId To ArraySize(layer())-1
      Layer(a) = layer(a+1)
      Layer(a)\ordre -1
    Next
    
  EndIf
  
  ReDim layer(ArraySize(layer())-1)
  ; on update le gadget liste layer
  LayerNb - 1
  LayerId -1
  If layerid >ArraySize(layer())
    layerid = ArraySize(layer())
  EndIf
  Layer_UpdateList()
  CheckIfInf(LayerId,0)
  ScreenUpdate(1)
  
EndProcedure



; update & blendmode (bm)
Procedure SetBm(i,sprite=1,bm=-1)
  
  ; bm sprite
  If Sprite = 1
    DrawingMode(#PB_2DDrawing_AlphaBlend)  
    
    Select layer(i)\bm
        
      Case #Bm_Normal
        Box(0,0,doc\w,doc\w,RGBA(0,0,0,0))
        
      Case #Bm_Lighten,#Bm_Add, #bm_screen,#Bm_ColorBurn 
        Box(0,0,doc\w,doc\h,RGBA(0,0,0,255))
        
      Case #Bm_Multiply, #bm_darken
         Box(0,0,doc\w,doc\h,RGBA(255,255,255,255))
        
      Case #bm_Overlay, #Bm_LinearBurn, #Bm_Inverse, #Bm_LinearLight
        Box(0,0,doc\w,doc\h,RGBA(127,127,127,255))
        
    EndSelect
    
  Else
    ; bm image
    DrawingMode(#PB_2DDrawing_AllChannels)  
    
    If bm=-1
      bm = layer(i)\bm
    Else
    EndIf
    
    Select bm
        
      Case #bm_custom
        Box(0,0,doc\w,doc\h, RGBA(Brush(action)\ColorBG\R,Brush(action)\ColorBG\G, Brush(action)\ColorBG\B, Brush(action)\alpha))
        
      Case #Bm_Normal
        Box(0,0,doc\w,doc\h, RGBA(0,0,0,0))
        
      Case #Bm_Add, #Bm_Screen, #bm_lighten
        Box(0, 0, doc\w, doc\h, RGBA(0,0,0,255))                
       
      Case #Bm_Multiply, #Bm_ColorBurn, #Bm_Colorlight, #Bm_Darken
        Box(0, 0, doc\w, doc\h, RGBA(255,255,255,255))   
        
      Case #Bm_Overlay, #Bm_LinearBurn, #Bm_Inverse, #Bm_Exclusion, #bm_Difference, #Bm_Hardlight, #Bm_Clearlight,#Bm_LinearLight
        Box(0, 0, doc\w, doc\h, RGBA(127,127,127,255)) 
        
    EndSelect   
    
  EndIf
  
  
EndProcedure

; blendmode
Procedure Layer_ConvertToBm(i)
  
  If OptionsIE\UseCanvas=1
    
    If IsImage(layer(i)\ImageTemp) = 0 Or layer(i)\ImageTemp = 0
      Layer(i)\ImageTemp = CreateImage(#PB_Any, doc\w, doc\h, 32,#PB_Image_Transparent)
    EndIf
    
    If StartDrawing(ImageOutput(layer(i)\ImageTemp))
      
      DrawingMode(#PB_2DDrawing_AllChannels)
      
      ; erase the image
      ; Box(0, 0, doc\w, doc\h, RGBA(0,0,0,0))
      
      ; For the alpha mask // puis pour le mask alpha
      If layer(i)\MaskAlpha =1
        DrawingMode(#PB_2DDrawing_AlphaChannel)
        DrawAlphaImage(ImageID(Layer(i)\ImageAlpha),0,0)    
        
        DrawingMode(#PB_2DDrawing_CustomFilter)
        CustomFilterCallback(@Filtre_MaskAlpha())
      Else
        
      EndIf
      
      ; d'abord, on doit ajouter une box de la couleur nécessaire, pour certain BM
      SetBm(i,0) 
      
      ; draw the image
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      DrawAlphaImage(ImageID(layer(i)\Image), 0, 0, layer(i)\alpha)    
      
      StopDrawing()    
      
    EndIf
    
  EndIf

EndProcedure
Procedure Layer_GetBm(id)
  ; à changer si on ajoute des blendmode supplémentaires !
  ; Voir LAyer_SetBm()
  Select Layer(id)\bm
    Case #Bm_Normal
      bm = #SetBm_normal
      
    Case #Bm_Multiply
      bm = #SetBm_multiply
      
    Case #Bm_Add
      bm = #SetBm_Add
      
    Case #Bm_Screen
      bm = #SetBm_Screen
      
    Case #Bm_Clearlight
      bm = #SetBm_ClearLight
      
    Case #Bm_ColorBurn
      bm = #SetBm_ColorBurn
      
    Case #Bm_Darken
      bm = #SetBm_Darken
      
    Case #Bm_LinearLight
      bm = #SetBm_LinearLight
      
    Case #Bm_Overlay
      bm = #SetBm_Overlay
      
    Case #Bm_Inverse
      bm = #SetBm_Invert
      
    Case #Bm_LinearBurn
      bm = #SetBm_LinearBurn
      
    Case #Bm_Lighten
      bm = #SetBm_Lighten
      
  EndSelect
  ProcedureReturn bm
EndProcedure
Procedure Layer_SetBm(i, bm)
  
  ; slect the blendmode and set the good constant to the layer
  Select bm
      
    Case #SetBm_normal
      Layer(i)\bm = #Bm_Normal
      
    Case #SetBm_Multiply 
      Layer(i)\bm = #Bm_Multiply
      
    Case #SetBm_Add
      Layer(i)\bm = #Bm_Add
      
    Case #SetBm_Screen
      Layer(i)\bm = #Bm_Screen
      
    Case #SetBm_ClearLight
      Layer(i)\bm = #Bm_Clearlight
      
    Case #SetBm_Darken
      Layer(i)\bm = #Bm_Darken
      
    Case #SetBm_ColorBurn
      Layer(i)\bm = #Bm_ColorBurn
      
    Case #SetBm_LinearLight
      Layer(i)\bm = #Bm_LinearLight
      
    Case #SetBm_LinearBurn
      Layer(i)\bm = #Bm_LinearBurn
      
    Case #Setbm_Overlay
      Layer(i)\bm = #Bm_Overlay
      
    Case #SetBm_Invert
      Layer(i)\bm = #Bm_Inverse
      
    Case #SetBm_Lighten
      Layer(i)\bm = #Bm_Lighten
      
    Case #SetBm_Custom
      Layer(i)\bm = #Bm_Custom
      
  EndSelect
  
  ;Layer_SetSpriteToImage_()

  ; convert the image of layer if neeeded (add a colored box (with white, black, grey) for some blendmode)
  Layer_ConvertToBm(i)
  
  
EndProcedure


Procedure Layer_Bm2(i) ; pour calculer le bm sur les images // calcul the bm on images
  
  ; puis on fixe le bm // set the bm
  Select layer(i)\bm 
      
    Case #Bm_Normal ; normal            
      DrawingMode(#PB_2DDrawing_AlphaBlend | #PB_2DDrawing_Transparent)
      
    Case #Bm_Add                        
      DrawingMode(#PB_2DDrawing_CustomFilter | #PB_2DDrawing_Transparent)                 
      CustomFilterCallback(@bm_add()) 
      
    Case #Bm_Multiply              
      DrawingMode(#PB_2DDrawing_CustomFilter | #PB_2DDrawing_Transparent)     
      CustomFilterCallback(@bm_multiply())
      
    Case #Bm_overlay               
      DrawingMode(#PB_2DDrawing_CustomFilter | #PB_2DDrawing_Transparent)     
      CustomFilterCallback(@bm_overlay())
      
    Case #Bm_screen             
      DrawingMode(#PB_2DDrawing_CustomFilter | #PB_2DDrawing_Transparent)     
      CustomFilterCallback(@bm_screen()) 
      
    Case #Bm_Inverse                
      DrawingMode(#PB_2DDrawing_XOr|#PB_2DDrawing_AlphaBlend)
      
    Case #Bm_ColorBurn
      DrawingMode(#PB_2DDrawing_CustomFilter)     
      CustomFilterCallback(@bm_ColorBurn()) 
      
    Case #Bm_Dissolve               
      DrawingMode(#PB_2DDrawing_CustomFilter | #PB_2DDrawing_Transparent)     
      CustomFilterCallback(@bm_Dissolve()) 
      
    Case #bm_Difference
      DrawingMode(#PB_2DDrawing_CustomFilter | #PB_2DDrawing_Transparent)     
      CustomFilterCallback(@bm_difference()) 
      
    Case #Bm_Darken
      DrawingMode(#PB_2DDrawing_CustomFilter | #PB_2DDrawing_Transparent)     
      CustomFilterCallback(@bm_darken())  
      
    Case #Bm_Lighten
      DrawingMode(#PB_2DDrawing_CustomFilter | #PB_2DDrawing_Transparent)     
      CustomFilterCallback(@bm_lighten())    
      
    Case #Bm_Exclusion
      DrawingMode(#PB_2DDrawing_CustomFilter | #PB_2DDrawing_Transparent)     
      CustomFilterCallback(@bm_Exclusion())   
      
    Case #Bm_Clearlight
      DrawingMode(#PB_2DDrawing_CustomFilter | #PB_2DDrawing_Transparent)     
      CustomFilterCallback(@bm_clearlight())  
      
    Case #Bm_Hardlight
      DrawingMode(#PB_2DDrawing_CustomFilter | #PB_2DDrawing_Transparent)     
      CustomFilterCallback(@bm_hardlight())  
      
    Case #Bm_Colorlight
      DrawingMode(#PB_2DDrawing_CustomFilter | #PB_2DDrawing_Transparent)     
      CustomFilterCallback(@bm_ColorLight()) 
      
  EndSelect
  
EndProcedure
Procedure Layer_Bm(i) ; pour le bm sur les sprite (l'affichage) // bm on sprite (preview)
  
  Select layer(i)\bm 
      
    Case #Bm_Normal
      SpriteBlendingMode(#PB_Sprite_BlendSourceAlpha, #PB_Sprite_BlendInvertSourceAlpha)
      
    Case #Bm_Add
      ; SpriteBlendingMode(#PB_Sprite_BlendOne,#PB_Sprite_BlendInvertSourceAlpha) 
      SpriteBlendingMode(#PB_Sprite_BlendOne,#PB_Sprite_BlendOne) 
      
    Case #Bm_Screen
      SpriteBlendingMode(#PB_Sprite_BlendOne,#PB_Sprite_BlendInvertSourceColor) 
      
    Case #Bm_Darken
      SpriteBlendingMode(5,7)  
      
    Case #Bm_Multiply
      ; SpriteBlendingMode(5,4)  
      SpriteBlendingMode(0,2)  
      
    Case #Bm_Lighten
      ; SpriteBlendingMode(#PB_Sprite_BlendDestinationColor,#PB_Sprite_BlendOne)  
      SpriteBlendingMode(4,8)  
      
    Case #Bm_Clearlight
      SpriteBlendingMode(2,4)        
      
    Case  #Bm_ColorBurn
      ; SpriteBlendingMode(10,6)  
      SpriteBlendingMode(4,0)  
      ; color burn//sqr - (color burn)  puissance
      
    Case  #Bm_Overlay
      ;SpriteBlendingMode(4,4)  
      SpriteBlendingMode(2,4)  
      
      ;Case  #Bm_Overlay2
      ;SpriteBlendingMode(2,4)  
      
    Case  #Bm_Inverse
      SpriteBlendingMode(5,0)  
      
    Case  #Bm_LinearBurn
      ; SpriteBlendingMode(4,1)  
      SpriteBlendingMode(4,6)  
      
    Case #Bm_Custom
      SpriteBlendingMode(Blend1,blend2)  
      
    Case  #Bm_LinearLight
      SpriteBlendingMode(4,2)  
      ;// light burn    
      
      
  EndSelect
  
EndProcedure



; Images
Procedure Layer_ClipSprite(i)
  
;   If movecanvas
;     If i <> layerID
;       If canvasX < 0
;         c__x=-canvasX
;       EndIf
;       If canvasY < 0
;         c__y=-canvasY
;       EndIf
;       If canvasX < 0
;         c__x1 = 0
;       EndIf
;       If canvasY < 0
;         c__y1 = 0
;       EndIf
;       ClipSprite(Layer(i)\Sprite, c__x, c__y, GadgetWidth(#G_CanvasMain), GadgetHeight(#G_CanvasMain))
;     Else
;       ClipSprite(Layer(i)\Sprite, #PB_Default , #PB_Default  , #PB_Default , #PB_Default )
;     EndIf
;   EndIf
  
EndProcedure
Procedure Layer_UpdateImg()
  
;   If layer(layerid)\Haschanged = 1
;     layer(layerid)\Haschanged = 2
;     CopySprite(Layer(layerid)\sprite, #Sp_CopyForsave, #PB_Sprite_AlphaBlending)
;     file$ = "saveForImg_"+Str(layerId)+".png"
;     SaveSprite(#Sp_CopyForsave,file$,#PB_ImagePlugin_PNG)
;     FreeSprite2(#Sp_CopyForsave)
;     FreeImage2(Layer(LayerId)\Image)
;     Layer(LayerId)\Image = LoadImage(#PB_Any,file$) 
;   EndIf
  
EndProcedure
Procedure Layer_updateAllBMSprite()
  
  ; Debug "ok LAyer_updateAllBMSprite()"
  
  oldlayerid = layerId
  
  For i =0 To ArraySize(layer())
    
    layerId = i
    ; Debug "layerid : "+Str(layerId)
    newpainting = 1
    ScreenUpdate(1)
;     
;     If layer(i)\bm = #Bm_Normal
;       alpha= 255
;     Else
;       alpha = layer(i)\Alpha 
;     EndIf
;     
;     If StartDrawing(SpriteOutput(layer(i)\Sprite))
;       ; on l'efface
;       DrawingMode(#PB_2DDrawing_AlphaChannel)
;       Box(0,0,w,h,RGBA(0,0,0,0))
;       ; puis on redessine tout
;       
;       ; DrawingMode(#PB_2DDrawing_AlphaBlend)
;       
;       SetAlphaMask()
;       
;       Select layer(i)\bm 
;         Case #Bm_Normal          
;           ; SetAlphaMask()
;           Layer_DrawImg(i, alpha)
;           Debug "sprite bm normal"
;           
;         Case #Bm_Add, #Bm_Clearlight, #Bm_Screen, #Bm_Colorlight, #Bm_Lighten
;           Box(0,0,w,h,RGBA(0,0,0,255))
;           ; DrawAlphaImage(ImageID(Layer(LayerId)\ImageBM),0,0)
;           ; SetAlphaMask()
;           Layer_DrawImg(i, alpha)
;           
;         Case #Bm_Darken, #Bm_Multiply, #Bm_LinearBurn
;           Box(0,0,w,h,RGBA(255,255,255,255))
;           ; SetAlphaMask()
;           Layer_DrawImg(i, alpha)
;           Debug "sprite bm multiply"
;           
;         Case #bm_overlay
;           ;, #Bm_LinearBurn
;           ; Box(0,0,w,h,RGBA(0,0,0,255))
;           Box(0,0,w,h,RGBA(60,60,60,255))
;           ; DrawAlphaImage(ImageID(Layer(LayerId)\ImageBM),0,0,layer(layerid)\alpha)
;           ; SetAlphaMask()
;           Layer_DrawImg(i, layer(i)\alpha)
;           
;         Default 
;           Box(0,0,w,h,RGBA(255,255,255,255-layer(i)\alpha))
;           ; DrawAlphaImage(ImageID(Layer(LayerId)\ImageBM),0,0,layer(layerid)\alpha)
;           ; SetAlphaMask()
;           Layer_DrawImg(i, layer(i)\alpha)
;           
;       EndSelect
;       
;       StopDrawing()
;     EndIf
;     
  Next
  
  layerId = oldlayerid
  
EndProcedure
Procedure Layer_UpdateSprite_(a)
  
  If StartDrawing(SpriteOutput(layer(a)\Sprite))
    
    ; on l'efface
    DrawingMode(#PB_2DDrawing_AlphaChannel)
    Box(0, 0, layer(a)\w, layer(a)\h, RGBA(0,0,0,0))
        
    ; get alpha
    If layer(a)\bm = #Bm_Normal
      alpha= 255
    Else
      alpha = layer(a)\Alpha 
    EndIf
    
   
    SetAlphaMask(a)
    
      ; puis on redessine tout
      Select layer(a)\bm 
        Case #Bm_Normal          
          Layer_DrawImg(a, alpha)
          
        Case #Bm_Add, #Bm_Clearlight, #Bm_Screen, #Bm_Colorlight, #Bm_Lighten
          Box(0,0,w,h,RGBA(0,0,0,255))
          Layer_DrawImg(a, alpha)
          
        Case #Bm_Darken, #Bm_Multiply, #Bm_LinearBurn
          Box(0,0,w,h,RGBA(255,255,255,255))
          Layer_DrawImg(a, alpha)
          
        Case #bm_overlay
          ;, #Bm_LinearBurn
          ; Box(0,0,w,h,RGBA(0,0,0,255))
          Box(0,0,w,h,RGBA(60,60,60,255))
          Layer_DrawImg(a, layer(a)\alpha)
          
        Default 
          Box(0,0,w,h,RGBA(255,255,255,255-layer(a)\alpha))
          Layer_DrawImg(a, layer(a)\alpha)
          
      EndSelect
      
      StopDrawing()
  EndIf

EndProcedure
Procedure Layer_UpdateSprite(a)
  
  If StartDrawing(SpriteOutput(layer(a)\Sprite))
    
    ; on l'efface
    DrawingMode(#PB_2DDrawing_AlphaChannel)
    Box(0, 0, OutputWidth(), OutputHeight(), RGBA(0,0,0,0))
    
    ; get alpha
    If layer(a)\bm = #Bm_Normal
      alpha= 255
    Else
      alpha = layer(a)\Alpha 
    EndIf
    
    DrawingMode(#PB_2DDrawing_AlphaBlend) 
    DrawAlphaImage(ImageID(layer(a)\Image),  0, 0, alpha)
    
    StopDrawing()
  EndIf
  
  
EndProcedure
Procedure Layer_UpdateAll()
  
  ; to update all layers (image +sprite if screen or canvas)
  For i = 0 To ArraySize(layer())
    
    If OptionsIE\UseCanvas =  0
      ; we use the screen
      Layer_UpdateSprite(i)  
      
    ElseIf OptionsIE\UseCanvas =  1
      
      Layer_ConvertToBm(i)
      
      ; we use the canvas for rendering
;       If StartDrawing(ImageOutput(layer(i)\Image))
;         
;         DrawingMode(#PB_2DDrawing_AlphaChannel)
;         Box(0, 0, layer(i)\w, layer(i)\h, RGBA(0,0,0,0))
;         
;         ; display the alpha mask if used 
;         If layer(i)\MaskAlpha =1
;           DrawingMode(#PB_2DDrawing_AlphaChannel)
;           DrawAlphaImage(ImageID(Layer(i)\ImageAlpha),0,0)    
;           
;           DrawingMode(#PB_2DDrawing_CustomFilter)
;           CustomFilterCallback(@Filtre_MaskAlpha())
;         Else
;           DrawingMode(#PB_2DDrawing_AlphaBlend)
;         EndIf
;         
;         ; draw the image (Background repeated or simple image)
;         Layer_DrawImg(i,255)
;         
;         StopDrawing()
;       EndIf
      
    EndIf
    
  Next 
  
EndProcedure
Procedure Layer_UpdateForRenderingSystem()
  
  ; Update the images / sprites for the rendering system, 
  ; for example, after choosing another system
  ; oldLayerId = LayerId
  
  If OptionsIE\UseCanvas = 1
    ; update the rendering system for the canvas
    
    ; update the paper
    FreeSprite2(#Sp_Paper)
    FreeSprite2(#Sp_PaperColor)
   ; Debug "set Renderer to canvas"
    
    PaperCreate()
    PaperUpdate(1)
    
    For i = 0 To ArraySize(layer())
      ; delete the sprite
      FreeSprite2(layer(i)\Sprite)
      layer(i)\sprite= -1
      ;Debug "layer "+Str(i)+" nom : "+layer(i)\name$+" / image : "+Str(layer(i)\image)+" / imagetemp : "+Str(layer(i)\imagetemp)
      ;Debug "layer "+Str(i)+" nom : "+layer(i)\name$+" / bm : "+Str(layer(i)\Bm)
      
      ; layerId = i
      ; create the image if needed
      Layer_ConvertToBm(i)
    Next
    
  Else
   ; Debug "set Renderer to screen"
    
    ; update the paper
    FreeImage2(#Img_PaperForMainCanvas)
    PaperCreate()
    PaperUpdate(1)
    
    ; update the rendering system for Screen
    For i = 0 To ArraySize(layer())
      
      ; delete image
      FreeImage2(layer(i)\ImageBM)
      FreeImage2(layer(i)\ImageTemp)
      layer(i)\ImageTemp = -1
      layer(i)\ImageBM = -1
      
     
      ;Debug "layer "+Str(i)+" nom : "+layer(i)\name$+" / bm : "+Str(layer(i)\Bm)
      ; layerId = i
      ; create the sprite if needed
      If Not IsSprite(layer(i)\Sprite) Or layer(i)\Sprite <= 0
        layer(i)\sprite= CreateSprite(#PB_Any, layer(i)\w, layer(i)\h, #PB_Sprite_AlphaBlending)
      EndIf
      
      info$ = "layer "+Str(i)+" nom : "+layer(i)\name$+
              " / image : "+Str(layer(i)\image)+
              " / imagetemp : "+ Str(layer(i)\imagetemp)+
              " / sprite : "+Str(layer(i)\sprite)
      
      Debug info$ 
    Next
    
    For i = 0 To ArraySize(layer())
      ;layerId = i
      Layer_UpdateSprite(i)
      ;newpainting = 1
      ;ScreenUpdate(1)
    Next
    
    ; Layer_updateAllBMSprite()

  EndIf
  ; LayerId = oldLayerId
  
  ;  update  screen
  ; Layer_UpdateList()
  NewPainting =1
  ScreenUpdate(0)
  
EndProcedure
Procedure Layer_UpdateElementsForRenderingSystem()
  
  Layer_UpdateForRenderingSystem()
  
  newpainting = 1
  ScreenUpdate(1)
    
EndProcedure

; selection
Procedure Layer_DrawSelection(x.f=-1, y.f=-1, color.q=-1, realtime = 0)
  
  ; to draw or erase the selection
  If realtime = 1
    
    If OptionsIE\Selection >= 1

      ; draw on the screen or the canvas.
      z.d = OptionsIE\zoom * 0.01
      x = canvasX + OptionsIE\SelectionX * z
      y = canvasY + OptionsIE\Selectiony * z
      w = OptionsIE\SelectionW * Z
      h = OptionsIE\SelectionH * z
      
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_XOr)
    
      ; The selection
      Select OptionsIE\SelectionType
          
        Case #selectionRectangle
          Box(x, y, w, h, RGB(0,0,0))
          
        Case #selectionCircle
          Ellipse(x+W/2, y+h/2, w/2, h/2, RGB(0,0,0))
          
      EndSelect
      
    EndIf
    
  Else
    ;{ draw on the sprite or an image on the canvas.
    If x=-1
      x = OptionsIE\SelectionX
    EndIf
    If y = -1
      y = OptionsIE\SelectionY
    EndIf
    w = OptionsIE\SelectionW
    h = OptionsIE\SelectionH
    
    If color = -1
      color = RGBA(0,0,0,0)
    EndIf
    
    Select OptionsIE\SelectionType 
      Case #selectionRectangle
        Box(x, y, w, h, color)
        
      Case #selectionCircle
        Ellipse(x+W/2, y+h/2, w/2, h/2, color)
        
    EndSelect
    ;}
  EndIf

EndProcedure


; draw
Procedure Layer_DrawImg(u, alpha)
  
  ; to draw the image of layer (normal or "background repeated layer")

  If layer(u)\Typ = #Layer_TypBG
    
    For i=0 To layer(u)\w / layer(u)\W_Repeat 
      For j =0 To layer(u)\h / layer(u)\H_Repeat 
        DrawAlphaImage(ImageID(layer(u)\image),i * layer(u)\W_Repeat ,j * layer(u)\H_Repeat, alpha)
      Next 
    Next 
    
  Else
    
    DrawAlphaImage(ImageID(layer(u)\image), 0, 0, alpha)

  EndIf  
  
EndProcedure
Procedure Layer_Draw_OnScreen(i)
  
  ; to draw a layer on the screen-canvas
  z.d = OptionsIE\zoom * 0.01
  w.d = Layer(i)\w * z
  h.d = Layer(i)\h * z
  Layer_Bm(i)
  
  ; the zoom
  ZoomSprite(Layer(i)\Sprite, w, h)
  
  ; the clipping
;   c__x1 = canvasX
;   c__y1 = canvasY
  
  ;   Layer_clipSprite(i)
  
;   If i <> layerID
;     If canvasX < 0
;       cx=-canvasX
;     EndIf
;     If canvasY < 0
;       cy=-canvasY
;     EndIf
;     If canvasX < 0
;       cx1 = 0
;     EndIf
;     If canvasY < 0
;       cy1 = 0
;     EndIf
;     ClipSprite(Layer(i)\Sprite, cx, cy, GadgetWidth(#G_CanvasMain), GadgetHeight(#G_CanvasMain))
;   Else
;     ClipSprite(Layer(i)\Sprite, #PB_Default , #PB_Default  , #PB_Default , #PB_Default )
;   EndIf
  
   DisplayTransparentSprite(Layer(i)\Sprite, canvasX+layer(i)\x * z, canvasY+layer(i)\y * z, layer(i)\alpha)
  ; DisplayTransparentSprite(Layer(i)\Sprite,c__x1+layer(i)\x * z, c__y1+layer(i)\y * z, layer(i)\alpha)
  SpriteBlendingMode(#PB_Sprite_BlendSourceAlpha, #PB_Sprite_BlendInvertSourceAlpha)
  
EndProcedure
Procedure Layer_DrawBorder(i)
  
  If layer(i)\selected Or OptionsIE\Selection >= 1
    
    z.d = OptionsIE\zoom * 0.01
    
    If StartDrawing(ScreenOutput())
      DrawingMode(#PB_2DDrawing_Outlined)
      ; layer border // bordure du calque
      If layer(layerId)\selected
        Box(canvasX+Layer(layerId)\x*z,canvasY+layer(layerID)\y*z,layer(layerId)\w*Z,layer(layerId)\h*z,RGB(255,0,0))
      EndIf
      
      ; selection
      Layer_DrawSelection(0, 0, RGB(0,0,0), 1)
      
      StopDrawing()
    EndIf
    
  EndIf
  
EndProcedure
Procedure Layer_DrawAll()
  
  ; to draw all layers on screen with sprite
  For i=0 To ArraySize(layer())
    If Layer(i)\view 
      Layer_Draw_OnScreen(i)
;       If i = layerId
;         If OptionsIE\Shape=1 
;           ;DisplayTransparentSprite(#Sp_LayerTempo, canvasX, canvasY, layer(layerid)\alpha)  
;         EndIf
;       EndIf  
    EndIf
  Next i
  
EndProcedure
Procedure Layer_Draw_OnCanvas(i)
  
  ; to draw the layer on the canvas
  
  Shared useCanvasPosition2
  
  ; define the position
  x = 0
  y = 0
  If useCanvasPosition2
    x = canvasX
    y = canvasY
  EndIf
  
  
  ; set the drawingmode
  Layer_Bm2(i)
  
  ; select the image to draw on the canvas
  If layer(i)\Bm = #bm_normal
    DrawAlphaImage(ImageID(layer(i)\Image), x + layer(i)\x, y + layer(i)\y , layer(i)\Alpha)
  Else
    DrawAlphaImage(ImageID(layer(i)\ImageTemp), x + layer(i)\x, y + layer(i)\y , layer(i)\Alpha)
  EndIf
  
;   If layer(i)\Bm <> 0
;     DrawingMode(#PB_2DDrawing_AlphaBlend)
;   EndIf
  
EndProcedure
; draw temporary layer
Procedure Layer_DrawTempo()
  
  If OptionsIE\Shape >=1
    If action >= #Action_Line And Action <= #Action_Gradient
      
      x = OptionsIE\ShapeX
      y = OptionsIE\ShapeY
      w = OptionsIE\shapeW
      h = OptionsIE\shapeH
      col = RGBA(Brush(Action)\ColorBG\R, Brush(Action)\ColorBG\G, Brush(Action)\ColorBG\B, Brush(Action)\alpha)
      
      If OptionsIE\ShapeTyp >=1 And action >= #Action_Line
        OptionsIE\Shape = 2
        If StartDrawing(SpriteOutput(layer(LayerId)\Sprite))
          DrawShape(0)
          StopDrawing()
        EndIf
        If StartDrawing(ImageOutput(layer(LayerId)\Image))
          DrawShape(0)
          StopDrawing()
        EndIf
        Debug "ici"
      Else
        If Not IsSprite(#sp_LayerTempo)
          CreateLayertempo_(1)
        EndIf
        If StartDrawing(SpriteOutput(#sp_LayerTempo))
          DrawShape() ; macro in paint.pbi
          StopDrawing()
        EndIf
      EndIf
;     Else
;       ; clonestamp use layer_tempo to draw on it the 
;       If action = #Action_CloneStamp
;         If StartDrawing(SpriteOutput(#sp_LayerTempo))
;           DrawShape()
;           StopDrawing()
;         EndIf
;       EndIf
      
    EndIf
    
  Else
    
    
  EndIf
  
EndProcedure




; free, clear
Procedure Layer_FreeAll()
  
  ; procedure to free all the layers, for example when create a new document
  ; procedure qu'on utilise pour supprimer tous les layers.
  ; Par exemple, lorsqu'on crée un nouveau document
  
  For i = 0 To ArraySize(layer())
    
    ; Image for layer
    FreeImage2(Layer(i)\Image)
    FreeImage2(Layer(i)\ImageBM)
    FreeImage2(Layer(i)\ImageTemp)
    FreeImage2(Layer(i)\ImgLayer)
    FreeImage2(Layer(i)\ImageAlpha)
    FreeImage2(Layer(i)\ImageStyle) ; -> isn't used for the moment
    
    ; image for UI
    ; FreeGadget(Layer(i)\IG_LayerMenu)
    
    ; Image for Preview on screen
    FreeSprite2(Layer(i)\Sprite)
    
  Next i
  
  ; Then redim the layer() array and reset variable for layers
  ReDim Layer(0)
  LayerNb = 0
  LayerIdMax = 0
  
EndProcedure
Procedure Layer_Clear(i, onlyAlpha=0)
  
  ; define the image to clear or cut
  If layer(i)\MaskAlpha = 2
    img = layer(i)\ImageAlpha
  Else
    img = layer(i)\image
  EndIf
  
  ; erase sprite and image.  
  If StartDrawing(ImageOutput(img))
    ; If onlyAlpha = 1
    DrawingMode(#PB_2DDrawing_AllChannels)
    If OptionsIE\Selection = 0
      ;Box(0,0,LAyer(i)\W+20,LAyer(i)\h+20,RGBA(255,255,255,255))
      Box(0, 0, OutputWidth(), OutputHeight(), RGBA(0,0,0,0))
    Else
     
      Layer_DrawSelection()
      
    EndIf
    ;EndIf    
    StopDrawing()
  EndIf
  
  If StartDrawing(SpriteOutput(layer(i)\Sprite))
    ;     If onlyAlpha = 1
    ;       Box(0, 0, Layer(i)\w+20,Layer(i)\h+20,RGBA(255,255,255,255))
    ;     EndIf    
    ;     DrawingMode(#PB_2DDrawing_AlphaChannel)
    ;     Box(0, 0, Layer(i)\w+20,Layer(i)\h+20,RGBA(0,0,0,0))
    
    DrawingMode(#PB_2DDrawing_AllChannels)
    If OptionsIE\Selection = 0
      ;Box(0,0,LAyer(i)\W+20,LAyer(i)\h+20,RGBA(255,255,255,255))
      w = OutputWidth()
      h = OutputHeight()
      Box(0, 0, w, h, RGBA(0,0,0,0))
    Else
      w = OptionsIE\SelectionW
      h = OptionsIE\SelectionH
      Layer_DrawSelection()
    EndIf
    StopDrawing()
  EndIf 
  
  ; because the layer is eraser, change the haschanged parameter
  Layer(i)\Haschanged = 0
  
  ; update the screen or canvas.
  NewPainting = 1
  ScreenUpdate(1) 
  
EndProcedure



; change position (order in the layer list)
Procedure Layer_ChangePos(up=1)
  
  ; up = 1 : on monte d'une position
  ; up = -1, on descnd d'une position
  
  ; on verifie qu'on peut bien bouger le layer courrant
  
  ; Debug Str(Layerid)+ " - "+Str(Layer(LayerId)\ordre) + "/"+Str(ArraySize(layer()))
  
  If (up=1 And Layer(LayerId)\ordre<ArraySize(layer()))  Or (up=-1 And Layer(LayerId)\ordre>0)
    
    i = layerid
    j = layerid+up
    layer(LayerId)\ordre + up
    NewOrdre = layer(LayerId)\ordre
    layer(LayerId+up)\ordre - up
    
    ; Trie le tableau en fonction du champ 'ordre' qui est un long  ;
    If up=1
      SortStructuredArray(layer(), #PB_Sort_Ascending, OffsetOf(slayer\ordre),  TypeOf(slayer\ordre),i, j)
    Else
      SortStructuredArray(layer(), #PB_Sort_Ascending, OffsetOf(slayer\ordre),  TypeOf(slayer\ordre),j, i)
    EndIf
    
    
    For i = 0 To ArraySize(layer())
      If layer(i)\ordre = NewOrdre
        LayerId = i
        Break
      EndIf
    Next i
    
    Layer_UpdateList()
    ScreenUpdate()
    
    ; IE_UpdateLayerUi() 
    ; SetGadgetState(#G_LayerList,LayerId)
    
  EndIf
  
EndProcedure



; operation on layers 
Procedure Layer_Merge(mode=0)
  
  ; procedure to merge several layers.
  ; this procedure does'nt have the features : merge linked layers (I will add that in a Next version)
  ; Mode = 0 : merge 2 layer (to bottom)
  ; mode = 1 : merge All layers 
  ; mode = 2 : merge All layers visible 
  
  ; because we merge, we have to tell the software it's a newaction (newpainting)
  NewPainting = 1
  
  ; check if we have enough layer to merge
  If ArraySize(layer()) < 1
    
     MessageRequester(lang("Error"), Lang("You need at least 2 layers to do this operation."))

   Else
     
    ; ok, we have enough layers to merge.
    If mode = 0 ; Only Two layers (from top to bottom) // seulement 2 layer vers le bas
      
      
;       For i =0 To ArraySize(layer())
;         If i = layerId Or i = layerId-1
;           Debug "Calque N° "+Str(i)
;         EndIf
;       Next
      
      ; check if 2 layer are viewed
      If layerid = 0 
        MessageRequester(lang("Error"), lang("Can't merge a layer at the bottom of the layer list."))
        
      ElseIf layer(layerId)\view = 0 Or layer(layerId-1)\view = 0 
        
        MessageRequester(lang("Error"), lang("Your layers must be seen before to merge them."))
        
      Else
        
        ; convert the layer bm if needed
        Layer_convertToBm(LayerId-1)
        Layer_convertToBm(LayerId)
        
        ; create the temp image (result of merging)
        Tmp = CreateImage(#PB_Any, doc\w, doc\h, 32, #PB_Image_Transparent)
        
        ; drawing the "merge" on this image
        If StartDrawing(ImageOutput(tmp))
          ;DrawingMode(#PB_2DDrawing_AlphaBlend)
          
          
          For j= 0 To 1
            i = LayerId-1+j
            Layer_Bm2(i)
            If layer(i)\Bm = #bm_normal
              DrawAlphaImage(ImageID(layer(i)\Image),0,0,layer(i)\alpha) 
            Else
              DrawAlphaImage(ImageID(layer(i)\ImageTemp),0,0,layer(i)\alpha) 
            EndIf
          Next
         ; Layer_Bm2(LayerId)
         ; DrawAlphaImage(ImageID(layer(LayerId)\ImageTemp),0,0,layer(layerId)\alpha) 
          
          StopDrawing()
        EndIf
        
        FreeImage2(layer(LayerId-1)\Image)
        Layer(LayerId-1)\Image = CopyImage(tmp,#PB_Any)
        FreeImage2(tmp)
        Layer_Delete()
        
      EndIf
      
    ElseIf mode = 1 ; merge all
      
      ; CHange the image with blendmode // d'abord, on doit modifier l'image en fonction du blendmode
      For i = 0 To ArraySize(layer())
        With layer(i)
          If \view
            Layer_convertToBm(i)
          EndIf
        EndWith
      Next i
      
      ; ensuite on crée une image temporaire sur laquelle on va dessiner tous les calques
      Tmp = CreateImage(#PB_Any,doc\w,doc\h,32,#PB_Image_Transparent)
      If StartDrawing(ImageOutput(tmp))
        DrawingMode(#PB_2DDrawing_AlphaBlend)  
        For i = 0 To ArraySize(layer())
          With layer(i)
            If \view
              Layer_Bm2(i)
              DrawAlphaImage(ImageID(\ImageTemp),0,0,\alpha) 
            EndIf
          EndWith
        Next i
        StopDrawing()
      EndIf
      
      ; puis on libère la mémoire, on supprime ce qui ne sert plus.
      Layer_FreeAll() 
      Layer_Add()
      FreeImage2(Layer(layerId)\Image)
      Layer(LayerId)\Image = CopyImage(tmp,#PB_Any)
      FreeImage2(tmp)
      
    ElseIf mode = 2 ; merge visible
      
      ; MessageRequester(lang("Infos"), lang("Not implemented"))
       ; CHange the image with blendmode // d'abord, on doit modifier l'image en fonction du blendmode
      For i = 0 To ArraySize(layer())
        With layer(i)
          If \view
            Layer_convertToBm(i)
          EndIf
        EndWith
      Next i
      
      ; ensuite on crée une image temporaire sur laquelle on va dessiner tous les calques
      Tmp = CreateImage(#PB_Any,doc\w,doc\h,32,#PB_Image_Transparent)
      
      If StartDrawing(ImageOutput(tmp))
        DrawingMode(#PB_2DDrawing_AlphaBlend)  
        For i = 0 To ArraySize(layer())
          With layer(i)
            If \view
              Layer_Bm2(i)
              DrawAlphaImage(ImageID(\ImageTemp),0,0,\alpha) 
            EndIf
          EndWith
        Next i
        StopDrawing()
      EndIf
      
      ; Then delete visible layers and free memro // puis on libère la mémoire, on supprime ce qui ne sert plus.
      For i = 0 To ArraySize(layer())
          With layer(i)
            If \view
              Layer_delete()
              If i > 0
                i-1
              EndIf
            EndIf
          EndWith
        Next i
     
      ; FreeImage2(Layer(layerId)\Image)
      Layer(LayerId)\Image = CopyImage(tmp,#PB_Any)
      Layer(LayerId)\Image = tmp
      ; FreeImage2(tmp)
      
      
    ElseIf mode = 3 ; merge linked
      
      MessageRequester(lang("Infos"), lang("Not implemented"))

      
    EndIf
    
  EndIf
  
EndProcedure
Procedure Layer_Fill(mode=0)
  
  i = layerID
  
  If layer(i)\MaskAlpha >= 2
    img = layer(i)\ImageAlpha
  Else
    img = layer(i)\image
  EndIf
  
  If layer(i)\MaskAlpha = 3
    MessageRequester(Lang("Info"),Lang("The layer mask is hiden"))
    ProcedureReturn 0
  EndIf
  
  If mode = 0 ; on remplit avec une couleur
    
    tmp = CopyImage(Img, #PB_Any)
   
    
    If StartDrawing(ImageOutput(tmp))
      DrawingMode(#PB_2DDrawing_AllChannels)
      Box(0,0,doc\w,doc\h, RGBA(Red(Brush(Action)\ColorBG\R),Brush(Action)\ColorBG\G,Brush(Action)\ColorBG\B,255))
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      DrawAlphaImage(ImageID(Img),0,0)      
      StopDrawing()
    EndIf
    FreeImage2(Img)
    If layer(i)\MaskAlpha = 2
      layer(i)\ImageAlpha= CopyImage(tmp,#PB_Any)
    Else
      layer(i)\image= CopyImage(tmp,#PB_Any)
    EndIf
    Newpainting = 1
    ScreenUpdate()
    FreeImage2(tmp)
    
  ElseIf mode = 1 ; on efface le calque avec le couleur de fond
    
    If StartDrawing(ImageOutput(img))
      DrawingMode(#PB_2DDrawing_AllChannels)
      Box(0,0,doc\w,doc\h, RGBA(Red(Brush(Action)\ColorBG\R),Brush(Action)\ColorBG\G,Brush(Action)\ColorBG\B,255))
      StopDrawing()
    EndIf
    Newpainting = 1
    ScreenUpdate()
    
  ElseIf mode = 2 ; on remplit (en effaçant) avec un pattern
    
    File$ = OpenFileRequester("Open An image","","Image|*.jpg;*.png;*.bmp",0)
    If file$ <>"" 
      
      tmp = LoadImage(#PB_Any, file$)
      If tmp <> 0
        
        w = ImageWidth(tmp)
        h = ImageHeight(tmp)
        
        ; tmp = CopyImage(layer(layerId)\Image, #PB_Any)
        If StartDrawing(ImageOutput(img))
          DrawingMode(#PB_2DDrawing_AllChannels)
          Box(0,0,doc\w,doc\h, RGBA(0,0,0,0))
          For i = 0 To doc\w/w
            For j = 0 To doc\h/h
              DrawAlphaImage(ImageID(tmp),i*w,j*h)
            Next j
          Next i
          
          StopDrawing()
        EndIf
        
        FreeImage2(tmp)
        Newpainting = 1
        ScreenUpdate(1)        
      EndIf
      
    EndIf
    
  EndIf
  
  
EndProcedure
Procedure Layer_ValidChange(Action,i=-1)
  
  If i=-1
    i=layerid
  EndIf
  
  If Action = #Action_Move Or Action = #Action_Transform Or Action = #Action_Rotate
    
    If OptionsIE\confirmAction = 1
      resultat=MessageRequester("Confirm?","Do you want to apply the transformation ?",#PB_MessageRequester_YesNo)
    EndIf
    
    If resultat =  #PB_MessageRequester_Yes  Or OptionsIE\ConfirmAction = 0
      
      Select layer(i)\Typ 
          
        Case #Layer_TypBitmap
          
          tmp = CopyImage(layer(i)\Image,#PB_Any)
          rotimg = tmp
          
          ; on dessine sur la nouvelle image
          If StartDrawing(ImageOutput(tmp))                
            DrawingMode(#PB_2DDrawing_AllChannels)
            Box(0,0,doc\w,doc\h,RGBA(0,0,0,0))
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(ImageID(layer(i)\Image),layer(i)\x,layer(i)\y)
            StopDrawing()
          EndIf
          
          If Action = #Action_Transform          
            
            ResizeImage(tmp,Layer(i)\w,Layer(i)\h)  
            tmp = UnPreMultiplyAlpha(temp) ; :: UnPreMultiplyAlpha(tmp)
            Layer(i)\w = doc\w
            Layer(i)\h = doc\h
            Layer(i)\NewW = doc\w
            Layer(i)\NewH = doc\h
            
          ElseIf action = #action_rotate
            
            rotimg = RotateImageEx2(ImageID(tmp),layer(i)\Angle)
            FreeImage2(tmp)
            rotimg = UnPreMultiplyAlpha(rotimg)
            w = ImageWidth(rotimg)
            h = ImageHeight(rotimg)
            
            w1 = ImageWidth(layer(i)\Image)
            h1 = ImageHeight(layer(i)\Image)
            
            xn = -(w-w1)/2
            yn = -(h-h1)/2
            
            
          EndIf
          
          If StartDrawing(ImageOutput(layer(i)\Image))
            DrawingMode(#PB_2DDrawing_AllChannels)
            Box(0,0,doc\w,doc\h,RGBA(0,0,0,0))
            DrawingMode(#PB_2DDrawing_AlphaBlend)         
            DrawAlphaImage(ImageID(Rotimg),xn,yn)
            StopDrawing()
          EndIf
          
          FreeImage2(rotimg)
          
        Case #Layer_TypText
          Layer_UpdateText(i,Layer(i)\w,Layer(i)\h,1)
          ; Layer_Update(i) 
          
          
      EndSelect
      
    EndIf
    
    Select layer(i)\Typ 
        
      Case #Layer_TypBitmap
        Layer(i)\selected = 0
        Layer(i)\x = 0
        Layer(i)\y = 0       
        Layer(i)\w = doc\w
        Layer(i)\h = doc\h
        Layer(i)\NewW = doc\w
        Layer(i)\NewH = doc\h
        Layer(i)\Angle = 0        
        RotateSprite(layer(i)\Sprite,0,0)
        
      Case #Layer_TypText
        RotateSprite(layer(i)\Sprite,0,0)
        Layer(i)\selected = 0
        Layer(i)\Angle = 0
        
    EndSelect
    
    
    NewPainting = 1
    ScreenUpdate(1)  
    
  EndIf
  
  
EndProcedure
; layer_move : see UpdateTool(), in gadgets, UI, updates... (gadgets.pbi)

; Transformations
Procedure Layer_Rotate(i,angle)
  
  tmp = CopyImage(layer(i)\Image,#PB_Any)
  
  ;   ; on dessine sur la nouvelle image
  ;   If StartDrawing(ImageOutput(tmp))                
  ;     DrawingMode(#PB_2DDrawing_AllChannels)
  ;     Box(0,0,doc\w,doc\h,RGBA(0,0,0,0))
  ;     DrawingMode(#PB_2DDrawing_AlphaBlend)
  ;     DrawAlphaImage(ImageID(layer(i)\Image),0,0)
  ;     StopDrawing()
  ;   EndIf
  
  
  rotimg = RotateImageEx2(ImageID(tmp),angle)
  FreeImage2(tmp)
  
  w = ImageWidth(rotimg)
  h = ImageHeight(rotimg)
  
  w1 = ImageWidth(layer(i)\Image)
  h1 = ImageHeight(layer(i)\Image)
  
  xn = -(w-w1)/2
  yn = -(h-h1)/2
  
  If StartDrawing(ImageOutput(layer(i)\Image))
    DrawingMode(#PB_2DDrawing_AllChannels)
    Box(0,0,doc\w,doc\h,RGBA(0,0,0,0))
    DrawingMode(#PB_2DDrawing_AlphaBlend)         
    DrawAlphaImage(ImageID(Rotimg),xn,yn)
    StopDrawing()
  EndIf
  
  FreeImage2(rotimg)
  
  
EndProcedure

; Layer operations (misc)
Procedure Layer_TransformToLine()
  
  ; transform an image to another with a alpha chanel based in the inverse of the grey level of the image
  ; for exemple, to transform automatically a scanned drawing into black line.
  
  ; get the color of the layer
  w = layer(layerid)\W
  h = layer(layerid)\H
  tempImg = CreateImage(#PB_Any, w, h, 32, #PB_Image_Transparent)
  
  ; create a copy of the image of the current layer
  tempimg_grey = CopyImage(Layer(LayerId)\Image,#PB_Any)
  
  
  ; **** OPTIMISATION : copie the procedures of IE_desaturation & IE_invertcolor, to not do 3 times IE_GetImagePixelColor
  
  
  ; desaturate the image of the current layer
  ; IE_Desaturation(tempimg_grey)
  
  ; invert the colors (because we will use the color (grey level) as alpha in our new image
  IE_InvertColor(tempimg_grey)
  
  ; get the pixels new color
  IE_GetImagePixelColor(tempimg_grey)
  
  ; Than we add a new layer
  Layer_Add()
  
  ; and draw on this layer the new image 
  If StartDrawing(ImageOutput(layer(LayerId)\image))
    ;DrawingMode(#PB_2DDrawing_AlphaBlend)
    ;DrawAlphaImage(ImageID(TempImg),0,0)
    
    DrawingMode(#PB_2DDrawing_AllChannels)
    ; draw the pixel on the alpha chanel
    For y = 0 To h - 1
      For x = 0 To w - 1
        color =  pixel(x, y)
        Plot(x, y, RGBA(0,0,0,color))
      Next
    Next
    StopDrawing()
  EndIf
  
  ; free the images
  FreeImage(tempimg)
  FreeImage(tempimg_grey)
  
  ; then update 
  NewPainting = 1
  ScreenUpdate()
  
EndProcedure
Procedure Layer_AddBGToalpha()
  
  ; To add a background (color, pattern...) To the alpha of our layer
  
  temp = CopyImage(layer(layerid)\Image, #PB_Any)
  
  If IsImage(temp)
    If StartDrawing(ImageOutput(layer(layerid)\Image))
      
      DrawingMode(#PB_2DDrawing_AllChannels)
      Box (0, 0, OutputWidth(), OutputHeight(), RGBA(Red(brush(action)\Color), Green(brush(action)\color), Blue(brush(action)\color), brush(action)\alpha))
      
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      DrawImage(ImageID(temp), 0,0)
      
      StopDrawing()
    EndIf
  EndIf
  
  ; free image temp
  
  freeimage2(temp)
  
  ; then update 
  NewPainting = 1
  ScreenUpdate()
  
  
EndProcedure
Procedure Layer_EraseAlpha()
  
  ; to erase the alpha of a layer.
  If MessageRequester(lang("confirmation"), lang("You will erase the alpha of the current layer. Are you sur ?"), #PB_MessageRequester_YesNo ) = #PB_MessageRequester_Yes    
    
    ; erase the alpha of the layer
    If StartDrawing(ImageOutput(Layer(LayerId)\Image))
      DrawingMode(#PB_2DDrawing_AlphaChannel)
      Box (0, 0, OutputWidth(), OutputHeight(), RGBA(0,0,0,255))
       ; DrawingMode(#PB_2DDrawing_AlphaChannel)
      StopDrawing()
    EndIf
    
    ; update the layer image (ui) and the screen
    Layer_UpdateUi(LayerId)
    ScreenUpdate(1,1)
    
  EndIf
  
      
EndProcedure



; alpha selection
Procedure Layer_ApplyAlpha()
  
  If OptionsIE\SelectAlpha = 1
    If StartDrawing(ImageOutput(layer(layerid)\Image))
      DrawingMode(#PB_2DDrawing_AlphaChannel)
      ; Box(0, 0, doc\w, doc\h,RGBA(255,255,255,255))
      DrawAlphaImage(ImageID(#Img_AlphaSel),0,0)
      StopDrawing()
    EndIf
    NewPainting = 1
    ScreenUpdate()
  EndIf
  
EndProcedure
Procedure Layer_SelectAlpha()
  
  ; CreateImage2(#Img_AlphaSel,doc\w,doc\h,"Alpha selection",32,#PB_Image_Transparent)
  
  CopyImage(layer(layerid)\Image, #Img_AlphaSel)
  If StartDrawing(ImageOutput(#Img_AlphaSel))
    DrawingMode(#PB_2DDrawing_AlphaClip)
    Box(0, 0, doc\w, doc\h,RGBA(255,255,255,255))
    StopDrawing()
  EndIf
  OptionsIE\SelectAlpha = 1
  
EndProcedure






; windows
; window properties for layer (windowprop) : see window.pbi


; IDE Options = PureBasic 5.61 (Windows - x86)
; CursorPosition = 1817
; FirstLine = 80
; Folding = AAAAAAAAAAAA7AAAAAAAAAAAAAAgHAvBAAAAAAAAAAAAAw
; EnableXP
; EnableUnicode