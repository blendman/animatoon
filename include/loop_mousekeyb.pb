
If GetActiveWindow() = #WinMain
  
  
  ;{ Mouse, paint
  
  ;{ For mac/linux // on garde pour mac, linux 
  ; MouseClic = 0
  ; ExamineMouse()     
  ;If MouseButton(1)
  ;MouseClic = 1
  ;EndIf
  ; CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  
  ;If mouseclic = 0
  ;ExamineMouse()     
  ;Mwheel + MouseWheel()
  ;       If Mwheel <> 0
  ;         If MWheel > 0
  ;           If OptionsIE\zoom <5000
  ;             OptionsIE\zoom=OptionsIE\zoom +10
  ;           EndIf
  ;         Else
  ;           If OptionsIE\zoom> 10
  ;             OptionsIE\zoom=OptionsIE\zoom -10
  ;           EndIf
  ;         EndIf    
  ;         ScreenZoom()
  ;       EndIf 
  ;EndIf
  
  ; CompilerEndIf
  
  ;}
  
  If Mx>0 And My>0 And Mx<ScreenWidth()-1 And My<ScreenHeight()-1 
    
    ; StatusBarText(#Statusbar,2,Str(mx)+"/"+Str(my))
    ; StatusBarText(#Statusbar,2,Str(mx)+"/"+Str(my)+" - "+Str(rx)+"/"+Str(ry)+" - canvas : "+Str(canvasX)+"/"+Str(canvasY)+"-"+Str(ScreenWidth()))
    
    ;{ we are on the canvas-screen, to paint // on est sur le screen-canvas, on peut effectuer des actions de dessin
    
    ;{ Change some parameters (close menu...) // d'abord, on modifie quelques parametres
    
    ; On vérifie si un menu est ouvert, on le ferme
    If MenuOpen = 1
      MenuOpen = 0
      ;ReleaseMouse(0)
      ;MouseClic = 1  
      
      ;     If ScreenResized ; on resizé l'acran
      ;         W = WindowWidth(#WinMain) - ScreenX*2 ; -10
      ;         H = WindowHeight(#WinMain) - 150
      ;         ScreenResized = 0
      ;         ResizeScreen(w,h)        
      ;      EndIf
      
      
    EndIf
    
    ; if a gadget is previously active, e change the active gadget -> toolbar // SI un gadget est actif, on met la toolbar active
    If gad = 1 And MouseClic = 1
      gad = 0
      SetActiveGadget(#G_ToolBar)    
    EndIf             
    
    ; We are on the screen  // on doit dire qu'on est sur le screen.
    If inscreen = 0 ; And size =0
      inscreen = 1
      ; For window
      ; CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ;   If Mwheel = 0
      ;     ReleaseMouse(1)
      ;   EndIf        
      ; CompilerElse 
      ; pour linux et mac (j'utilise examinemouse() avec llinux et mac)
      ;   ReleaseMouse(0)
      ;   MouseLocate(mx,my)
      ; CompilerEndIf
      
    EndIf
    
    ;}
    
    If MouseClic ; click on the canvas // on clique sur le canvas
      
      ;{  action if clic on the screen (paint, eraser..)
      
      ; OPtionsIE\cursorX = 10000
      UpdateSc.a = 0
      startzoom = 0
      
      If MoveCanvas >= 1
        
        ;{ move the canvas // on bouge le canvas
        
        If MoveCanvas=1 
          Movecanvas = 2
          OldCanvasX = Mx - CanvasX
          OldCanvasY = My - CanvasY
          If NewPainting = 1
            ScreenUpdate(0, 0)
          EndIf
        EndIf
        CanvasX = Mx - OldCanvasX
        CanvasY = My - OldCanvasY 
        
        ScreenDraw()
        CanvasUpdate(1)
        
        ;}
        
      Else
        
        ;{ We do an action : drawing, clear, move a layer // On fait une action : peindre, effacer, bouger un layer, etc.. / 
        
        
        If Action <= #Action_Eraser ; (pen, brush, particule, spray, effacer, )
          
          ;{ action = PAINTING (brush, eraser, pen, spray, particles, box, ellipse, line, gradient..)
          
          ;{ Clear the screen (option real time) // on efface l'écran (options tps réel)
          
          If clear = 1 And OptionsIE\UseCanvas = 0
            If action <> #Action_Eraser
              ClearScreen(RGB(120,120,120))
              
              ; draw the background // Puis on affiche le fond (paper)          
              PaperDraw()
              
              ; layer bottom // on affiche les calques du dessous
              For i = 0 To ArraySize(layer())
                If layer(i)\ordre <= layer(layerId)\ordre
                  If Paper\pos = layer(i)\ordre
                    ; the paper textures
                    PaperTextureDraw() 
                  EndIf
                  If layer(i)\view 
                    Layer_Draw_OnScreen(i)
                  EndIf
                EndIf
              Next i 
              
            EndIf
          EndIf
         
          ;}
          
          If layer(LayerID)\locked = 0 And layer(LayerID)\view = 1
            
            If alt = 1 ; pick the color // on prend la couleur
              
              ;{ We get the color on the surface canvas-screen  // on prend la couleur (alt + clic)
              UsePickColorTogetColor(mx, my)
              ;}
              
            Else ; we draw (brush, eraser, floodfill, box, etc...)
              
              CanvasHasChanged = 1
              
              Select Action
                  
                  ;{ -------------- Brush, eraser // dessin, gomme             
                  
                Case #Action_Brush, #Action_Eraser, #Action_Pen 
                  
                  ;{ brush, eraser, pen
                  
                  Paint = 1 ; we paint // on peint (c'est pour voir si c'est la souris ou non)
                  
                  ; drawing on the active layer  and the active image //on va dessiner sur le "calque" actif  et sur l'image active
                  
                  ;{ calcul some parameters (size of the brush with pressure, blendmode)....// on calcule divers paramètres (pression, etc..)
                  
                  ;{ size (tablet )
                  size.d = Paint_GetTabletSizePression() ; 
                  ;}
                  
                  ; blendmode
                  Layer_Bm(layerId)
                  ;}
                  
                  If size > 0 ; only if brush is visible, of course // on ne dessine que si on a notre brush visible, pardi :)
                    
                    ; For autosave // pour l'autosave OU pour updater l'image du layer
                    OptionsIE\ImageHasChanged = 1
                    Layer_SetHasChanged()
                    
                    
                    ;******** then we paint // puis on dessine
                    ; NewPainting = 1
                    
                    ;{ get/Set color
                    ; first : mix colors // d'abord, on va mélanger les couleurs en tps réel 
                    color = Brush(Action)\color  
                    
                    ;If Brush(Action)\mix > 0 
                    If clear=1 And OptionsIE\UseCanvas = 0
                      
                      Select Brush(Action)\MixLayer ; check the layer to pick the color for mixing //on vérifie sur quels layers on peut prendre la couleur
                          
                        Case 2 ; all under // tous ceux en dessous (defaut)
                          
                          ClearScreen(RGB(120,120,120))                                          
                          ; Puis on affiche le fond (paper)                             
                          PaperDraw()                          
                          ; on affiche les calques du dessous
                          For i = 0 To ArraySize(layer())
                            If layer(i)\ordre <= layer(layerId)\ordre
                              If layer(i)\view 
                                Layer_Draw_OnScreen(i)
                              EndIf
                            EndIf
                          Next i 
                          
                          
                        Case 1 ; only the current layer //le calque sélectionné uniquement
                          ClearScreen(RGB(120,120,120))                    
                          ; Puis on affiche le fond (paper)          
                          PaperDraw()                    
                          ; on affiche le calque
                          Layer_Draw_OnScreen(LayerId)
                          
                          
                        Case 0 ; all //tous
                          ClearScreen(RGB(120,120,120))                    
                          ; Puis on affiche le fond (paper)          
                          PaperDraw()                     
                          ; on affiche les calques du dessous
                          For i = 0 To ArraySize(layer())
                            If layer(i)\view 
                              Layer_Draw_OnScreen(i)
                            EndIf
                          Next i 
                          
                          
                        Case 3 ; layer we have choose // calques qu'on a mis ok pour le pick color
                          ClearScreen(RGB(120,120,120))                    
                          ; Puis on affiche le fond (paper)          
                          PaperDraw()                    
                          ; on affiche les calques du dessous
                          For i = 0 To ArraySize(layer())
                            If layer(i)\view 
                              If layer(i)\OkForColorPick
                                Layer_Draw_OnScreen(i)
                              EndIf
                            EndIf
                          Next i 
                          
                      EndSelect
                      
                    Else
                       
                      
                    EndIf
                    
                    ; puis on chope la couleur
                    ;color = Brush(Action)\color 
                    If Brush(Action)\Mix >0
                      If Brush(Action)\MixType = 0
                        color = BrushCheckMixClassic(mx,my)
                      ElseIf Brush(Action)\MixType = 1
                        color = BrushCheckMixInverse(mx,my)
                      ElseIf Brush(Action)\MixType = 2
                        color = BrushCheckMixOld(mx,my)
                      Else
                        Color = BrushCheckMixNew(mx,my)
                      EndIf
                    EndIf
                    ;}
                    
                    ; we have to display again the layer under the current // Puis, on réaffiche les calques du dessous, ben oui
                    If clear =1 And OptionsIE\UseCanvas = 0
                      ;If action <> #Action_Eraser
                        ClearScreen(RGB(120,120,120)) 
                        
                        ; Puis on affiche le fond (paper)          
                        PaperDraw() 
                        
                        ; on affiche les calques du dessous
                        For i = 0 To ArraySize(layer())
                          If layer(i)\ordre <= layer(layerId)\ordre
                            If Paper\pos = layer(i)\ordre
                              ; the paper textures
                              PaperTextureDraw() 
                            EndIf
                            
                            If layer(i)\view 
                              Layer_Draw_OnScreen(i)
                            EndIf
                          EndIf
                        Next i 
;                       EndIf
                    EndIf
                    
                    
                    ; save the dot() for the futur stroke // on enregistre les dot()             
                    ;{ pour créer les dot() en tps réel // désactivé pour l'instant
                      ; AddDot(mx, my,size,color)
                    ;}
                    
                    
                    ; position x/y of the  brush
                    If brush(action)\StrokeTyp = #Stroke_Rough
                      xx.d = mx - Brush(Action)\centerSpriteX  
                      yy.d = My - Brush(Action)\centerSpriteY  
                    Else
                      xx.d = mx
                      yy.d = my
                    EndIf
                    
                    If clic= 0 ; on garde la position de la souris du départ
                      clic=1
                      StartX = xx
                      StartY = yy                       
                    EndIf
                    
                    ;*************** Then we draw on the sprite (clear=1) or the screen (Clear=0) // Ensuite, on dessine tout sur le sprite (clear = 1) ou le screen (clear=0)
                    
                    Brush_SetSizeWithPression()
                    
                    If FinalSize > 0
                      
                      z = OptionsIE\Zoom*0.01
                      
                      If OptionsIE\UseCanvas = 0
                        
                        ;{ old technic : draw on the screen
                        ;                         If clear = 0  
                        ;                           
                        ;                           ;{ technic pas tps réel, on dessine sur le screen
                        ;                           
                        ;                           zoum.d = 100
                        ;                           zoum = 100/OptionsIE\zoom 
                        ;                           
                        ;                           ;xx = (mx - canvasX)*zoum -Brush(Action)\CenterX 
                        ;                           ;yy = (My - canvasY)*zoum -Brush(Action)\CenterY 
                        ;                           
                        ;                           xx = Mx - canvasX * zoum  - Brush(Action)\CenterX 
                        ;                           yy = MY - canvasY * zoum  - Brush(Action)\CenterY 
                        ;                           
                        ;                           If StartDrawingOnImageNotClear = 0
                        ;                             StartDrawingOnImageNotClear = 1
                        ;                             StartX5 = xx
                        ;                             StartY5 = yy
                        ;                           EndIf
                        ;                           
                        ;                           
                        ;                           dist  = point_distance(xx,yy,StartX5,StartY5) ; to find the distance between two brush dots
                        ;                           d.d   = point_direction(xx,yy,StartX5,StartY5); to find the direction between the two brush dots
                        ;                           sinD.d = Sin(d)                
                        ;                           cosD.d = Cos(d)
                        ;                           angle = GetAngle(xx,yy,StartX5,StartY5)*#PI/180
                        ;                           
                        ;                           For u = 0 To dist-1
                        ;                             
                        ;                             Scx.d = Rnd(Brush(Action)\scatter)* Brush(Action)\size * 0.01
                        ;                             Scy.d = Rnd(Brush(Action)\scatter)* Brush(Action)\size * 0.01
                        ;                             CheckAlpha()
                        ;                             
                        ;                             
                        ;                             x_result.d= sinD * u + xx + scx + canvasX*zoum - (FinalSize*Brush(Action)\W*z)/2 + Brush(Action)\centerSpriteX/z 
                        ;                             y_result.d= cosD * u + yy + scy + canvasY*zoum - (FinalSize*Brush(Action)\H*z)/2 + Brush(Action)\centerSpriteY/z
                        ;                             
                        ;                             
                        ;                             RotateSprite(#Sp_BrushCopy, Random(Brush(Action)\randRot),1)
                        ;                             ZoomSprite(#Sp_BrushCopy,FinalSize*Brush(Action)\W*z,FinalSize*Brush(Action)\H*z) 
                        ;                             
                        ;                             
                        ;                             If Action = #Action_Eraser
                        ;                               col = RGB(250,250,250)
                        ;                             Else
                        ;                               col = Color
                        ;                             EndIf
                        ;                             
                        ;                             DisplayTransparentSprite(#Sp_BrushCopy,x_result,y_result,alpha,Col) 
                        ;                             
                        ;                             ;                           FinalSize - FinalSize*ratio*u
                        ;                             
                        ;                             v+1
                        ;                             u + b
                        ;                           Next u
                        ;                           
                        ;                           StartX5 = XX
                        ;                           StartY5 = YY
                        ;                           brushsiz_old = brushsiz
                        ;                           ;}
                        ;                           
                        ;                         Else
                        ;}
                        
                        ; draw on the current sprite layer
                        If Brush(Action)\Stroke <> #Stroke_Gersam  ; temporaire
                            
                            ;{ calcul de position x et y / et on capture le premier point
                            zoum.d = 100
                            zoum = 100/OptionsIE\zoom 
                            xx = (mx - canvasX)*zoum -Brush(Action)\CenterX 
                            yy = (My - canvasY)*zoum -Brush(Action)\CenterY 
                            If StartDrawingOnImage = 0
                              StartDrawingOnImage = 1
                              StartX1 = xx
                              StartY1 = yy
                            EndIf
                            ;}
                            
                            ; on dessine directement sur le sprite qu'on va afficher ensuite
                            If StartDrawing(SpriteOutput(Layer(LayerId)\Sprite))
                              
                              w = FinalSize * Brush(Action)\size
                              Select Brush(Action)\Stroke 
                                  
                                Case #Stroke_Rough                                  
                                  DoPaint(xx,yy,StartX1,StartY1,size,Color,0,SpriteOutput(Layer(LayerId)\Sprite))
                                  
                                Case #Stroke_LineAA                                  
                                  LineLSI(xx,yy,StartX1,StartY1,Color,FinalSize*Brush(Action)\size,alpha)                             
                                  
                                Case #Stroke_Knife
                                  ; InkLine(xx-w/2,yy-w/2,StartX1-w/2,StartY1-w/2,FinalSize*Brush(Action)\size,Color) ; ligne droite, bug un peu                              
                                  InkLine(xx,yy,StartX1,StartY1,FinalSize*Brush(Action)\size,Color) ; ligne droite, bug un peu                              
                                  
                                Case #Stroke_Dash
                                  ;                                   zoum.d = 100
                                  ;                                   zoum = 100/OptionsIE\zoom 
                                  ;                                   xx = (mx - canvasX)*zoum -w/2 ;-Brush(Action)\CenterX 
                                  ;                                   yy = (my - canvasY)*zoum -w/2 ;-Brush(Action)\CenterY 
                                  ;                                   If  StartDrawingOnImage = 1                                    
                                  ;                                     StartDrawingOnImage = 2
                                  ;                                     StartX1 = xx
                                  ;                                     StartY1 = yy
                                  ;                                   EndIf
                                  pas  = brush(Action)\pas                                  
                                  DashDraw(xx, yy, StartX1, StartY1, pas, FinalSize*Brush(Action)\size, color)
                                  
                              EndSelect
                              
                            EndIf
                            
                          Else                            
                            
                            ;{ calcul de position x et y / et on capture le premier point
                            zoum.d = 100
                            zoum = 100/OptionsIE\zoom                            
                            xx = (mx - canvasX) * zoum ;-Brush(Action)\CenterX 
                            yy = (My - canvasY) * zoum ;-Brush(Action)\CenterY  
                            If Gersamclic = 0
                              Gersamclic = 1
                              StartX2 = xx
                              StartY2 = yy
                            EndIf
                            ;}
                            CheckAlpha()                            
                            GersamDraw(xx,yy,StartX2,StartY2,FinalSize*Brush(Action)\size,Color,alpha)
                            StartX2 = xx
                            StartY2 = yy
                          EndIf
                          
                      EndIf
                        
                    EndIf                    
                    
                    ;*****************  Then we draw on active image // puis on dessine sur l'image active
                    If FinalSize >0 And (OptionsIE\SaveImageRT Or OptionsIE\UseCanvas)
                      
                      
                      If Brush(Action)\Stroke <> #Stroke_Gersam  ; temporaire
                        
                        ; set the image
                        img = Layer(LayerId)\Image
                        
                        If layer(layerid)\MaskAlpha =2
                          img = Layer(LayerId)\ImageAlpha
                        Else
                          
                        EndIf
                        
                        
                        ; draw on image
                        If StartDrawing(ImageOutput(img))
                          
                          ;{ calcul position et capture du premier point
                          zoum.d = 100
                          zoum = 100/OptionsIE\zoom
                          xx.d = (mx - canvasX)*zoum -Brush(Action)\CenterX 
                          yy.d = (My - canvasY)*zoum -Brush(Action)\CenterY
                          If layer(LayerId)\typ = #Layer_TypBG
                            xx1 = Mod(xx,layer(layerid)\W_Repeat)
                            yy1 = Mod(yy,layer(layerid)\H_Repeat)
                          EndIf
                          
                          If StartDrawingOnImage = 0
                            StartDrawingOnImage = 1
                            StartX1 = xx
                            StartY1 = yy
                          EndIf
                          ;}
                          
                          
                          Select Brush(Action)\Stroke 
                              
                            Case #Stroke_Rough
                              DoPaint(xx,yy,StartX1,StartY1,size,Color,1,ImageOutput(img))
                              ; DoPaintForImageLayer(xx,yy,StartX1,StartY1,size)
                              
                            Case  #Stroke_Knife                         
                              InkLine(xx,yy,StartX1,StartY1,FinalSize*Brush(Action)\size,Color) ; ligne droite, bug un peu
                              
                            Case #Stroke_Dash
                              DashDraw(xx, yy, StartX1, StartY1, brush(action)\pas, FinalSize*Brush(Action)\size, color)
                              
                            Case #Stroke_LineAA
                              LineLSI(xx,yy,StartX1,StartY1,RGBA(0,0,0,255),FinalSize*Brush(Action)\size,alpha);Color,) ; ligne droite, bug un peu                              
                              
                            
                          EndSelect
                        
                          ;ThickLine(StartX1,StartY1,xx,yy,FinalSize*Brush(Action)\size,Color)  
                          
                          StartX1 = xx
                          StartY1 = yy
                          
                        EndIf
                        
                      Else
                        
                        CheckAlpha()                            
                        GersamDraw(xx,yy,StartX2,StartY2,FinalSize*Brush(Action)\size,Color,alpha)
                        StartX2 = xx
                        StartY2 = yy
                        
                      EndIf 
                      
                      ; update the main canvas if used
                      ; CanvasMain_Update()
                      
                    Else
                      
                      StartX1 = xx
                      StartY1 = yy
                      
                    EndIf  
                    
                  EndIf
                  
                  ; draw the screen
                  If clear = 1 And OptionsIE\UseCanvas = 0
                    If layer(LayerId)\Bm <> #Bm_Normal Or layer(LayerId)\MaskAlpha = 2
                      If action = #Action_Eraser Or layer(LayerId)\MaskAlpha = 2 Or brush(action)\water >0 Or (brush(action)\UseWater>0 And brush(action)\col\A >0)
                        Newpainting = 1
                        ScreenUpdate() 
                      EndIf
                    EndIf
                  EndIf
                  
                  ;}
                  ;}
                  
                  
                  ;{ --------------  other tools for drawing (clonestamp, particles, fill, text, gradient, box, circle...
                  ; // autres outils de dessin: particules, fill, text, gradient, box, circle...
                  
                  
                Case #Action_CloneStamp
                  ;{ clonestamp // tampon
                  ;{ calcul some parameters (size of the brush with pressure)
                  ; tablet 
                  size.d = Paint_GetTabletSizePression() ; 
;                   If size <=0
;                     size = 8.6
;                   EndIf
                  
                  ;}
                  If size >0
                    ; blendmode
                    Layer_Bm(layerId)
                    
                    ; position of the brush
                    xx.d = mx - Brush(action)\CenterSpriteX  
                    yy.d = My - Brush(action)\CenterSpriteY 
                    
                    ; keep the 1rst position
                    If clic= 0   
                      OptionsIE\ImageHasChanged = 1
                      
                      ; For autosave // pour l'autosave OU pour updater l'image du layer
                      Layer_SetHasChanged()
                      ; Layer(layerId)\Haschanged = 1 
                      
                      ; we paint // on peint (c'est pour voir si c'est la souris ou non)
                      Paint = 1                    
                      clic=1
                      StartX = xx
                      StartY = yy                       
                    EndIf
                    
                    Brush_SetSizeWithPression()
                    
                    ; then we can draw
                     If FinalSize > 0
                      z = OptionsIE\Zoom*0.01
                      If OptionsIE\UseCanvas = 0
                        ;{ calcul de position x et y / et on capture le premier point
                        zoum.d = 100
                        zoum = 100/OptionsIE\zoom 
                        xx.d = (mx - canvasX)*zoum -Brush(action)\CenterX 
                        yy.d = (My - canvasY)*zoum -Brush(action)\CenterY 
                        If StartDrawingOnImage = 0
                          StartDrawingOnImage = 1
                          OptionsIE\Shape = 1 ; to see the layer_temporary
                          StartX1 = xx
                          StartY1 = yy
                        EndIf
                        ;}
                        w = FinalSize * Brush(Action)\size
                        
                        ; temporary to test : should use do_paint()
                        If StartDrawing(SpriteOutput(#sp_LayerTempo))
                          DoPaint(xx,yy,StartX1,StartY1,size,Color,0,SpriteOutput(#sp_LayerTempo))
                        EndIf
                        
                        ; then draw on the layer
                        ;zoum.d = 100
                        ;zoum = 100/OptionsIE\zoom
                        xx.d = (mx - canvasX)*zoum -Brush(Action)\CenterX 
                        yy.d = (My - canvasY)*zoum -Brush(Action)\CenterY
                        If StartDrawing(ImageOutput(#image_patternForstamp))
                          DoPaint(xx,yy,StartX1,StartY1,size,Color,1,ImageOutput(#image_patternForstamp))
                        EndIf
                        
                        StartX1 = xx
                        StartY1 = yy
;                           If StartDrawing(SpriteOutput(#sp_LayerTempo))
;                             ;DrawingMode(#PB_2DDrawing_AlphaChannel)
;                              DrawingMode(#PB_2DDrawing_CustomFilter)
;                              CustomFilterCallback(@FiltreMelangeAlphaPat())  
;   
;                             ;Circle(xx,yy,size,RGBA(0,0,0,255))
;                             DrawAlphaImage(ImageID(#BrushCopy), xx, yy, 255)
;                             StopDrawing()
;                           EndIf
;                           ; temporary to test : should use dopaint()
;                           If StartDrawing(ImageOutput(#image_patternForstamp))
;                             ;DrawingMode(#PB_2DDrawing_AlphaChannel)
;                             DrawingMode(#PB_2DDrawing_CustomFilter)
;                             CustomFilterCallback(@FiltreMelangeAlphaPat())  
;                             
;                             ; Circle(xx,yy,size,RGBA(0,0,0,255))
;                             DrawAlphaImage(ImageID(#BrushCopy), xx, yy, 255)
;                             StopDrawing()
;                           EndIf
                      EndIf
                    EndIf
                    
                  EndIf
                  
                  
                  ;}
                  
                Case #Action_Fill 
                  ;{ fillarea
                  ; bug PB avec bordure en rgb(0,0,0)              
                  If clic = 0
                    clic = 1
                    newpainting = 1  
                    ; Layer(layerId)\Haschanged = 1
                    Layer_SetHasChanged()
                    If StartDrawing(ImageOutput(layer(layerId)\Image))
                      
                      ; DrawingMode(#PB_2DDrawing_Default)
                      ; FillArea((mx-canvasX)/z, (my-canvasY)/z, -1, RGBA(Red(Brush(Action)\Color), Green(Brush(Action)\Color), Blue(Brush(Action)\Color), Brush(Action)\Alpha))
                      
                      FillArea_ext((mx-canvasX)/z, (my-canvasY)/z, Brush(Action)\Color)
                      ; FillArea((mx-canvasX)/z, (my-canvasY)/z, Brush(Action)\Color)
                      ;FillArea2((mx-canvasX)/z,(my-canvasY)/z,0,0,Layer(Layerid)\w,Layer(Layerid)\h,Brush(Action)\Color)                
                      IE_DrawEnd()  
                      
                      ScreenUpdate(1)
                      ;}
                      
                  EndIf    
                  ;}
                  
                Case #Action_Text              
                  If clic = 0
                    OptionsIE\LayerTyp = #Layer_TypText
                    OpenTxtEditor(Mx,my)
                   
                    ; For autosave // pour l'autosave OU pour updater l'image du layer
                    OptionsIE\ImageHasChanged = 1
                    ; Layer(layerId)\Haschanged = 1
                    Layer_SetHasChanged()
                     
                    clic = 1
                  EndIf 
                  
                Case #Action_Box, #Action_Circle, #Action_Line, #Action_Gradient  
                  ;{ Box, circle, line, gradient
                  zoum.d = 100
                  zoum = 100/OptionsIE\zoom 
                  xx = (mx - canvasX)*zoum 
                  yy = (My - canvasY)*zoum 
                  
                  If OptionsIE\Shape = 0
                    OptionsIE\Shape = 1
                    startx = xx
                    startY = yy
                    OptionsIE\ShapeX = StartX
                    OptionsIE\ShapeY = StartY
                  EndIf              
                  NewPainting = 1
                  
                  ;{ size // taille de la box - rx et ry
                  rx = xx - StartX 
                  ry = yy - StartY        
                  If shift
                    If action = #action_line
                      ry = 0
                    Else
                      ry = rx
                    EndIf                
                  EndIf
                  OptionsIE\ShapeW = rx
                  OptionsIE\ShapeH = ry
                  
                  ;}
                  
                  ;{ box with border // box plain, avec bord...
                  If Brush(Action)\ShapePlain  
                    If Brush(Action)\ShapeType = 0
                      ;Box(StartX, StartY, rx, ry, RGBA(Red(Brush(Action)\Color),Green(Brush(Action)\Color),Blue(Brush(Action)\Color),Brush(Action)\alpha)) 
                    Else
                      ;RoundBox(StartX, StartY, rx, ry, Brush(Action)\RoundX, Brush(Action)\RoundY, RGBA(Red(Brush(Action)\Color),Green(Brush(Action)\Color),Blue(Brush(Action)\Color),Brush(Action)\alpha)) 
                    EndIf                  
                  EndIf
                  
                  cx = rx*2 + Brush(Action)\ShapeOutSize*4
                  cy = ry*2 + Brush(Action)\ShapeOutSize*4
                  
                  If cx <> 0
                    If cy<> 0
                      ;                   
                      ;                   temp = CreateImage(#PB_Any, Abs(cx), Abs(cy), 32, #PB_Image_Transparent)
                      ;                   If StartDrawing(ImageOutput(temp))
                      ;                     If Brush(Action)\ShapeOutline 
                      ;                       
                      ;                       If Brush(Action)\ShapeType = 0
                      ;                         DrawingMode(#PB_2DDrawing_AlphaBlend)
                      ;                         Box(0, 0, Abs(rx), Abs(ry), Brush(Action)\ColorFG)
                      ;                         DrawingMode(#PB_2DDrawing_AlphaChannel) 
                      ;                         dx = Abs(rx) - Brush(Action)\ShapeOutSize*2                        
                      ;                         dy = Abs(ry) - Brush(Action)\ShapeOutSize*2                                                
                      ;                         Box(Brush(Action)\ShapeOutSize, Brush(Action)\ShapeOutSize, dx , dy, RGBA(0, 0, 0, 0))
                      ;                       Else
                      ;                         DrawingMode(#PB_2DDrawing_AlphaBlend)
                      ;                         RoundBox(0, 0, Abs(rx), Abs(ry), Brush(Action)\RoundX, Brush(Action)\RoundY, Brush(Action)\ColorFG)
                      ;                         DrawingMode(#PB_2DDrawing_AlphaChannel) 
                      ;                         dx = Abs(rx) - Brush(Action)\ShapeOutSize*2                        
                      ;                         dy = Abs(ry) - Brush(Action)\ShapeOutSize*2                                                
                      ;                         RoundBox(Brush(Action)\ShapeOutSize, Brush(Action)\ShapeOutSize, dx , dy, Brush(Action)\RoundX, Brush(Action)\RoundY, RGBA(0, 0, 0, 0))
                      ;                       EndIf
                      ;                       
                      ;                     EndIf 
                      ;                     StopDrawing()
                      ;                   EndIf
                      ;                   
                      ;                   If StartDrawing(ImageOutput(layer(LayerID)\Image))                  
                      ;                     If rx >= 0
                      ;                       If ry >= 0                  
                      ;                         DrawAlphaImage(ImageID(temp), StartX, StartY)                       
                      ;                       Else                               
                      ;                         DrawAlphaImage(ImageID(temp), StartX, StartY - Abs(ry))                       
                      ;                       EndIf
                      ;                     Else
                      ;                       If ry >= 0                  
                      ;                         DrawAlphaImage(ImageID(temp), StartX - Abs(rx), StartY)                       
                      ;                       Else                               
                      ;                         DrawAlphaImage(ImageID(temp), StartX - Abs(rx), StartY - Abs(ry))                       
                      ;                       EndIf
                      ;                     EndIf           
                      ;                   EndIf
                      ;                   
                      ;                   FreeImage(temp)
                    EndIf
                  EndIf
                  ;}
                  
                  Layer_DrawTempo()
                  
                  ;}
                  
                  ;}
                  
              EndSelect
              
            EndIf
            
          EndIf
          ;}
          
        Else ; Other actions (move, transform, hand, zoom, color picker..) // action autre que dessiner : bouger, transform, pipette
          
          Select Action ; Other actions (move, transform, hand, zoom, color picker..) 
              
            Case #Action_Pipette 
              UsePickColorTogetColor(mx, my) ; in procedures/paint.pbi
              
            Case #Action_Move
              If layer(LayerID)\locked = 0 And layer(LayerID)\view = 1
                layer(layerId)\selected = 1
                CanvasHasChanged = 1
                ;Layer(layerId)\Haschanged = 1
                Layer_SetHasChanged()
                If Clic = 0
                  oldposx = mx/z - layer(layerid)\x
                  oldposy = my/z - layer(layerid)\y
                  Clic = 1
                EndIf
                ActionKeyb = 0
                MoveLayerX = 0
                MoveLayerY = 0
                If OptionsIE\lockX = 0
                  Layer(layerId)\x = mx/z - oldposx 
                EndIf
                If OptionsIE\lockY = 0
                  Layer(layerId)\y = my/z - oldposy
                EndIf
                SetGadgetState(#G_ActionX, layer(layerId)\x)
                SetGadgetState(#G_ActionY, layer(layerId)\y)
                If OptionsIE\ActionForAllLayers
                  For i =0 To ArraySize(layer())
                    If i <> LayerId
                      If layer(i)\locked = 0 And layer(i)\view = 1
                        Layer(i)\x = Layer(layerId)\x
                        Layer(i)\y = Layer(layerId)\y
                      EndIf
                    EndIf                    
                  Next i                  
                EndIf
                ScreenUpdate()
              EndIf
              
            Case #Action_Rotate 
              If layer(LayerID)\locked = 0 And layer(LayerID)\view = 1
                If Clic = 0                   
                  Layer(layerId)\AngleStartX = mx/z 
                  Layer(layerId)\AngleStartY = my/z 
                  ; OldAngle = 
                  Clic = 1
                EndIf
                ; Layer(layerId)\Haschanged = 1
                Layer_SetHasChanged()
                CanvasHasChanged = 1
                Layer(layerId)\AngleX = mx/z 
                Layer(layerId)\AngleY = my/z               
                Angle = GetAngle(Layer(layerId)\AngleX,Layer(layerId)\AngleY,Layer(layerId)\AngleStartX ,Layer(layerId)\AngleStartY)
                Layer(layerId)\Angle = Angle
                RotateSprite(Layer(layerId)\Sprite,Angle,0)
                ScreenUpdate()
              EndIf
              
            Case #Action_Transform 
              If layer(LayerID)\locked = 0 And layer(LayerID)\view = 1
                If clic = 0
                  StartX = Mx/z - Layer(LayerID)\W
                  StartY = My/z - Layer(LayerID)\H
                  clic=1                  
                EndIf                
                Layer(LayerId)\selected = 1
                ; Layer(layerId)\Haschanged = 1
                Layer_SetHasChanged()
                CanvasHasChanged = 1
                Layer(layerId)\W = Mx/z -StartX 
                If shift = 1
                  ratio.d = Layer(LayerID)\NewH/Layer(LayerID)\NewW
                  Layer(layerId)\H = Layer(layerId)\W*ratio
                Else                  
                  Layer(layerId)\H = My/z -startY 
                EndIf                
                If OptionsIE\ActionForAllLayers
                  For i =0 To ArraySize(layer())
                    If i <> LayerId
                      If layer(i)\locked = 0 And layer(i)\view = 1
                        Layer(i)\w = Layer(layerId)\w
                        Layer(i)\h = Layer(layerId)\h
                      EndIf
                    EndIf                    
                  Next i                  
                EndIf     
                ScreenUpdate()
              EndIf
              
            Case #Action_Select 
              ;{  
              newpainting = 0
              ; start rectangle selection 
              If Clic = 0
                Clic = 1
                OptionsIE\SelectionX = (mx - canvasX)/z
                OptionsIE\SelectionY = (my - canvasY)/z
                If OptionsIE\SelectionX < 0
                  OptionsIE\SelectionX = 0
                EndIf 
                If OptionsIE\SelectionY < 0
                  OptionsIE\SelectionY = 0
                EndIf
              EndIf
             
              OptionsIE\SelectionW = (mx - canvasX)/z - OptionsIE\SelectionX
              OptionsIE\Selection = 1
              
              ; shift -> square selection
              If shift = 1                
                OptionsIE\SelectionH = OptionsIE\SelectionW
              Else
                OptionsIE\SelectionH = (my- canvasY)/z - OptionsIE\SelectionY 
              EndIf
              
              ScreenUpdate()
              ;}
              
            Case #Action_Zoom 
              ;{
              If control = 1
                If OptionsIE\Zoom>1                  
                  OptionsIE\Zoom -1
                  ScreenZoom()
                EndIf
              Else
                OptionsIE\Zoom +1
                ScreenZoom()
              EndIf
              ;}
              
          EndSelect
          
        EndIf
        
        ;}
        
        ;{ then display the screen
        If OptionsIE\UseCanvas = 0
          
          ;{ display the top layer , over the current layer //on affiche les calques du dessus
          If OptionsIE\Shape=1 
            SpriteBlendingMode(#PB_Sprite_BlendSourceAlpha, #PB_Sprite_BlendInvertSourceAlpha)
            ZoomSprite(#Sp_LayerTempo, Doc\W*z, Doc\H*z)
            DisplayTransparentSprite(#Sp_LayerTempo, canvasX, canvasY, layer(layerid)\alpha)  
          EndIf
          
          ; need to see the layer over our painting (if paint, box, line circle(),...)
          If clear = 1 
            If OptionsIE\Selection <> 1 ; And action <> #Action_Eraser
              For i = 0 To ArraySize(layer())
                  
                If layer(i)\ordre > layer(layerId)\ordre
                  If Paper\pos = layer(i)\ordre ; And paper\pos >layer(layerId)\ordre
                    ; the paper textures
                    PaperTextureDraw() 
                  EndIf

                  If layer(i)\view 
                    Layer_Draw_OnScreen(i)
                  EndIf
                EndIf
              Next i
              If paper\pos > ArraySize(layer())
                 PaperTextureDraw() 
              EndIf
              
            EndIf
          EndIf
          
          ;}
          
          ;{ on affiche enfin les utilitaires (selection, grid, etc..
          DrawUtil()
          ;}
          
        EndIf
        ;}
        
      EndIf
      
      If OptionsIE\UseCanvas =0
        
        If MoveCanvas =0 And (action = #Action_Eraser And layer(layerid)\bm <> #Bm_Normal)  
          ; not flipbuffers(), eraser has its flipbuffers (for layer blendmode <> normal)
        Else
          FlipBuffers() 
        EndIf
      Else
        If MoveCanvas=0
          ; need to update the layer()\imgtemp
          If layer(layerId)\bm <> #Bm_Normal
            Layer_ConvertToBm(layerId)              
          EndIf
          CanvasUpdate()
        EndIf
      EndIf
        
      ;}
      
      
    Else ; dont clic on the screen // on ne clique pas sur le screen
      
      ;{ on a levé notre souris, on ne dessine plus
      
      If MoveCanvas = 2 ; on bouge le canvas
        MoveCanvas =1
      EndIf 
      
      If clear = 0
        If clic = 1
          newpainting= 1
          ScreenUpdate(1)          
        EndIf
      Else
        If UpdateSc = 0
          UpdateSc = 1
          ScreenUpdate() 
        EndIf        
      EndIf
      
      ;       If Paint = 1
      ;         Paint = 0
      ;         Debug "on a peint !"
      ;         ; ScreenUpdate() 
      ;       EndIf
      
      Brush(Action)\ViscoCur = 0      
      Clic = 0
      Pression = 0
      
      ; We have finished to draw on image
      StartDrawingOnImage = 0
      StartDrawingOnImageNotClear = 0
      
      ; for the Gersam Line brush Tool
      Gersamclic =0 
      
      ;}
      
    EndIf
    
    ;}
    
  Else 
    
    ;{ we are not on the screen, free the mouse to use the gadgets // on n'est pas sur le screen, on libère la souris pour pouvoir utiliser les gadgets      
    If inscreen = 1
      inscreen = 0
      ;ReleaseMouse(1) ; mac, linux ?
      ; FlipBuffers()
    EndIf
    ;}
    
  EndIf
  
  ;}
  
  
  ;{ Keyboard
  
  If ExamineKeyboard()
    
    If KeyboardPushed(#PB_Key_LeftControl)
      Control = 1
    EndIf
    If KeyboardReleased(#PB_Key_LeftControl)
      Control = 0
    EndIf
    If KeyboardPushed(#PB_Key_LeftAlt)
      Alt = 1
    EndIf
    If KeyboardReleased(#PB_Key_LeftAlt)
      Alt = 0
    EndIf
    If KeyboardPushed(#PB_Key_LeftShift)
      Shift = 1
    EndIf
    If KeyboardReleased(#PB_Key_LeftShift)
      Shift = 0
    EndIf
    
    If Control = 1
      If ElapsedMilliseconds()-chrono_keyboard>200
        If KeyboardPushed(#PB_Key_Subtract) ; zoom -
                                            ;If KeyZoom = 0
                                            ;KeyZoom = 1
          chrono_keyboard = ElapsedMilliseconds()
          If OptionsIE\zoom> 10
            OptionsIE\zoom=OptionsIE\zoom -10
            ScreenZoom()
          EndIf
          ;EndIf
        ElseIf KeyboardPushed(#PB_Key_Add) ; zoom+
                                           ;If KeyZoom = 0
                                           ;KeyZoom = 1
          chrono_keyboard = ElapsedMilliseconds()
          If OptionsIE\zoom< 5000
            OptionsIE\zoom=OptionsIE\zoom +10
            ScreenZoom()
          EndIf
          ;EndIf
        EndIf
      EndIf
      ;     If KeyboardReleased(#PB_Key_Subtract) Or KeyboardReleased(#PB_Key_Add)
      ;       KeyZoom = 0
      ;     EndIf
      
      If KeyboardPushed(#PB_Key_T) ; transform
        If key = 0
          key = 1
          UpdateTool(#G_IE_Transform) 
        EndIf
      EndIf
      
    Else
      
      If alt = 0 And shift = 0
        
        ; move the canvas
        If KeyboardPushed(#PB_Key_Space)
          If MoveCanvas = 0
            MoveCanvas = 1
            Canvas_SetImageforMove()
          EndIf      
        EndIf
        If KeyboardReleased(#PB_Key_Space)
          MoveCanvas = 0 
          MouseClic = 0
        EndIf
        
        
        If KeyboardPushed(#PB_Key_Left)
          If key > 0
            key -1
          Else
            If Action = #Action_Move         
              If layer(LayerID)\locked = 0 And layer(LayerID)\view = 1
                MoveLayerX -1
                If ActionKeyb = 0
                  oldposx = layer(layerid)\x
                  oldposy = layer(layerid)\y
                  ActionKeyb = 1
                EndIf              
                Layer(layerId)\x = oldposx + MoveLayerX
                Layer(layerId)\y = oldposy + MoveLayerY
                ScreenUpdate()
              EndIf
              key = 5
            EndIf 
          EndIf
        EndIf
        If KeyboardPushed(#PB_Key_Right)
          If key > 0
            key -1
          Else
            If Action = #Action_Move  
              If layer(LayerID)\locked = 0 And layer(LayerID)\view = 1
                MoveLayerX +1
                If ActionKeyb = 0
                  oldposx = layer(layerid)\x
                  oldposy = layer(layerid)\y
                  ActionKeyb = 1
                EndIf             
                Layer(layerId)\x = oldposx + MoveLayerX
                Layer(layerId)\y = oldposy + MoveLayerY
                ScreenUpdate()
              EndIf            
              key = 5
            EndIf 
          EndIf        
        EndIf
        If KeyboardPushed(#PB_Key_Up)
          If key > 0
            key -1
          Else
            If Action = #Action_Move          
              If layer(LayerID)\locked = 0 And layer(LayerID)\view = 1
                MoveLayerY-1
                If ActionKeyb = 0
                  oldposx = layer(layerid)\x
                  oldposy = layer(layerid)\y
                  ActionKeyb = 1
                EndIf              
                Layer(layerId)\x = oldposx + MoveLayerX
                Layer(layerId)\y = oldposy + MoveLayerY
                ScreenUpdate()
              EndIf  
              key = 5
            EndIf 
          EndIf        
        EndIf
        If KeyboardPushed(#PB_Key_Down)
          If key > 0
            key -1
          Else
            If Action = #Action_Move          
              If layer(LayerID)\locked = 0 And layer(LayerID)\view = 1
                MoveLayerY+1
                If ActionKeyb = 0
                  oldposx = layer(layerid)\x
                  oldposy = layer(layerid)\y
                  ActionKeyb = 1
                EndIf              
                Layer(layerId)\x = oldposx + MoveLayerX
                Layer(layerId)\y = oldposy + MoveLayerY
                ScreenUpdate()
              EndIf  
              key = 5
            EndIf 
          EndIf        
        EndIf
        
        ; raccourci outil
        If KeyboardPushed(#PB_Key_B)
          If key = 0
            key = 1
            UpdateTool(#G_IE_Brush) 
          EndIf
        EndIf
        If KeyboardPushed(#PB_Key_E)
          If key = 0
            key = 1
            UpdateTool(#G_IE_Eraser) 
          EndIf
        EndIf
        If KeyboardPushed(#PB_Key_K)
          If key = 0
            key = 1
            UpdateTool(#G_IE_Fill) 
          EndIf
        EndIf
        If KeyboardPushed(#PB_Key_G)
          If key = 0
            key = 1
            UpdateTool(#G_IE_Gradient) 
          EndIf
        EndIf
        If KeyboardPushed(#PB_Key_H)
          If key = 0
            key = 1
            UpdateTool(#G_IE_Hand) 
          EndIf
        EndIf      
        If KeyboardPushed(#PB_Key_Z)
          If key = 0
            key = 1
            UpdateTool(#G_IE_Zoom) 
          EndIf      
        EndIf 
        If KeyboardPushed(#PB_Key_V) ; move the layer
          MoveLayerY = 0
          MoveLayerX = 0
          If key = 0
            key = 1
            UpdateTool(#G_IE_Move) 
          EndIf
        EndIf
        If KeyboardPushed(#PB_Key_M) ; tool selection cadre
          If key = 0
            key = 1
            UpdateTool(#G_IE_Select) 
          EndIf
        EndIf
        
        ; raccourcis brush
        If KeyboardPushed(#PB_Key_D)
          If Brush(Action)\size > 1
            If Brush(Action)\size >= 100
              Brush(Action)\size -5         
            ElseIf Brush(Action)\size < 100 And Brush(Action)\size > 20
              Brush(Action)\size - 2          
            Else
              Brush(Action)\size-1          
            EndIf
            If Brush(Action)\SizeMin >Brush(Action)\Size
              Brush(Action)\SizeMin = Brush(Action)\Size
            EndIf          
            BrushUpdateImage(0,1) 
            BrushUpdateColor() 
            SetGadgetState(#G_BrushSize,Brush(Action)\size)
            SetGadgetState(#G_BrushSizeMin,Brush(Action)\SizeMin)
          EndIf
        EndIf
        If KeyboardPushed(#PB_Key_F)
          If Brush(Action)\size < 1000 
            If Brush(Action)\size >=100
              Brush(Action)\size +5          
            ElseIf Brush(Action)\size < 100 And Brush(Action)\size > 20
              Brush(Action)\size + 2            
            Else
              Brush(Action)\size+1            
            EndIf
            If Brush(Action)\SizeMin >Brush(Action)\Size
              Brush(Action)\SizeMin = Brush(Action)\Size
            EndIf 
            BrushUpdateImage(0,1)
            BrushUpdateColor()     
            SetGadgetState(#G_BrushSize,Brush(Action)\size)
            SetGadgetState(#G_BrushSizeMin,Brush(Action)\SizeMin)
          EndIf        
        EndIf
        
      EndIf
      
    EndIf
    
    If KeyboardReleased(#PB_Key_All)
      key = 0
    EndIf
    
  EndIf
  
  ;}
  
  
EndIf



; IDE Options = PureBasic 6.00 Alpha 2 (Windows - x64)
; CursorPosition = 413
; FirstLine = 137
; Folding = 8556-pBwP3H-v-XAAAgtJ+-fiCEgAAAAAAAw
; EnableXP
; Compiler = PureBasic 6.00 Alpha 2 - C Backend (Windows - x64)
; Warnings = Display
; EnablePurifier
; EnableUnicode