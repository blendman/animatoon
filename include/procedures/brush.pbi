
; Brush


; 
Macro Brush_SetSizewithPression()
  ; Tablet for pression // pour la pression tablet, à finir                     
  
  brushsiz.d = Brush(Action)\size * size/(8.54)                      
  If brushsiz < 0
    ;brushsiz = 0.05
    brushsiz = 0
  EndIf
  b = (brushsiz * Brush(Action)\Pas*0.01) * Brush(Action)\SizeW*0.01
  
  ;{ transition, pas encore pris en compte : 
  ; la transition = le fade entre les points pour lisser le changement de taille ou d'alpha.
  If brushsiz_old.d <= 0
    brushsiz_old = brushsiz
  EndIf
  
  ;                     ratio.d = stroke(StrokeId)\dot(i-1)\size - stroke(StrokeId)\dot(i)\size
  ;                     ratio.d = Abs(Brushsiz_old - Brushsiz)
  ;                     ratio/dist
  ;                    
  
  ;}
  
  ; FinalSize.d = (brushsiz_old+newsiz*v)*Brush(Action)\Sizepressure + (1-Brush(Action)\Sizepressure)     
  FinalSize.d = (((size/8.54)*Brush(Action)\Sizepressure + (1-Brush(Action)\Sizepressure)))
  
  rndsiz.d = Random(Brush(Action)\Size,Brush(Action)\SizeMin)
  rndsiz/Brush(Action)\Size
  If rndsiz <= 0
    rndsiz = 0.5 * (Brush(Action)\Size)/Brush(Action)\Size
  EndIf
  FinalSize = rndsiz * Brush(Action)\SizeRand + (1-Brush(Action)\SizeRand)*FinalSize
  If finalsize * Brush(Action)\size < Brush(Action)\SizeMin
    finalsize = Brush(Action)\SizeMin/Brush(Action)\size 
  EndIf
                    
EndMacro




Procedure BrushInitNb()
  
  ; pour définir le nombre d'image de brush qu'on a au maximum
  Brush(Action)\BrushNumMax=-1
  Directory$ = OptionsIE\DirBankBrush$+OptionsIE\DirBrush$+"\"
  ; Debug Directory$
  If ExamineDirectory(0, GetCurrentDirectory()+ Directory$, "*.png")  
    While NextDirectoryEntry(0)
      If DirectoryEntryType(0) = #PB_DirectoryEntry_File
        Brush(Action)\BrushNumMax +1
      EndIf
    Wend
    FinishDirectory(0)
  EndIf
  
