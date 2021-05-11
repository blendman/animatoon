
; menu
Declare CreateOptionsFile()
Declare AddLogError(error, info$) ; needed for error with initsprite/initkeyboard...
Declare Doc_Save()


; gadets, ui
Declare IE_UpdateGadget(gadget=1)


; paper
Declare PaperCreate(delete=0)

; layers
Declare CreateLayertempo_(create=0)
Declare RecreateLayerUtilities()
Declare Layer_Add(x=0,y=0,text$="") 
Declare Layer_FreeAll()
Declare Layer_Clear(i,onlyAlpha=0) 
Declare Layer_UpdateSprite(i)
Declare Layer_convertToBm(i) 
Declare Layer_bm2(i)  
Declare Layer_GetBm(id)  
Declare Layer_importImage(update=1)  
Declare Layer_ValidChange(Action,i=-1)  
Declare Layer_Rotate(i,angle)
Declare Layer_DrawAll()
Declare Layer_DrawSelection(x.f=-1, y.f=-1, color.q=-1, realtime = 0)
Declare IE_UpdateLayerUi() 
Declare Layer_GetLayerId()
Declare Layer_UpdateList(all=-1)
Declare Layer_updateUi(i)
Declare Layer_UpdateAll()
Declare Layer_updateAllBMSprite()
Declare Layer_DrawImg(u, alpha)
Declare Layer_UpdateForRenderingSystem()
Declare Layer_UpdateElementsForRenderingSystem()




; brush
Declare UpdateBrushPreview()  
Declare BrushUpdateImage(load=0,color=0) 
Declare OpenPresetBank() 
Declare BrushChangeColor(change=0,color=-1)

; Image
Declare LoadImage2(nb,file$, w=25, h=25)
Declare FreeImage2(img)
Declare CreateImage2(img,w,h,img$,d=24,t=0)

; image processing
Declare ResizeImage2_(image, w, h, mode=#PB_Image_Smooth)
Declare.l ColorBlending(Couleur1.l, Couleur2.l, Echelle.f) 
Declare.l RotateImageEx2(ImageID, Angle.f, Mode.a=2)
Declare UnPreMultiplyAlpha(image)

Declare UpdateColorFG()


; Screen
Declare ScreenUpdate(updateLayer=0, updateCanvas = 0)
Declare SetAlphaMask(i)


; canvas main
Declare Canvas_CreateImageMiniForMove(create=1)


; drawingmode
Declare Filtre_MelangeAlpha2(x, y, CouleurSource, CouleurDestination) 
Declare FiltreInverseBlendAlpha(x, y, SourceColor, TargetColor) 
Declare FiltreMelangeAlphaPat(x, y, SourceColor, TargetColor) 
Declare Filtre_MaskAlpha(x, y, SourceColor, TargetColor)
Declare Filtre_AlphaSel(x, y, SourceColor, TargetColor)

; paper
Declare PaperUpdate(load=0)
Declare PaperInit(load=1) 
Declare PaperDraw() 
Declare IE_StatusBarUpdate() ; statusbar 
Declare IE_UpdatePaperList()


; brush color
Declare GetColor(x,y) 
Declare BrushUpdateColor()
Declare BrushResetColor()

; window
Declare WindowLayerProp()
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 64
; FirstLine = 42
; EnableXP
; EnableUnicode