EndProcedure
Procedure BrushChangeColor(change=0,color=-1)
  
  If change = 1
    w = ImageWidth(#BrushCopy)
    h = ImageHeight(#BrushCopy)
    
    If color <> -1
      colorQ = color
    Else
      colorQ = Brush(Action)\colorQ
    EndIf
    
    
    If StartDrawing(ImageOutput(#BrushCopy))  
      
      
      For i = 0 To w-1
        For j = 0 To h-1
          DrawingMode(#PB_2DDrawing_AlphaChannel)
          a.d = Alpha(Point(i,j)) ; - (255 - Brush(Action)\Alpha) ;on récupère l'alpha du brush (pixel par pixel) qu'on modifie par la valeur transparence
          
          If a >0
            
            ; à revoir !!! c'est cool, ca fait un fondu vers du noise (diminution alpha et taille !!
            
            a - Random(a*0.01, 0) * brush(action)\AlphaVsTime * 0.01
            
            If Brush(Action)\Intensity>=0
              If a < Brush(Action)\intensity           
                a = Brush(Action)\intensity
              EndIf
            Else 
              If a > 255+Brush(Action)\intensity           
                a = 255+Brush(Action)\intensity
              EndIf
            EndIf
            
            If a < (0 + Brush(Action)\Hardness)
              a = 0
            EndIf 
            If a > Brush(Action)\softness
              ; a - Brush(Action)\softness*0.5
            EndIf
            
;             test ajout de grain
            If a >0
             ;a - a*0.01 ; Random(a*0.1,0)
              a - Random(a*0.1, 0)*brush(action)\AlphaVsTime * 0.01
            EndIf
            If a < 0.9
              a=0
            EndIf
            
          EndIf
          
          
          
          DrawingMode(#PB_2DDrawing_Default)
          Plot(i,j,RGB(Red(colorQ), Green(colorQ), Blue(colorQ)))         
          
          DrawingMode(#PB_2DDrawing_AllChannels)
          
          Plot(i,j,RGBA(Red(colorQ), Green(colorQ), Blue(colorQ), a))  
          
                    ; test ajout de grain
                    DrawingMode(#PB_2DDrawing_AlphaClip)
                    Plot(i,j,RGBA(Red(colorQ), Green(colorQ), Blue(colorQ), Random(50,0))) 
          
        Next j
      Next i     
      
      
      
      ;        ; TEST add noise
      ;         DrawingMode(#PB_2DDrawing_AlphaClip)
      ;         For i= 0 To sw
      ;           For j=0 To sh
      ;             gris = Random(50,0)
      ;             Box(i, j, 1,1,RGBA(gris, gris, gris, 150))
      ;           Next j
      ;         Next
      
      StopDrawing()
    EndIf 
    
  EndIf
  
EndProcedure
Procedure BrushUpdateColor() 
  
  Shared CursorX, cursorY
  
  ; on update tout ce qui a rapport avec les couleur : 
  ; le brush, le preview, l'image couleur, selector, etc...
  
  Brush(Action)\Col\R = Red(Brush(Action)\color)
  Brush(Action)\Col\G = Green(Brush(Action)\color)
  Brush(Action)\Col\B = Blue(Brush(Action)\color)
  
  ;{ temporaire, en attente du color mixing
  Brush(Action)\ColorQ = Brush(Action)\color  
  BrushChangeColor(1)
  ;}
  ; UpdateBrushPreview()
  
  If StartDrawing(ImageOutput(#ImageColorBG))
    Box(0,0,100,100,Brush(Action)\Color)
    StopDrawing()
  EndIf
  SetGadgetState(#G_BrushColorBG, ImageID(#ImageColorBG)) 
  
  SetColorSelector(Brush(Action)\color,CursorX,CursorY,3,1) 
  
EndProcedure
Procedure BrushUpdateImage(load=0,color=0)
  
  Shared brushEditor
  
  ; need to check if action is a brush/erase/pen
  ac = action
  If action <> #Action_Brush And action <> #Action_Eraser And action <> #Action_Pen
    ac = #Action_Brush
    ; Debug "on change l'action"
  EndIf
  
  ; if load new image
  If load >= 1
    Directory$ = OptionsIE\DirBankBrush$ + OptionsIE\DirBrush$ + "\" + OptionsIE\brushName$
    Debug Directory$
    If Not LoadSprite(#Sp_BrushOriginal,Directory$,#PB_Sprite_AlphaBlending) 
      notok = 1
    EndIf
    ; LoadSprite(#Sp_BrushOriginal,Directory$+Str(Brush(Action)\id)+".png",#PB_Sprite_AlphaBlending)
    If Not LoadImage(#BrushOriginal,Directory$)
      notok = 1
    EndIf
    
    If Notok=1
      OptionsIE\brushName$ = "brush"+Str(Brush(ac)\Id)+".png"
      BrushUpdateImage(1)
      ProcedureReturn 0
    Else
      brush(ac)\Image$ = OptionsIE\brushName$
      brush(ac)\BrushDir$ = OptionsIE\DirBrush$
    EndIf
    ; LoadImage(#BrushOriginal,Directory$+Str(Brush(ac)\id)+".png")
    color = 1
  EndIf
  
  
  If Brush(ac)\Trim
    tmp = TrimDoc(#BrushOriginal) ; c'est pour couper (retailler l'image)
    CopyImage(tmp,#BrushCopy)
    FreeImage2(tmp)
    tmpsprite = CreateSprite(#PB_Any,ImageWidth(#BrushCopy),ImageHeight(#BrushCopy),#PB_Sprite_AlphaBlending)
    CopySprite(tmpsprite, #Sp_BrushCopy,#PB_Sprite_AlphaBlending)  
    FreeSprite2(tmpsprite)
    
  Else
    CopySprite(#Sp_BrushOriginal, #Sp_BrushCopy, #PB_Sprite_AlphaBlending)  
    CopyImage(#BrushOriginal, #BrushCopy)
  EndIf
  
  
  BrushChangeColor(color)
  
  w.d = (Brush(ac)\SizeW*0.01)*Brush(ac)\size * OptionsIE\zoom * 0.01
  h.d = (Brush(ac)\SizeH*0.01)*Brush(ac)\size * OptionsIE\zoom * 0.01  
  Brush(ac)\centerSpriteX = w/2
  Brush(ac)\centerSpriteY = h/2
  
  sw = (Brush(Action)\SizeW * 0.01) * Brush(ac)\size + Brush(ac)\Smooth*2
  sh = (Brush(ac)\sizeH * 0.01) * Brush(ac)\size + Brush(ac)\Smooth*2
  
  CheckIfInf(sw,2)
  CheckIfInf(sh,2)
  
  ;If Brush(ac)\OldW <> sw Or Brush(ac)\OldH <> sh ; on va resize que si on change la taille W ou H ^^
  ResizeImage(#BrushCopy,sw,sh,1-Brush(ac)\Smooth) ; in images.pbi
  
  
  Brush(ac)\OldW = sw 
  Brush(ac)\OldH = sh
  
  
  
  ;EndIf
  
  Brush(ac)\CenterX = Sw/2
  Brush(ac)\CenterY = Sh/2
  Brush(ac)\w = sw
  Brush(ac)\h = sh
  
  If Brush(ac)\rotate > 0
    tmp = RotateImageEx2(ImageID(#BrushCopy),Brush(ac)\rotate)
    CopyImage(tmp,#BrushCopy)  
    FreeImage(tmp)
    RotateSprite(#Sp_BrushCopy,Brush(ac)\rotate,#PB_Absolute)
  EndIf
  
  ZoomSprite(#Sp_BrushCopy, w, h)
  
  
  ; If Brush(ac)\Smooth; pour pallier le bug du smooth :( 
  If StartDrawing(ImageOutput(#BrushCopy))
    DrawingMode(#PB_2DDrawing_AlphaClip)
    Box(0,0,sw,sh,RGBA(Red(Brush(ac)\colorQ),Green(Brush(ac)\colorQ),Blue(Brush(ac)\colorQ),255))
    
    ;       
    ;; ATTENTION A REVOIR !
    
    ; TEST add noise
    If Brush(ac)\AddNoiseRandomOnImagebrush > 0
      DrawingMode(#PB_2DDrawing_AlphaChannel)
      For i= 0 To sw-1
        For j=0 To sh-1
          a = Alpha(Point(i,j))
          
          gris = 255 ; Random(255,0)
          If a > 0
            a - Random(a* Brush(ac)\AddNoiseOnImgMax*0.1, a* Brush(ac)\AddNoiseOnImgMin*0.1)
            ;               Box(i, j, 1,1,RGBA(gris, gris, gris, a))
            Plot(i,j, RGBA(gris, gris, gris, a))
          EndIf
        Next j
      Next
    EndIf
              
    
    StopDrawing()
  EndIf
  ; EndIf
  
  
  If load = 1    
    UpdateBrushPreview()
  EndIf
  
  If brushEditor = 1
    UpdateBrushImagePreview()
  EndIf
  
  ; ChangeCursor()
  
EndProcedure
Procedure BrushMixColor(color1,color2,mix.d=0) 
  ;melange = (Brush(Action)\mix*0.01)*(1-mix) + mix 
  col = ColorBlending(color1,color2,Brush(Action)\mix*0.01)
  ProcedureReturn col
EndProcedure
Procedure BrushSet()
  
  ;    Select Brush(Action)\tool
  ;     Case 0, 1
  ;       ;CurrentColor = RGBA(Red(CurrentColor), Blue(CurrentColor),Green(CurrentColor), Brush(Action)\alpha)               
  ;       CurrentColor = RGBA(Red(CurrentColor), Green(CurrentColor),Blue(CurrentColor), Brush(Action)\alpha * Brush(Action)\alphaTimer/100)               
  ;     Case 2
  ;       ;CurrentColor = RGB(Red(CurrentColor), Blue(CurrentColor),Green(CurrentColor))
  ;       CurrentColor = RGB(Red(CurrentColor), Green(CurrentColor),Blue(CurrentColor))
  ;   EndSelect
  
EndProcedure

; color mix
Procedure BrushGetMixColor(mx,my)
  
  If Brush(Action)\MixLayer = 1
    MixWithImg = 1
  EndIf
  
  Z.d = OptionsIE\Zoom*0.01
  rx = mx 
  ry = my
  
  color1 = RGB(brush(action)\Col\R,brush(action)\Col\G,brush(action)\Col\B)
  
  If MixWithImg = 0
    
    If StartDrawing(ScreenOutput())
      DrawingMode(#PB_2DDrawing_AllChannels)
      ; If rx>0 And rx<ScreenWidth()-1 And ry>0 And ry<ScreenHeight()-1                        
      If rx>0 And rx<OutputWidth()-1 And ry>0 And ry<OutputHeight()-1 
        Color1 = Point(rx,ry) 
      EndIf
      StopDrawing()
    EndIf
    
  Else
    rx = mx/z - canvasX/z
    ry = my/z - canvasY/z
    If StartDrawing(ImageOutput(layer(layerid)\Image))
      DrawingMode(#PB_2DDrawing_AllChannels)
      If rx>0 And rx<OutputWidth()-1 And ry>0 And ry<OutputHeight()-1 
        Color1 = Point(rx,ry) 
        alpha  = Alpha(Color1)        
        If alpha = 0
          color1 = RGB(brush(action)\Col\R,brush(action)\Col\G,brush(action)\Col\B)
        EndIf        
      EndIf 
      StopDrawing()
    EndIf
  EndIf
  
  ProcedureReturn color1 
EndProcedure
Procedure BrushBlend(mx,my)
  
  Color1 = BrushGetMixColor(mx,my)
  Color = Brush(Action)\Color
  Color = ColorBlending(Color1,color,Brush(Action)\mix*0.01)
  BrushChangeColor(1,color)
  Brush(Action)\Color = Color
  
  ;If specialfx                     
  Brush(Action)\colorQ = color
  ;EndIf
  
  ProcedureReturn Color
EndProcedure
Procedure BrushCheckMixInverse(mx,my)
  
  If Brush(Action)\Visco >0
    
    If Brush(Action)\ViscoCur > Brush(Action)\Visco
      
      Brush(Action)\ViscoCur = 0
      
      ;     ColorNext = BrushGetMixColor(mx,my) ; on sauvegarde la prochaine couleur
      ;     Brush(Action)\ColorNext = ColorNext
      ;     
      ;     ColorOld = Brush(Action)\ColorOld
      ;     ColorCur = Brush(Action)\Color
      ;     Color = ColorBlending(ColorCur,ColorOld,Brush(Action)\mix*0.01)
      ;     ; Color = ColorBlending(ColorOld,ColorCur,Brush(Action)\mix*0.01)
      ;     Brush(Action)\Color = ColorCur
      ; 
      
      u = Brush(Action)\ColorNext
      ColorNext = RGB(Red(u),Green(u),Blue(u))
      u = Brush(Action)\Color
      ColorCur = RGB(Red(u),Green(u),Blue(u))
      
      ;Color = ColorBlending(ColorNext,colorCur, Brush(Action)\mix*0.01)
      Color = ColorBlending(colorCur,ColorNext, Brush(Action)\mix*0.01)
      
      BrushChangeColor(1,color)
      Brush(Action)\ColorOld = Color
      Brush(Action)\ColorNext = BrushGetMixColor(mx,my) ; on sauvegarde la prochaine couleur
      
      ;If specialfx                     
      Brush(Action)\colorQ = color
      ;EndIf
      
      ; BrushChangeColor(1,color)
      
    Else  
      ; on mélange les couleurs pour faire un fade vers la prochaine nouvelle couleur
      Brush(Action)\ViscoCur +1
      MixFade.d = ((Brush(Action)\Mix * Brush(Action)\ViscoCur)/(Brush(Action)\Visco+1))*0.01
      u = Brush(Action)\ColorNext
      ColorNext = RGB(Red(u),Green(u),Blue(u))
      u = Brush(Action)\Color
      ColorCur = RGB(Red(u),Green(u),Blue(u))
      ; Color = ColorBlending(colorCur,ColorNext,MixFade)
      Color = ColorBlending(ColorNext,colorCur, MixFade)
      color = Brush(Action)\ColorOld
      Brush(Action)\ColorOld = Color
      Brush(Action)\Color = color
      BrushChangeColor(1,color)
      
    EndIf
  Else
    Color = BrushBlend(mx,my)
    ; BrushChangeColor(1,color)
  EndIf
  
  Brush(Action)\Col\R = Red(Color)
  Brush(Action)\Col\G = Green(Color)
  Brush(Action)\Col\B = Blue(Color)
  
  ProcedureReturn color
EndProcedure
Procedure BrushCheckMixClassic(mx,my)
  
  ; pour mélanger les couleurs;
  ;   Brush(Action)\ColRnd = couleur random
  ;   Brush(Action)\OldCol = ancienne couleur
  ;   Brush(Action)\NewCol = nouvelle couleur (celle vers laquelle on va aller)
  ;   Brush(Action)\ColTmp = couleur temporaire (la couleur actuelle du mélange) = blendcolor(oldcol, newcol, melange)
  
  
  If Brush(Action)\mix > 0 ; on vérifie si on doit les mélanger
    
    If Brush(Action)\mix <=101 ; si le mix est au max, on prend juste la nouvelle couleur
      
      
      If Brush(Action)\ViscoCur > 0 ; la persistance actuel doit être >1	
        
        Brush(Action)\ViscoCur -1
        
        tx.d = Brush(Action)\mix/(Brush(Action)\Visco+1) ; le taux 
        a = Brush(Action)\ViscoCur									
        u.d = (100-(Brush(Action)\mix - a*tx))*0.01 ; le % de la couleur ancienne
        v.d = (Brush(Action)\mix - a*tx)*0.01       ; le % de la nouvelle couleur
        
        ; 									/*
        ; 									Brush(Action)\Col\R = Max(Brush(Action)\NewCol\R*v# + Brush(Action)\Col\R *u#,255)
        ; 									Brush(Action)\Col\G = Max(Brush(Action)\NewCol\R*v# + Brush(Action)\Col\G *u#,255)
        ; 									Brush(Action)\Col\B = Max(Brush(Action)\NewCol\R*v# + Brush(Action)\Col\B *u#,255)
        ; 									*/
        
        ; Debug StrD(u)+"/"+StrD(v)
        ; puis, on mélange
        Brush(Action)\Col\R = SetMaximum(Brush(Action)\NewCol\R*v + Brush(Action)\oldCol\R *u,255)
        Brush(Action)\Col\G = SetMaximum(Brush(Action)\NewCol\G*v + Brush(Action)\oldCol\G *u,255)
        Brush(Action)\Col\B = SetMaximum(Brush(Action)\NewCol\B*v + Brush(Action)\oldCol\B *u,255)
        
      Else
        
        Brush(Action)\ViscoCur = Brush(Action)\Visco        
        colorValue = BrushGetMixColor(mx,my)   
        Alpha = Alpha(colorValue) ; et son alpha
        
        ;Debug alpha
        
        ; If colorValue < 0 And alpha > 0
        ;If Alpha > 0
        
        tx.d = Brush(Action)\mix/(Brush(Action)\Visco+1) ; le taux de mélange
        a = Brush(Action)\ViscoCur									
        u.d = (100-(Brush(Action)\mix - a*tx))*0.01 ; le % de la couleur ancienne
        v.d = (Brush(Action)\mix - a*tx)*0.01       ; le % de la nouvelle couleur
        
        ; on garde les anciens paramètres
        Brush(Action)\OldCol\R = Brush(Action)\Col\R 
        Brush(Action)\OldCol\G = Brush(Action)\Col\G
        Brush(Action)\OldCol\B = Brush(Action)\Col\B
        
        Brush(Action)\NewCol\R = Red(colorValue) ;//SetMaximum(GetColorR(colorValue)*v# + Brush(Action)\Col\R *u#,255)
        Brush(Action)\NewCol\G = Green(colorValue) ;//SetMaximum(GetColorG(colorValue)*v# + Brush(Action)\Col\G *u#,255)
        Brush(Action)\NewCol\B = Blue(colorValue)  ;//SetMaximum(GetColorB(colorValue)*v# + Brush(Action)\Col\B *u#,255)
        
        ; et on mélange pour les nouveaux :)
        Brush(Action)\Col\R = SetMaximum(Brush(Action)\NewCol\R*v + Brush(Action)\oldCol\R *u,255)
        Brush(Action)\Col\G = SetMaximum(Brush(Action)\NewCol\G*v + Brush(Action)\oldCol\G *u,255)
        Brush(Action)\Col\B = SetMaximum(Brush(Action)\NewCol\B*v + Brush(Action)\oldCol\B *u,255)
        
        ; Debug RGB(Brush(Action)\Col\R,Brush(Action)\Col\G,Brush(Action)\Col\B)
        
        ; 										// Brush(Action)\NewCol\R = Brush(Action)\Col\R
        ; 										// Brush(Action)\NewCol\G = Brush(Action)\Col\G
        ; 										// Brush(Action)\NewCol\B = Brush(Action)\Col\B
        
        ;EndIf
        
        
      EndIf
      
      ;{ mix 100%
      ;{ à conserver pour après  
    ElseIf plustard = 1 ; Brush(Action)\mix = 100 
      
      If Brush(Action)\ViscoCur > 0
        Brush(Action)\ViscoCur -1
        
        Palier = Brush(Action)\mix/(Brush(Action)\Visco+1)
        a = Brush(Action)\ViscoCur									
        u.d = (100-(Brush(Action)\mix-a*palier))*0.01
        v.d = (Brush(Action)\mix-a*palier)*0.01
        
        
        Brush(Action)\Col\R = SetMaximum(Brush(Action)\NewCol\R*v + Brush(Action)\OldCol\R *u,255)
        Brush(Action)\Col\G = SetMaximum(Brush(Action)\NewCol\G*v + Brush(Action)\OldCol\G *u,255)
        Brush(Action)\Col\B = SetMaximum(Brush(Action)\NewCol\B*v + Brush(Action)\OldCol\B *u,255)
        
        ; 									/*
        ; 									Brush(Action)\Col\R = Brush(Action)\NewCol\R
        ; 									Brush(Action)\Col\G = Brush(Action)\NewCol\G
        ; 									Brush(Action)\Col\B = Brush(Action)\NewCol\B
        ; 									*/
        
      Else
        Brush(Action)\ViscoCur = Brush(Action)\Visco
        
        ;HideGadget(0)
        colorValue = Point(px,py)
        Alpha = Alpha(colorValue)
        ;HideGadget(1-option.HideAll)
        
        If colorValue < 0 And alpha > 0
          ; 										//u# = (100-Brush(Action)\mix)*0.01
          ; 										//v# = Brush(Action)\mix*0.01 //1 - u#
          Brush(Action)\OldCol\R = Brush(Action)\Col\R 
          Brush(Action)\OldCol\G = Brush(Action)\Col\G
          Brush(Action)\OldCol\B = Brush(Action)\Col\B
          
          Brush(Action)\NewCol\R = SetMaximum(Red(colorValue),255)
          Brush(Action)\NewCol\G = SetMaximum(Green(colorValue),255)
          Brush(Action)\NewCol\B = SetMaximum(Blue(colorValue),255)
          
        EndIf					
      EndIf
      ;}
      
    EndIf												
    ;}
    
  Else ; si mix = 0
    Brush(Action)\Col\R = Brush(Action)\ColorBG\R
    Brush(Action)\Col\G = Brush(Action)\ColorBG\G ; ColorBG\G	
    Brush(Action)\Col\B = Brush(Action)\ColorBG\B ; ColorBG\B
  EndIf
  
  R = SetMaximum(Brush(Action)\Col\R + Rnd2(0,Brush(Action)\ColRnd\R),255)
  G = SetMaximum(Brush(Action)\Col\G + Rnd2(0,Brush(Action)\ColRnd\G),255)
  B = SetMaximum(Brush(Action)\Col\B + Rnd2(0,Brush(Action)\ColRnd\B),255)
  
  R = Brush(Action)\Col\R
  G = Brush(Action)\Col\G 
  B = Brush(Action)\Col\B
  
  Brush(Action)\colTmp\R = R
  Brush(Action)\colTmp\G = G
  Brush(Action)\colTmp\B = B
  color_new = RGB(R,G,B)
  
  BrushChangeColor(1,color_new)
  
  ; Brush(Action)\colorQ = Color_New
  ; SetSpriteColor(SpriteBrush,R,G,B,Brush(Action)\alphaCur)
  
  ProcedureReturn color_new
EndProcedure
Procedure BrushCheckMixOld(mx,my)
  
  u = Brush(Action)\color
  Color = RGB(Red(u),Green(u),Blue(u))
  
  u = BrushGetMixColor(mx,my) 
  Color1 = RGB(Red(u),Green(u),Blue(u))
  
  ; Brush(Action)\colorQ = BrushMixColor(color1,Color) avec le 1)                    
  Color = BrushMixColor(Color1,color)
  
  If brush(action)\MixLayer = 1
    Alpha = Alpha(u) 
    If alpha = 0
      ;Brush(action)\AlphaOld = Brush(action)\Alpha
      Brush(action)\Alpha = brush(action)\AlphaMax * (100-brush(action)\Mix) *0.01    
    Else
      If brush(action)\Alpha < brush(action)\AlphaMax
        Brush(action)\Alpha = alpha
        ;Brush(action)\AlphaOld = Brush(action)\Alpha
      Else
        brush(action)\Alpha = brush(action)\AlphaMax
      EndIf    
    EndIf    
  EndIf
  
  ;If alpha > 0
  ; StatusBarText(#Statusbar,3,"Alpha : "+Str(alpha))
  If specialfx                     
    Brush(Action)\colorQ = color
  EndIf
  
  BrushChangeColor(1,color)
  ;Else
  ;color = Brush(Action)\colorQ
  ;EndIf
  
  
  ProcedureReturn color
EndProcedure
Procedure BrushCheckMixNew(mx,my)
  
  
  If Brush(Action)\ViscoCur > 0	; la persistance actuel doit être >1	
    
    Brush(Action)\ViscoCur -1
    
    Color = Brush(Action)\color
    Color1 = Brush(Action)\colorQ
    ; Brush(Action)\colorQ = BrushMixColor(color1,Color) avec le 1)                    
    color = BrushMixColor(Color,color1)
    Brush(Action)\colorQ = color
    BrushChangeColor(1,color)
    
  Else
    Brush(Action)\ViscoCur = Brush(Action)\Visco
    Color = Brush(Action)\color
    Color1 = BrushGetMixColor(mx,my)   
    Alpha = Alpha(color1) 
    ; Brush(Action)\colorQ = BrushMixColor(color1,Color) avec le 1)                    
    color = BrushMixColor(Color1,color)
    
    If specialfx                     
      Brush(Action)\colorQ = color
    EndIf
    
    BrushChangeColor(1,color)
    ;Else
    ;color = Brush(Action)\colorQ
    ;EndIf
  EndIf
  
  ProcedureReturn color
EndProcedure


Procedure BrushResetColor()
  
  With Brush(Action)
    \ColorNext = \color
    \ColorOld = \color
    \Col\R = \ColorBG\R
    \Col\G = \ColorBG\G
    \Col\B = \ColorBG\B
    
    \NewCol = \Col
    ; \oldCol = \Col
  EndWith
  
EndProcedure


; presets
Procedure.s GetParentItemText(gadget)
  ; Author: Fangbeast (updated For PB4.00 by blbltheworm)
  ; Date: 17. October 2003
  ; adapted by Blendman 2012
  CurrentItem.l = GetGadgetState(gadget)
  CurrentText.s = GetGadgetItemText(gadget, CurrentItem, 0)
  
  ItemToWalk.l = CurrentItem
  FullPath.s   = CurrentText.s
  
  While GetGadgetItemAttribute(gadget, ItemToWalk,#PB_Tree_SubLevel) > 0
    curSubLevel.l=GetGadgetItemAttribute(gadget, ItemToWalk,#PB_Tree_SubLevel)
    
    i.l=0
    While curSubLevel<=GetGadgetItemAttribute(gadget, ItemToWalk-i,#PB_Tree_SubLevel)
      i+1
    Wend
    
    ParentNumber.l = ItemToWalk-i
    
    ParentText.s   = GetGadgetItemText(gadget, ParentNumber, 0)
    FullPath.s     = ParentText + "/" + FullPath
    ItemToWalk     = ParentNumber
  Wend
  
  If Left(FullPath.s, 1) = "/"
    FullPath.s = Mid(FullPath.s, 2, Len(FullPath.s) - 1)
  EndIf
  
  ProcedureReturn FullPath
EndProcedure
Procedure OpenPreset(file$,brush$="")
  
  If OpenPreferences(OptionsIE\DirPreset$+"\"+file$+".abp")
    
    With brush(Action)
      
      \name$    = brush$
      \Version  = ReadPreferenceInteger("version",0)
      
      ; SIZE
      \size     =  ReadPreferenceInteger("size",32)
      \SizeW    =  ReadPreferenceInteger("sizeX",100)
      \sizeH    =  ReadPreferenceInteger("sizeY",100)
      \SizeRand = ReadPreferenceInteger("randSiz",0)
      \SizeMin  = ReadPreferenceInteger("size_min",1)
      \sizeRndFactor = ReadPreferenceInteger("brushsizeRndfactor",0)
      \Sizepressure = ReadPreferenceInteger("sizepressure",0)
      
      ; ROTATION
      \rotate         = ReadPreferenceInteger("rotate",0)
      \randRot        = ReadPreferenceInteger("randRot",0) 
      \RotateByAngle = ReadPreferenceInteger("rotateangle", 0)
      \RotateMin = ReadPreferenceInteger("RotateMin", 0)
      
      ; ALPHA
      \alpha    = ReadPreferenceInteger("alpha",255) 
      \AlphaFactorVsTime = ReadPreferenceInteger("alphaFactorVsTime",0)
      \AlphaVsTime = ReadPreferenceInteger("alphaVsTime",0)
      \AlphaPressure = ReadPreferenceInteger("alphapressure",0)
      \AlphaRand = ReadPreferenceInteger("alphaRand",0)
      \AlphaMin = ReadPreferenceInteger("alphaMin",0)
      
      ; noise
      \AddNoise = ReadPreferenceInteger("AddNoise",0)
      \AddNoiseOnImgGrey = ReadPreferenceInteger("AddNoiseOnImgGrey",0)
      \AddNoiseOnImgMax = ReadPreferenceInteger("AddNoiseOnImgMax",0)
      \AddNoiseOnImgMin = ReadPreferenceInteger("AddNoiseOnImgMin",0)
      \AddNoiseRandomOnImagebrush = ReadPreferenceInteger("AddNoiseRandomOnImagebrush",0)
      
      ; TOOL      
      \tool     = ReadPreferenceInteger("tool",0)
      
      ; COLOR
      ;\Color = ReadPreferenceInteger("color",-1)
      ;If \color >=0
      ;\ColorQ = \color        
      ;EndIf 
      
      ; DIFFUSION
      \scatter  = ReadPreferenceInteger("scatter",10)
      If \scatter >0
        ;\scatterOk = 1
      EndIf
      
      ; PAS et TRAIT 
      If \version < 6
        \pas = ReadPreferenceInteger("pas",5) + (1-\version)*20
        If \Rotate = 1
          \RandRot = 360
        EndIf
        \AlphaRand = ReadPreferenceInteger("randTra",0)
        \AlphaMin = ReadPreferenceInteger("transpmini",0)
      Else
        \pas = ReadPreferenceInteger("pas",5)        
      EndIf
      If \pas < 0
        \pas = 5
      EndIf
      
      \Trait = ReadPreferenceInteger("paintline",0)
      \Hardness = ReadPreferenceInteger("hardness",0)
      \Softness = ReadPreferenceInteger("softness",0)
      \Intensity = ReadPreferenceInteger("intensity",0)
      \Smooth = ReadPreferenceInteger("smooth",0)
      
      ; MIX, viscoty..
      \mix = ReadPreferenceInteger("mixing",0)
      \visco = ReadPreferenceInteger("visco",0)
      If \mix = 0
        ; SetColor()
      EndIf
      \MixType = ReadPreferenceInteger("mixtyp",2)
      
      ; THE BRUSH
      \image$ = ReadPreferenceString("image","aquarelle01.jpg") 
      Debug  "brush image name : "+\image$
      \BrushDir$ = ReadPreferenceString("brushdir","blendman")
      OptionsIE\DirBrush$ = \BrushDir$
      \id = ReadPreferenceInteger("brush",5)
      If \Image$ = #Empty$
        \Image$ = "brush"+Str(\id)+".png"
      EndIf
      OptionsIE\BrushName$ = \image$ 
      Debug "OptionsIE\BrushName$ : "+OptionsIE\BrushName$
      
    EndWith
    ClosePreferences()  
    
  EndIf
  
  BrushInitNb()
  BrushSet()
  BrushUpdateImage(1,1)
  BrushUpdateColor()
  
  With brush(action)
    ; set the gadget with new params
    SetGadgetState(#G_BrushPreview,ImageID(#Img_PreviewBrush))
    
    SetGadgetState(#G_BrushRandRotate,\randRot)
    SetGadgetState(#G_BrushRotate,\Rotate)
    SetGadgetState(#G_BrushRotateAngle,\RotateByAngle)
    
    SetGadgetState(#G_BrushScatter,\scatter)
    
    ; size
    SetGadgetState(#G_BrushSize,\size)
    SetGadgetState(#G_BrushSizeW,\SizeW)
    SetGadgetState(#G_BrushSizeH,\sizeH)
    SetGadgetState(#G_BrushSizeRand,\SizeRand)
    SetGadgetState(#G_BrushSizeMin,\SizeMin)
    
    ; alpha
    SetGadgetState(#G_BrushAlpha,\alpha)
    SetGadgetState(#G_BrushAlphaPressure,\AlphaPressure)
    SetGadgetState(#G_BrushAlphaRand,\AlphaRand)
    ;SetGadgetState(#G_BrushAlphaFactorVsTime,\AlphaFactorVsTime)
    ;SetGadgetState(#G_BrushTraVsTime,\AlphaVsTime)
    
    ;SetGadgetState(#G_BrushType,\type)
    ;SetGadgetState(#G_BrushTool,\tool)
    SetGadgetState(#G_BrushPas,\pas)
    SetGadgetState(#G_brushTrait,\Trait)
    SetGadgetState(#G_BrushMix,\mix)  
    SetGadgetState(#G_BrushMixTyp,\MixType)  
    SetGadgetState(#G_BrushVisco,\visco)
    SetGadgetText(#G_PresetName,\name$)
    
    SetGadgetState(#G_brushHardness,\Hardness)
    SetGadgetState(#G_brushSmooth,\Smooth)
    SetGadgetState(#G_brushIntensity,\Intensity)
  EndWith
  
EndProcedure
Procedure OpenPresetBank()
  
  BrushInitNb()
  
  ; clear all needed
  ClearGadgetItems(#G_PresetTG)
  ClearList(BrushGroup())
  
  ; on ajoute les répertoire du treegadget
  If ExamineDirectory(0, OptionsIE\DirPreset$, "*.*")  
    While NextDirectoryEntry(0)      
      If DirectoryEntryType(0) = #PB_DirectoryEntry_Directory
        group$ =DirectoryEntryName(0) 
        If group$ <>"." And group$ <>".." And group$ <> OptionsIE\DirPreset$
          AddElement(BrushGroup())
          BrushGroup()\group$ = group$
        EndIf
      EndIf     
    Wend
    FinishDirectory(0)
  EndIf
  ; puis, on examine tous les fichiers de chaque répertoire
  ForEach BrushGroup()   
    With BrushGroup()
      AddGadgetItem(#G_PresetTG,-1,\group$,0,0)      
      If ExamineDirectory(0, OptionsIE\DirPreset$+"\"+\group$+"\", "*.abp") 
        While NextDirectoryEntry(0)  
          Nom$ = DirectoryEntryName(0)            
          If OpenPreferences(OptionsIE\DirPreset$+"\"+\group$+"\"+Nom$)
            AddGadgetItem(#G_PresetTG,-1,RemoveString(Nom$,".abp"),0,1)      
            ClosePreferences()
          EndIf         
        Wend
        FinishDirectory(0)
      EndIf
    EndWith    
  Next
  
EndProcedure
Procedure SaveBrush()
  
  With brush(Action)
    
    PreferenceComment("// Animatoon brush Preset - Blendman 2011-21") 
    WritePreferenceString("name",\name$)
    WritePreferenceInteger("version", 6)
    
    ; size
    WritePreferenceInteger("size",\size)
    WritePreferenceInteger("sizeMin",\SizeMin)
    WritePreferenceInteger("sizeX",\sizeW)
    WritePreferenceInteger("sizeY",\sizeH)
    WritePreferenceInteger("randSiz",\SizeRand)
    WritePreferenceInteger("size_min",\SizeMin)
    WritePreferenceInteger("sizepressure",\Sizepressure)
    WritePreferenceInteger("brushsizeRndfactor",\sizeRndFactor)
    
    ; dynamics
    WritePreferenceInteger("rotate",\rotate)
    ;WritePreferenceInteger("rotation",\rotation)
    WritePreferenceInteger("randRot",\randRot)
    WritePreferenceInteger("rotateangle",\RotateByAngle)
    WritePreferenceInteger("RotateMin",\RotateMin)
    
    
    WritePreferenceInteger("scatter",\scatter)
    WritePreferenceInteger("ScatterMin",\ScatterMin)
    ;If option\brushPresetsavecolor
    ;WritePreferenceInteger("color",\color) 
    ;EndIf  
    
    ; alpha
    WritePreferenceInteger("alpha",\alpha)
    WritePreferenceInteger("alphapressure",\AlphaPressure)
    WritePreferenceInteger("alphaFactorVsTime",\AlphaFactorVsTime)
    WritePreferenceInteger("alphaVsTime",\AlphaVsTime)
    WritePreferenceInteger("alphaRand",\AlphaRand)
    WritePreferenceInteger("alphaMin",\AlphaMin)
    ; noise
    WritePreferenceInteger("AddNoise",\AddNoise)
    WritePreferenceInteger("AddNoiseOnImgMax",\AddNoiseOnImgMax)
    WritePreferenceInteger("AddNoiseOnImgMin",\AddNoiseOnImgMin)
    WritePreferenceInteger("AddNoiseRandomOnImagebrush",\AddNoiseRandomOnImagebrush)
    
    WritePreferenceString("image",\image$)
    WritePreferenceString("brushdir",\brushdir$)
    WritePreferenceInteger("brush",\id)
    
    WritePreferenceInteger("pas",\pas)
    WritePreferenceInteger("paintline",\trait)
    WritePreferenceInteger("hardness",\Hardness)
    WritePreferenceInteger("softness",\Softness)
    WritePreferenceInteger("intensity",\Intensity)
    WritePreferenceInteger("smooth",\Smooth)
    
    WritePreferenceInteger("mixing",\mix)
    WritePreferenceInteger("visco",\visco)
    WritePreferenceInteger("mixtyp",\MixType)
    
    WritePreferenceString("group",\group$)       
    
  EndWith 
  
EndProcedure
Procedure SaveBrushPreset(mode=0,file$="")
  
  If mode = 0 ; on sauve un nouveau brush
    file$ = SaveFileRequester("Save a Brush Preset", OptionsIE\DirPreset$+"Preset.abp","*.abp",0)
    If GetExtensionPart(file$) <> "abp"
      file$ = file$ + ".abp"
    EndIf    
  Else       
    file$ = OptionsIE\DirPreset$+"\"+file$+".abp"
  EndIf
  
  If file$ 
    If CreatePreferences(file$)
      SaveBrush()    
      ClosePreferences()
;     Else
;       If CreatePreferences(file$)
;         SaveBrush()
;         ClosePreferences()
;       EndIf
    EndIf    
  EndIf  
  
EndProcedure




; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 205
; FirstLine = 19
; Folding = AAA5--AAAAAwBBg5
; EnableXP
; DisableDebugger
; EnableUnicode