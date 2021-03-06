; animatoon (screen), loop pb5.30 -06/2015 , PB5.73 03.2021


; The loop for the program // La boucle pour l'application
CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  
  ;{ not finished at all !
  
  
  Screen = SDL_SetVideoMode_(width, height, depth, #SDL_OPENGL | #SDL_FULLSCREEN)
  
  Repeat
    
    
    
    While SDL_PollEvent_(@Event.SDL_Event)
      
      Select Event\Type
        Case #SDL_MOUSEBUTTONDOWN
          If Event\button\button = 4
            MouseWheels + 1 ;will add to the scrolling
          ElseIf event\button\button = 5
            MouseWheels - 1 ;will subtract from the scrolling
          EndIf
      EndSelect
      
    Wend
    
  Until quit = 1
  
  
  ;}
  
  ; CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
  
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_MacOS
  
  Repeat
    
    Z.d = OptionsIE\Zoom * 0.01
    mx = WindowMouseX(0) - ScreenX 
    my = WindowMouseY(0) - ScreenY
    
    Repeat 
      
      Event       = WaitWindowEvent(1)
      EventMenu   = EventMenu()
      EventGadget = EventGadget()
      EventType   = EventType()
      EventWindow = EventWindow()
      
      RunScript(ScriptNumber)
      AutoSave()
      
      ; SetWindowTitle(#WinMain, Str(OptionsIE\ImageHasChanged))
      
      If event <> 0
        
        SaveScript(Event)      
        SaveHistory(Event) ; for history : undo/redo
        
        Select Event
            
          Case #PB_Event_Menu
            ;{ menu
            ScreenResized = 0          
            If inscreen
              ; ReleaseMouse(1)
              MenuOpen = 1
            EndIf
            
            If EventMenu < #Menu_Last
              
              Select EventMenu
                  
                  ;{-- menu main
                  
                  ;{ file
                  
                Case #menu_New
                  WindowDocNew()
                  
                Case #Menu_Open
                  Doc_Open()
                  
                Case #Menu_Save
                  Doc_Save()
                  
                Case #Menu_SaveImage ; save an image with all layers visibles and background
                  File_SaveImage()
                  
                Case #Menu_Import
                  Layer_ImportImage()
                  
                Case #Menu_ExportAll            
                  filename$ = SaveFileRequester("Save all images","","png|*.png",0)
                  If filename$ <>""
                    For i=0 To ArraySize(layer())
                      ; name$=GetFilePart(filename$)+"_Layer"+Str(i)+ ".png"
                      name$=filename$+"_Layer"+Str(i)+ ".png"
                      SaveImage(Layer(i)\image, name$,#PB_ImagePlugin_PNG)
                    Next i  
                  EndIf
                  
                Case #Menu_ExportAllZip  
                  filename$ = SaveFileRequester("Save all images in zip","","zip|*.zip",0)
                  If filename$ <>""
                    If GetFileExist(filename$+".zip") = #True
                      rep = MessageRequester(Lang("Info"), Lang("The file exist. Save over it ?"), #PB_MessageRequester_YesNo)
                      If rep = 6
                        ok = 1
                      EndIf
                    Else
                      ok = 1
                    EndIf 
                    If ok = 1
                      UseZipPacker()
                      If CreatePack(0, filename$+".zip")
                        For i=0 To ArraySize(layer())
                          name$=GetFilePart(filename$)+"_Layer"+Str(i)+ ".png"
                          SaveImage(Layer(i)\image, name$,#PB_ImagePlugin_PNG)
                          AddPackFile(0, name$, name$)
                          DeleteFile(name$)
                        Next i
                        ClosePack(0) 
                      EndIf
                    EndIf
                  EndIf
                  
                Case #Menu_Export ; on export le layer courant              
                  filename$ = SaveFileRequester("Save Image","","png|*.png",0)
                  If filename$ <>"" 
                    If GetFileExist(filename$) = #True
                      rep = MessageRequester(Lang("Info"), Lang("The file exist. Save over it ?"), #PB_MessageRequester_YesNo)
                      If rep = 6
                        ok = 1
                      EndIf
                    Else
                      ok=1
                    EndIf 
                    If ok = 1
                      If GetExtensionPart(filename$) <> "png"
                        filename$ + ".png"
                      EndIf
                      ; Layer_SetSpriteToImage()
                      If OptionsIE\SaveImageRT
                        SaveImage(Layer(LayerId)\image, filename$,#PB_ImagePlugin_PNG)
                      Else
                        CopySprite(Layer(LayerId)\Sprite,#Sp_CopyForsave, #PB_Sprite_AlphaBlending)
                        SaveSprite(#Sp_CopyForsave, filename$+"_sprite", #PB_ImagePlugin_PNG)
                        FreeSprite2(#Sp_CopyForsave)
                      EndIf                  
                    EndIf
                  EndIf
                  
                Case #Menu_Pref
                  WindowPref()
                  
                Case #Menu_Exit
                  quit = 1
                  Break
                  
                  ;}
                  
                  ;{ Editions
                Case #Menu_clear
                  Layer_Clear(LayerId)
                  
                Case #Menu_Paste
                  Edit_Paste()
                  
                Case #Menu_Cut
                  If Edit_Copy()
                    Layer_Clear(LayerId)
                  EndIf
                  
                  
                Case #Menu_Copy
                  Edit_Copy()
                  
                Case #Menu_FillAll
                  Layer_Fill(1)
                  
                Case #Menu_Fill
                  Layer_Fill(0)
                  
                Case #Menu_FillPatern
                  Layer_Fill(2)
                  
                Case #Menu_MirorH 
                  MirorImage(Layer(LayerId)\Image)
                  
                Case #Menu_MirorV 
                  MirorImage(Layer(LayerId)\Image,0)
                  
                Case #Menu_RealTime
                  Clear = 1-clear
                  SetMenuItemState(0,#Menu_RealTime,Clear)
                  ;}
                  
                  ;{ select
                Case #Menu_SelectAll 
                  ;sel = (EventMenu-#Menu_DeSelect)
                  Edit_Select(1)
                  
                Case #Menu_DeSelect
                  Edit_Select(0)
                  
                Case #Menu_SelectAlphaLayer
                  Layer_SelectAlpha()
                  ;}
                  
                  ;{ image
                Case #Menu_ResizeDoc
                  ResizeDoc(0)
                  
                Case #Menu_ResizeCAnvas
                  ResizeDoc(1)
                  
                Case #menu_InverseColor
                  IE_InvertColor(layer(layerId)\Image)
                  
                Case #menu_Desaturation
                  IE_Desaturation(layer(layerId)\Image)
                  
                Case #menu_Posterize
                  IE_WinPosterize()
                  
                Case #menu_Constrast
                  IE_WinContrast()
                  
                Case #menu_Level
                  IE_WinLevel()
                  
                Case #menu_ColorBalance
                  IE_WinBalCol()
                  
                Case #menu_Rotate90
                  RotateImage_Menu() 
                  
                Case #menu_Rotate180
                  RotateImage_Menu(1)
                  
                Case #menu_Rotate270
                  RotateImage_Menu(2)
                  
                Case #menu_Rotatefree
                  RotateImage_Menu(3)
                  
                Case #menu_Trim
                  TrimDoc(layer(layerid)\Image,1)
                  
                Case #menu_Crop
                  CropDoc()
                  
                  
                  ;}
                  
                  ;{ view
                Case #menu_IE_Grid
                  OptionsIE\Grid = 1-OptionsIE\Grid
                  SetMenuItemState(0,#menu_IE_Grid,OptionsIE\Grid)
                  ScreenUpdate()
                  
                Case #menu_ScreenQuality
                  OptionsIE\SpriteQuality = 1-OptionsIE\SpriteQuality
                  SpriteQuality(OptionsIE\SpriteQuality)
                  ScreenUpdate()
                  
                Case #menu_IE_ZoomPlus            
                  If OptionsIE\Zoom <= 200
                    OptionsIE\Zoom +10
                    ScreenZoom()
                  ElseIf OptionsIE\Zoom < 1000 And OptionsIE\Zoom > 200
                    OptionsIE\Zoom +100
                    ScreenZoom()
                  EndIf
                  
                Case #menu_IE_ZoomMoins
                  If OptionsIE\Zoom > 10
                    If OptionsIE\Zoom > 200
                      OptionsIE\Zoom -100
                      ScreenZoom()
                    Else
                      OptionsIE\Zoom -10
                      ScreenZoom()
                    EndIf              
                  EndIf
                  
                  ;               Case #menu_IE_Zoom10   
                  ;                 OptionsIE\Zoom = 10
                  ;                 ScreenZoom()   
                  
                Case #menu_IE_Zoom50   
                  OptionsIE\Zoom = 50
                  ScreenZoom()   
                  
                Case #menu_IE_Zoom100   
                  OptionsIE\Zoom = 100
                  ScreenZoom()  
                  
                Case #menu_IE_Zoom200
                  OptionsIE\Zoom = 200
                  ScreenZoom()
                  
                Case #menu_IE_Zoom300   
                  OptionsIE\Zoom = 300
                  ScreenZoom() 
                  
                Case #menu_IE_Zoom400             
                  OptionsIE\Zoom = 400
                  ScreenZoom() 
                  
                Case #menu_IE_Zoom1000 
                  OptionsIE\Zoom = 1000
                  ScreenZoom() 
                  
                Case #menu_IE_Zoom500   
                  OptionsIE\Zoom = 500
                  ScreenZoom() 
                  
                Case #Menu_ResetCenter
                  canvasX =0
                  canvasY = 0
                  ScreenUpdate()
                  
                Case #Menu_CenterView
                  CanvasX = ScreenWidth()/2 - (doc\w*z)/2
                  CanvasY = ScreenHeight()/2 - (doc\h*z)/2                
                  ScreenUpdate()
                  
                Case #menu_ScreenRedraw
                  W = WindowWidth(#WinMain) - ScreenX*2 ; -10
                  H = WindowHeight(#WinMain) - 150
                  ScreenResize(w,h)  
                  
                  ;}
                  
                  ;{ Layer 
                Case #Menu_LayerDuplicate
                  OldLayerId = LayerId
                  Layer_Add()
                  If  StartDrawing(ImageOutput(layer(LayerId)\image))
                    DrawingMode(#PB_2DDrawing_AlphaBlend)
                    ; Box(0,0,canvasW,canvasH,RGBA(0,0,0,0))
                    DrawAlphaImage(ImageID(Layer(OldLayerId)\image),0,0)
                    StopDrawing()
                  EndIf
                  If  StartDrawing(SpriteOutput(layer(LayerId)\Sprite))
                    DrawingMode(#PB_2DDrawing_AlphaBlend)
                    ; Box(0,0,canvasW,canvasH,RGBA(0,0,0,0))
                    DrawAlphaImage(ImageID(Layer(LayerId)\image),0,0)
                    StopDrawing()
                  EndIf
                  NewPainting = 1
                  ScreenUpdate()
                  
                Case #Menu_LayerMoveDown
                  Layer_ChangePos(-1)
                  
                Case #Menu_LayerMoveUp
                  Layer_ChangePos()
                  
                Case #Menu_LayerAdd
                  Layer_Add()
                  
                Case #Menu_LayerDel
                  If ArraySize(layer()) >= 1
                    Layer_Delete()
                  Else
                    MessageRequester(lang("Infos"), lang("You can't delete a unique layer. You need at least 2 layers to delete 1 layer."))
                  EndIf
                  
                Case #Menu_LayerMergeDown
                  If LayerId >= 0
                    Layer_Merge()
                  EndIf
                  
                Case #Menu_LayerMergeAllVisible
                  Layer_Merge(2)
                  
                Case #Menu_LayerMergeAll
                  Layer_Merge(1)
                  
                Case #Menu_LayerMergeLinked
                  Layer_Merge(3)
                  
                Case #Menu_LayerRotate
                  angle = Val(InputRequester(Lang("Define angle"),Lang("Define angle"),""))
                  If angle <> 0                
                    Layer_Rotate(LayerId,angle)
                    Newpainting = 1
                    ScreenUpdate(1)
                  EndIf
                  
                Case #Menu_LayerTransformToLine
                  Layer_TransformToLine()
                  
                Case #Menu_BackgroundEditor
                  WindowBackgroundEditor()
                    
                Case #Menu_LayerAddBackgroundOnAlpha  
                  Layer_AddBGToalpha()
                  
                Case #Menu_LayerEraseAlpha  
                  Layer_EraseAlpha()
                  
                Case #Menu_LayerApplyAlpha
                  Layer_ApplyAlpha()
                  Edit_Select(0)
                  ;}
                  
                  ;{ Filters
                Case #menu_IE_sharpen
                  ImgFilterSharpen()
                  
                Case #menu_IE_sharpenAlpha
                  ImgFilterSharpenAlpha()
                  
                  
                  ;Case #menu_IE_Offset
                  
                Case #menu_IE_Noise
                  ImgFilterNoise()
                  
                Case #Menu_IE_Blur                
                  ImgFilterBlur()  
                  
                  ;}
                  
                  ;{ scripts
                Case #Menu_ActionSave
                  OptionsIE\DoScript = 1
                  
                Case #Menu_ActionRun
                  OptionsIE\DoScript = 5
                  ScriptNumber = Val(InputRequester("Script","","0"))
                  Debug ScriptNumber
                  ; RunScript(sc) ; test
                  
                Case #Menu_ActionStop
                  StopScript()
                  
                  ;}
                  
                  ;{ window
                Case #Menu_SHowHideAllUI
                  OptionsIE\ShowFullUI = 1- OptionsIE\ShowFullUI 
                  UpdateUIShowHide(1)
                  
                Case #menu_ShowColor
                  OptionsIE\ShowPanelColors = 1- OptionsIE\ShowPanelColors 
                  UpdateUIShowHide()
                  
                  ;               Case #menu_Showgradient
                  ;                 OptionsIE\ShowPanelLayers = 1- OptionsIE\ShowPanelLayers 
                  ;                 HideGadget(#G_PanelCol, OptionsIE\ShowPanelLayers)
                  ;                 SetMenuItemState(#Menu_Main, #menu_Showgradient, OptionsIE\ShowPanelLayers)
                  
                Case #menu_ShowLayers
                  OptionsIE\ShowPanelLayers = 1- OptionsIE\ShowPanelLayers 
                  UpdateUIShowHide()
                  
                Case #menu_ShowToolParameters
                  OptionsIE\ShowPanelToolparameters = 1- OptionsIE\ShowPanelToolparameters 
                  UpdateUIShowHide()
                  
                Case #menu_ShowSwatchs
                  OptionsIE\ShowPanelswatchs = 1- OptionsIE\ShowPanelswatchs 
                  UpdateUIShowHide()
                  
                Case #menu_brusheditor
                  WindowBrushEditor()
                  
                Case #menu_BrushImageWindow
                  OpenWindowBrush()
                  ;}
                  
                  ;{ Help
                Case #menu_about 
                  MessageRequester(Lang("About"),#ProgramName+" "+#ProgramVersion+" (Revision "+#ProgramRevision+")"+
                                                 Chr(13)+Lang("Made in")+" Purebasic "+Lang("by")+" Blendman"+Chr(13)+Lang("Date")+" : "+FormatDate("%dd/%mm/%yyyy", #ProgramDate)+
                                                 Chr(13)+Lang("Thanks to :")+" Fred (purebasic power !) & PB team (Freaks), Danilo, LSI, Dobro, G-Rom, Onilink, KwanJeen, Kernadec, Falsam, Netmaestro, "+
                                                 "Infratec, ApplePy, Idle, Willburt, StarGate, Rashad And all the guys at the PB forums (English & French).")
                  
                Case #Menu_Infos
                  WindowAbout()
                  
                  ;}
                  
                  ;}
                  
                  ;{-- Menu popup layer
                Case #Menu_Layer_Normal
                  OptionsIE\LayerTyp = #Layer_TypBitmap
                  Layer_Add()
                  
                Case #Menu_Layer_Text
                  OptionsIE\LayerTyp = #Layer_TypText
                  Layer_Add()
                  
                Case #Menu_Layer_BG
                  OptionsIE\LayerTyp = #Layer_TypBG
                  Layer_Add()
                  ;}
                  
                Default
                  MessageRequester(Lang("Info"), Lang("Not implemented"))
                  
              EndSelect
              
            Else
              ;{ plugins menu
              ;             ForEach Ani_Plugins()
              ;               
              ;               If EventMenu = #Menu_Last + Ani_Plugins()\menuId
              ;                 If Ani_Plugins()\lib <> 0; OpenLibrary(0, "PureBasic.dll")                  
              ;                   layimg = Layer(layerid)\Image
              ;                   *img = imageToArray(layimg, ImageWidth(layimg)-1,ImageHeight(layimg)-1)
              ;                   CallFunction(Ani_Plugins()\lib, "DoFilter",@img)
              ;                   ArrayToImage(layimg, *img,ImageWidth(layimg),ImageHeight(layimg))
              ;                   FreeMemory(*img)
              ;                   
              ;                   ;CloseLibrary(0)
              ;                 EndIf
              ;                 Break
              ;               EndIf 
              ;               
              ;             Next
              ;}            
              
            EndIf
            
            ;}
            
          Case #PB_Event_Gadget
            Select EventWindow
                
              Case #WinMain              
                ;{ win main
                
                If EventGadget <> #G_CanvasMain And EventGadget <> #G_SA_forcanvas
                  Gad = 1
                EndIf
                
                If EventType = #PB_EventType_LeftButtonUp
                  MoveCanvas = 0
                  paint = 0
                  mouseclic = 0
                EndIf
                
                If EventGadget>=#G_IE_Pen And eventgadget<=#G_IE_Zoom ; the toolbar butons
                  
                  UpdateTool(EventGadget)
                  MoveLayerY = 0
                  MoveLayerX = 0
                  ActionKeyb = 0
                  If Action = #Action_Hand
                    MoveCanvas = 1
                  Else
                    MoveCanvas = 0
                    If action = #Action_CloneStamp
                      SetStampPatternImage(-1,-1)
                    EndIf
                  EndIf
                  
                ElseIf EventGadget > #G_LastGadget
                  ;{                  
                  ;                   ; Click on the layer gadget // on clique sur le layer gadget
                  ;                   For i =0 To ArraySize(layer())
                  ;                     
                  ;                     If EventGadget = layer(i)\IG_LayerMenu
                  ;                       
                  ;                       lx = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
                  ;                       ly = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
                  ;                       
                  ;                       If EventType = #PB_EventType_LeftButtonDown
                  ;                         
                  ;                         
                  ;                         
                  ;                         If Lx < 20; view
                  ;                           Layer(i)\View = 1 - Layer(i)\View
                  ;                           Layer_updateUi(i)
                  ;                           ScreenUpdate() 
                  ;                         Else
                  ;                           Id = i ; GetGadgetState(#G_LayerList) 
                  ;                           If layerID <> id
                  ;                             If OldAction <> Action
                  ;                               Layer_ValidChange(Action)  
                  ;                               OldAction = Action
                  ;                             EndIf                
                  ;                             UpdateGadgetLayer(id)
                  ;                             ScreenUpdate()            
                  ;                             LayerId= id
                  ;                             IE_UpdateLayerUi() 
                  ;                             
                  ;                           EndIf
                  ;                           
                  ;                           If Lx >= 20 And lx < 45; drawing on the layer
                  ;                             If Layer(layerId)\MaskAlpha =2
                  ;                               Layer(layerId)\MaskAlpha = 1
                  ;                               Layer_updateUi(layerId)
                  ;                             EndIf
                  ;                             If Control
                  ;                               Layer_SelectAlpha()
                  ;                             EndIf
                  ;                           ElseIf Lx > 45 And lx < 64; drawing on the alpha mask
                  ;                             If Control = 0
                  ;                               If Layer(layerId)\MaskAlpha >=1
                  ;                                 Layer(layerId)\MaskAlpha = 2
                  ;                                 Layer_updateUi(layerId)                          
                  ;                               EndIf  
                  ;                             Else
                  ;                               Layer(layerId)\MaskAlpha = 3 ; on ne l'affiche pas
                  ;                               Layer_updateUi(layerId)  
                  ;                             EndIf
                  ;                             NewPainting = 1
                  ;                             ScreenUpdate() 
                  ;                           Else
                  ;                             ; WindowLayerProp()
                  ;                           EndIf
                  ;                         EndIf
                  ;                         
                  ;                         
                  ;                       ElseIf EventType = #PB_EventType_LeftDoubleClick
                  ;                         If Lx > 45 And Lx <= 80
                  ;                           ; 
                  ;                           nom$ = InputRequester("Name","New Name","")
                  ;                           If nom$ <> ""
                  ;                             layer(layerid)\name$ = nom$
                  ;                             SetGadgetItemText(#G_LayerList,id,nom$)
                  ;                             Layer_updateUi(layerId)
                  ;                           EndIf
                  ;                         ElseIf Lx > 80 ; layer properties
                  ;                           WindowLayerProp()
                  ;                         EndIf
                  ;                         
                  ;                       EndIf
                  ;                       Break
                  ;                     EndIf
                  ;                     
                  ;                   Next i
                  ;}                  
                Else ; the others gadgets
                  
                  Select eventgadget
                      
                      ;{----- Gadget windows main
                      
                      ;{-- Layer
                      
                      ;{ select, Bm & alpha
;                     Case #G_layerbm1, #G_layerbm2
;                       blend1 = GetGadgetState(#G_layerbm1)
;                       blend2 = GetGadgetState(#G_layerbm2)
;                       Layer_SetBm(GetGadgetState(#G_LayerBM))
;                       newpainting = 1
;                       ScreenUpdate(1) 
                      
                    Case #G_LayerListcanvas
                      Layer_GetLayerId()
                      ;{
                      ;                     If OldAction <> Action
                      ;                       Layer_ValidChange(Action)  
                      ;                       OldAction = Action
                      ;                     EndIf                
                      ;                     Id = GetGadgetState(#G_LayerList) 
                      ;                     UpdateGadgetLayer(id)
                      ;                     ScreenUpdate()            
                      ;                     LayerId= id
                      ;                     If EventType = #PB_EventType_LeftDoubleClick
                      ;                     nom$ = InputRequester("Name","New Name","")
                      ;                     If nom$ <> ""
                      ;                       layer(layerid)\name$ = nom$
                      ;                       SetGadgetItemText(#G_LayerList,id,nom$)
                      ;                     EndIf
                      ;                   EndIf
                      ;}
                      
                    Case #G_LayerBM ; blendmode of the layer
                      oldbm = layer(layerid)\bm
                      Layer_SetBm(layerId, GetGadgetState(#G_LayerBM))
                      newpainting = 1
                      CanvasHasChanged = 1
                      ScreenUpdate(1)
                      testlayer(LayerId)
                      
                    Case #G_LayerAlpha, #G_LayerAlphaSpin
                      Layer(LayerId)\alpha = GetGadgetState(eventgadget)
                      SetGadgetState(#G_LayerAlphaSpin,Layer(LayerId)\alpha)
                      SetGadgetState(#G_LayerAlpha,Layer(LayerId)\alpha)
                      If layer(layerId)\bm <> #Bm_Normal
                        NewPainting = 1
                      EndIf                
                      CanvasHasChanged = 1
                      ScreenUpdate()
                  
                      ;}
                      
                      ;{ lock  & view
                    Case #G_LayerView
                      Layer(LayerId)\view = GetGadgetState(#G_LayerView)
                      ScreenUpdate()
                      Layer_updateUi(layerId)
                      
                    Case #G_LayerLocked
                      Layer(LayerId)\locked = GetGadgetState(#G_LayerLocked)
                      Layer_updateUi(layerId)
                      
                    Case #G_LayerLockAlpha 
                      Layer(LayerId)\LockAlpha = GetGadgetState(#G_LayerLockAlpha)
                      
                    Case #G_LayerLockMove
                      Layer(LayerId)\LockMove = GetGadgetState(#G_LayerLockMove)
                      
                    Case #G_LayerLockPaint
                      Layer(LayerId)\LockPaint = GetGadgetState(#G_LayerLockPaint)
                      ;}
                      
                      ;{ Buttons for layer // boutons des layers
                    Case #G_LayerAdd
                      If OldAction <> Action
                        Layer_ValidChange(Action)  
                        OldAction = Action
                      EndIf  
                      If NewPainting
                        ; Layer_SetSpriteToImage()
                        ScreenUpdate()
                      EndIf 
                      xlm = GadgetX(#G_SplitLayerRB)+GadgetX(#G_LayerAdd)
                      ylm = GadgetY(#G_SplitLayerRB)+GadgetY(#G_LayerAdd)
                      DisplayPopupMenu(#Menu_Layer,WindowID(#WinMain),xlm,ylm)
                      
                    Case #G_LayerDel
                      If ArraySize(layer()) >= 1
                        Layer_Delete()
                      EndIf
                      
                    Case #G_LayerMoveup
                      Layer_ChangePos()
                      
                    Case #G_LayerMovedown
                      Layer_ChangePos(-1)
                      
                    Case #G_LayerMaskAlpha
                      Layer(LayerId)\MaskAlpha = 1
                      IE_UpdateLayerUi() 
                      
                    Case #G_LayerProp
                      WindowLayerProp()
                      
                      
                      ;}
                      
                      ;}
                      
                      ;{-- Tool parameters
                      
                      ;{ brush , eraser, pen
                      ; General : quick gadgets
                    Case #G_BrushSizeTB, #G_BrushSizeSG
                      If eventgadget = #G_BrushSizeTB
                        Brush(Action)\size = GetGadgetState(#G_BrushSizeTB)
                        SetGadgetText(#G_BrushSizeSG, Str(Brush(Action)\size))
                      Else
                        Brush(Action)\size = Val(GetGadgetText(#G_BrushSizeSG))
                        SetGadgetState(#G_BrushSizeTB, Brush(Action)\size)
                      EndIf
                      BrushUpdateImage(0,1)
                      BrushUpdateColor() 
                      SetGadgetState(#G_BrushSize, Brush(Action)\size)
                      
                    Case #G_BrushHardnessTB, #G_BrushHardnessSG
                      If eventgadget = #G_BrushHardnessTB
                        Brush(Action)\Hardness = GetGadgetState(#G_BrushHardnessTB)
                        SetGadgetText(#G_BrushHardnessSG, Str(Brush(Action)\Hardness))
                      Else
                        Brush(Action)\Hardness = Val(GetGadgetText(#G_BrushHardnessSG))
                        SetGadgetState(#G_BrushHardnessTB, Brush(Action)\Hardness)
                      EndIf
                      BrushUpdateImage(0,1)
                      BrushUpdateColor() 
                      SetGadgetState(#G_brushHardness, Brush(Action)\Hardness)
                      
                    Case #G_BrushAlphaTB, #G_BrushAlphaSG
                      If eventgadget = #G_BrushAlphaTB
                        Brush(Action)\Alpha = GetGadgetState(#G_BrushAlphaTB)
                        SetGadgetText(#G_BrushAlphaSG, Str(Brush(Action)\Alpha))
                      Else
                        Brush(Action)\Alpha = Val(GetGadgetText(#G_BrushAlphaSG))
                        SetGadgetState(#G_BrushAlphaTB, Brush(Action)\Alpha)
                      EndIf
                      SetGadgetState(#G_BrushAlpha, Brush(Action)\Alpha)
                      color = RGBA(Brush(Action)\col\R,Brush(Action)\col\G,Brush(Action)\col\B,Brush(Action)\alpha)
                      
                    Case #G_BrushMixTB, #G_BrushMixSG
                      If eventgadget = #G_BrushMixTB
                        Brush(Action)\mix = GetGadgetState(#G_BrushMixTB)
                        SetGadgetText(#G_BrushMixSG, Str(Brush(Action)\Mix))
                      Else
                        Brush(Action)\mix = Val(GetGadgetText(#G_BrushMixSG))
                        SetGadgetState(#G_BrushMixTB, Brush(Action)\mix)
                      EndIf
                      SetGadgetState(#G_BrushMix, Brush(Action)\mix)
                      If Brush(Action)\mix = 0
                        If Brush(Action)\Wash = 1
                          BrushUpdateImage(0,1)
                          BrushUpdateColor() 
                        EndIf
                      EndIf
                       
                      ; size 
                    Case #G_BrushPreview
                      If EventType = #PB_EventType_LeftClick 
                        OpenWindowBrush()
                      EndIf
                    
                    Case #G_BrushSizePressure
                      Brush(Action)\Sizepressure = GetGadgetState(#G_BrushSizePressure)
                      ; base
                    Case #G_BrushSize, #G_BrushSizeW, #G_BrushSizeH 
                      Brush(Action)\size = GetGadgetState(#G_BrushSize)
                      SetGadgetState(#G_BrushSizeTB, Brush(Action)\size)
                      If Brush(Action)\SizeMin> Brush(Action)\Size
                        SetGadgetState(#G_BrushSizeMin,Brush(Action)\size)
                        Brush(Action)\sizemin = Brush(Action)\size
                      EndIf
                      Brush(Action)\sizeW = GetGadgetState(#G_BrushSizeW)
                      Brush(Action)\sizeH = GetGadgetState(#G_BrushSizeH)
                      BrushUpdateImage(0,1)
                      BrushUpdateColor()   
                      
                    Case #G_BrushSizeMin
                      Brush(Action)\SizeMin = GetGadgetState(#G_BrushSizeMin)
                      If Brush(Action)\SizeMin> Brush(Action)\Size
                        SetGadgetState(#G_BrushSizeMin,Brush(Action)\size)
                        Brush(Action)\sizemin = Brush(Action)\size
                      EndIf
                      
                    Case #G_BrushSizeRand 
                      Brush(Action)\SizeRand = GetGadgetState(#G_BrushSizeRand)
                      
                      
                      ; param  
                    Case #G_IE_Type
                      If action <> #Action_CloneStamp
                        Brush(Action)\Type = GetGadgetState(#G_IE_Type)
                      EndIf
                      
                    Case #G_brushSmooth
                      Brush(Action)\Smooth = GetGadgetState(#G_brushSmooth)
                      BrushUpdateImage(0,1)
                      BrushUpdateColor() 
                      
                    Case #G_brushHardness, #G_brushIntensity, #G_brushSoftness
                      Brush(Action)\Hardness = GetGadgetState(#G_brushHardness)
                      Brush(Action)\Intensity = GetGadgetState(#G_brushIntensity)
                      Brush(Action)\Softness = GetGadgetState(#G_brushSoftness)
                      SetGadgetText(#G_BrushHardnessSG, Str(Brush(Action)\Hardness))
                      SetGadgetState(#G_BrushHardnessTB, Brush(Action)\Hardness)
                      BrushUpdateImage(0,1)
                      BrushUpdateColor() 
                      
                    Case #G_BrushIntensityTB, #G_BrushIntensitySG
                      If eventgadget = #G_BrushIntensityTB
                        Brush(Action)\Intensity = GetGadgetState(#G_BrushIntensityTB)
                        SetGadgetText(#G_BrushIntensitySG, Str(Brush(Action)\Intensity))
                      Else
                        Brush(Action)\Intensity = Val(GetGadgetText(#G_BrushIntensitySG))
                        SetGadgetState(#G_BrushIntensityTB, Brush(Action)\Intensity)
                      EndIf
                      BrushUpdateImage(0,1)
                      BrushUpdateColor() 
                      SetGadgetState(#G_brushIntensity, Brush(Action)\Intensity)  
                      
                    Case #G_BrushPas                
                      Brush(Action)\pas = GetGadgetState(#G_BrushPas)
                      
                    Case #G_BrushTrim  
                      Brush(action)\Trim = GetGadgetState(#G_BrushTrim)
                      BrushUpdateImage(1,1)
                      BrushUpdateColor()  
                      
                    Case #G_brushTrait               
                      Brush(Action)\Trait = GetGadgetState(#G_brushTrait)
                      
                    Case #G_BrushSymetry                
                      Brush(Action)\symetry = GetGadgetState(#G_BrushSymetry)
                      
                    Case #G_BrushFilter                  
                      Brush(Action)\Filter = GetGadgetState(#G_BrushFilter)
                      
                    Case #G_BrushStroke
                      Brush(Action)\Stroke = GetGadgetState(#G_BrushStroke) 
                      ; Debug Brush(Action)\Stroke
                      
                    Case #G_BrushStrokeTyp
                      Brush(Action)\StrokeTyp = GetGadgetState(#G_BrushStrokeTyp)
                      
                      
                      ; alpha  
                    Case #G_BrushAlphaRand
                      Brush(Action)\AlphaRand = GetGadgetState(#G_BrushAlphaRand)
                      
                    Case #G_BrushAlphaMin
                      Brush(Action)\AlphaMin = GetGadgetState(#G_BrushAlphaMin)
                      
                    Case #G_BrushAlphaPressure
                      Brush(Action)\AlphaPressure = GetGadgetState(#G_BrushAlphaPressure)
                      
                    Case #G_BrushAlpha
                      Brush(Action)\alpha = GetGadgetState(#G_BrushAlpha)
                      Brush(Action)\alphaMax = Brush(Action)\Alpha
                      color = RGBA(Brush(Action)\col\R,Brush(Action)\col\G,Brush(Action)\col\B,Brush(Action)\alpha)
                      
                      
                      ; dynamic                
                    Case #G_BrushScatter
                      Brush(Action)\scatter = GetGadgetState(#G_BrushScatter)
                      
                    Case #G_BrushRandRotate
                      Brush(Action)\randRot = GetGadgetState(#G_BrushRandRotate)
                      
                    Case #G_BrushRotate
                      Brush(Action)\rotate = GetGadgetState(#G_BrushRotate)
                      BrushUpdateImage(0,1)
                      BrushUpdateColor() 
                      
                    Case #G_BrushRotateAngle  
                      Brush(Action)\RotatebyAngle = GetGadgetState(#G_BrushRotateAngle)
                      
                      ; color                
                      ; Case #G_BrushMixLayerCustom
                      
                    Case #G_BrushMixLayer
                      Brush(Action)\MixLayer = GetGadgetState(#G_BrushMixLayer)
                      
                    Case #G_BrushMixTyp
                      Brush(Action)\MixType = GetGadgetState(#G_BrushMixTyp)
                      
                    Case #G_BrushMix
                      Brush(Action)\mix = GetGadgetState(#G_BrushMix)
                      If Brush(Action)\mix = 0
                        If Brush(Action)\Wash = 1
                          BrushUpdateImage(0,1)
                          BrushUpdateColor() 
                        EndIf
                      EndIf
                      
                    Case #G_BrushVisco
                      Brush(Action)\Visco = GetGadgetState(#G_BrushVisco)
                      
                    Case #G_BrushLavage
                      Brush(Action)\Wash = GetGadgetState(#G_BrushLavage)
                      
                    Case #G_BrushBlendmode
                      bm = GetGadgetState(#G_BrushBlendmode)
                      Select bm
                        Case 0
                          brush(action)\blendmode = #Bm_Normal
                        Case 1 ; dissolve
                          brush(action)\blendmode = #Bm_Dissolve
                      EndSelect
                      
                    Case #G_BrushWater
                      Brush(Action)\Water = GetGadgetState(#G_BrushWater)
                      
                    Case #G_BrushStampUseColor, #G_BrushStampColorBM
                      Brush(action)\usecolor = GetGadgetState(#G_BrushStampUseColor)
                      SetStampPatternImage(-1,-1)
                      ;}
                      
                      ;{ Move, rotate, transform & line, fillarea for some parameters
                      
                    Case #G_ActionXLock, #G_ActionYLock
                      OptionsIE\lockX = GetGadgetState(#G_ActionXLock)
                      If IsGadget( OptionsIE\lockY)
                        OptionsIE\lockY = GetGadgetState(#G_ActionYLock)
                      Else
                        OptionsIE\lockY = OptionsIE\lockX
                      EndIf
                      
                      
                    Case #G_ShapeParam1  
                      brush(action)\AlphaFG = GetGadgetState(#G_ShapeParam1)
                      
                    Case #G_ActionX, #G_ActionY ; I use the gadget #G_actionX and #G_actionY for some actions depending of the selected tool.
                      If action = #Action_Move
                        If layer(layerId)\LockMove = 0 And layer(layerid)\View = 1
                          Layer(LayerId)\x = GetGadgetState(#G_ActionX)                      
                          Layer(LayerId)\y = GetGadgetState(#G_ActionY)
                          ScreenUpdate()
                        EndIf
                      ElseIf action = #Action_Fill
                        brush(action)\Alpha = GetGadgetState(#G_ActionY)
                        If IsGadget(#G_ActionX)
                          ; tolerance, not used for the moment
                          brush(action)\Size  = GetGadgetState(#G_ActionX)
                        EndIf
                        
                      ElseIf action = #Action_Transform
                        If layer(layerId)\Locked = 0 And layer(layerid)\View = 1
                          Layer(LayerId)\w = GetGadgetState(#G_ActionX)                      
                          Layer(LayerId)\h = GetGadgetState(#G_ActionY)
                          ScreenUpdate()
                        EndIf
                      ElseIf action = #Action_Rotate 
                        If layer(layerId)\Locked = 0 And layer(layerId)\View = 1
                          Layer(LayerId)\Angle = GetGadgetState(#G_ActionX)
                          RotateSprite(Layer(layerId)\Sprite,Layer(LayerId)\Angle ,0)
                          ScreenUpdate()
                        EndIf
                      ElseIf action = #Action_Line Or action = #Action_Box
                        brush(action)\Alpha = GetGadgetState(#G_ActionY)
                        brush(action)\Size  = GetGadgetState(#G_ActionX)
                      ElseIf action = #Action_Select
                        
                      ElseIf action = #Action_Gradient
                        brush(action)\Alpha   = GetGadgetState(#G_ActionX)
                        brush(action)\AlphaFG = GetGadgetState(#G_ActionY)
                      EndIf                  
                      
                    Case #G_ActionFullLayer
                      OptionsIE\ActionForAllLayers = GetGadgetState(#G_ActionFullLayer)
                      OptionsIE\ShapeFullLayer = GetGadgetState(#G_ActionFullLayer)
                      
                    Case #G_ConfirmAction
                      OptionsIE\ConfirmAction = GetGadgetState(#G_ConfirmAction)
                      
                      ;}
                      
                      ;{ Box, ellipse, line, gradient
                      ; see before to see other parameters (alpha, size..° // voir aussi au-dessus pour d'autres paramètres ! (alpha et size notamment)
                    Case #G_ActionTyp
                      If action  = #Action_Pipette Or action =#Action_Zoom
                        brush(action)\type = GetGadgetState(#G_ActionTyp)
                      ElseIf action = #Action_Select
                        OptionsIE\SelectionType = GetGadgetState(#G_ActionTyp)
                        brush(action)\type = GetGadgetState(#G_ActionTyp)
                      Else
                        OptionsIE\ShapeTyp = GetGadgetState(#G_ActionTyp)
                      EndIf
                   
                    Case #G_ActionW, #G_ActionH
                      If action = #Action_Circle Or action = #Action_Box ; outlined
                        Brush(action)\ShapeOutSize = GetGadgetState(#G_ActionH)
                      EndIf
                      
                      ;}
                      
                      
                      
                      ;}
                      
                      ;{-- roughboard
                    Case #G_RBNew
                      If StartDrawing(CanvasOutput(#G_RoughtBoard))
                        w = ImageWidth(#image_RB)
                        h = ImageHeight(#image_RB)
                        Box(0,0,w,h,RGB(255,255,255))                      
                        StopDrawing()
                      EndIf
                      OptionsIE\RB_Img$ = ""
                      
                    Case #G_RBPaint                
                      OptionsIE\RB_Action = 1- OptionsIE\RB_Action 
                      If OptionsIE\RB_Action = 1
                        SetGadgetAttribute(#G_RBPaint,#PB_Button_Image,ImageID(#ico_IE_Pen))
                      Else
                        SetGadgetAttribute(#G_RBPaint,#PB_Button_Image,ImageID(#ico_IE_Pipette))
                      EndIf
                      
                    Case #G_RBOpen
                      file$ = OpenFileRequester("Open Roughboard Image","","Image|*.png;*.jpg;*.bmp",0)
                      If file$ <> ""
                        If LoadImage(#image_RB,file$)
                          OptionsIE\RB_Img$ = File$
                          w = ImageWidth(#image_RB)
                          h = ImageHeight(#image_RB)
                          ResizeGadget(#G_RoughtBoard,#PB_Ignore,#PB_Ignore,w,h)
                          SetGadgetAttribute(#G_SA_Rb,  #PB_ScrollArea_InnerWidth ,w)
                          SetGadgetAttribute(#G_SA_Rb,  #PB_ScrollArea_InnerHeight ,h)
                          If StartDrawing(CanvasOutput(#G_RoughtBoard))
                            DrawImage(ImageID(#image_RB),0,0)
                            StopDrawing()
                          EndIf
                        EndIf
                      EndIf
                      
                    Case #G_RBSave
                      If OptionsIE\RB_Img$ <> ""
                        Format = SelectFormat(OptionsIE\RB_Img$)                
                        If SaveImage(#image_RB, OptionsIE\RB_Img$,format) : EndIf
                      Else
                        RBExport()
                      EndIf
                      
                    Case #G_RBExport
                      RBExport()
                      
                    Case #G_RoughtBoard
                      If EventType = #PB_EventType_LeftButtonDown Or 
                         (EventType= #PB_EventType_MouseMove And 
                          GetGadgetAttribute(#G_RoughtBoard, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton )
                        If OptionsIE\RB_Action = 0 ; on pick la couleur
                          If StartDrawing(CanvasOutput(#G_RoughtBoard))
                            rbx = GetGadgetAttribute(#G_RoughtBoard, #PB_Canvas_MouseX)
                            rby = GetGadgetAttribute(#G_RoughtBoard, #PB_Canvas_MouseY)                    
                            Brush(Action)\color = Point(rbx,rby)
                            StopDrawing()
                          EndIf  
                          BrushResetColor()
                          BrushUpdateColor()
                          Brush(Action)\ColorBG\R = Red(Brush(Action)\color)
                          Brush(Action)\ColorBG\G = Green(Brush(Action)\color)
                          Brush(Action)\ColorBG\B = Blue(Brush(Action)\color)
                          color = RGBA(Brush(Action)\col\R,Brush(Action)\col\G,Brush(Action)\col\B,Brush(Action)\alpha)
                        Else
                          If StartDrawing(CanvasOutput(#G_RoughtBoard))
                            rbx = GetGadgetAttribute(#G_RoughtBoard, #PB_Canvas_MouseX)
                            rby = GetGadgetAttribute(#G_RoughtBoard, #PB_Canvas_MouseY)                    
                            Circle(rbx,rby,3,Brush(Action)\color)
                            StopDrawing()
                          EndIf                    
                        EndIf
                        
                      ElseIf EventType = #PB_EventType_LeftButtonUp
                        If StartDrawing(ImageOutput(#image_RB))
                          DrawImage(GetGadgetAttribute(#G_RoughtBoard, #PB_Canvas_Image), 0, 0)
                          StopDrawing()
                        EndIf
                      EndIf
                      
                      ;}
                      
                      ;{-- swatch
                    Case #G_SwatchCanvas
                      SwatchEvent(EventType())
                      
                    Case #G_SwatchNew
                      SwatchOpen(3)
                      
                    Case #G_SwatchMerge
                      SwatchOpen(2)
                      
                    Case #G_SwatchOpen
                      SwatchOpen(1)
                      
                    Case #G_SwatchSave
                      SwatchSave()
                      
                    Case #G_SwatchExport
                      SwatchSave(1)
                      
                    Case #G_SwatchEdit
                      SwatchEditProp()
                      
                      ;}
                                            
                      ;{-- patterns
                      
                    Case #G_PatternCanvas
                      If eventtype = #PB_EventType_LeftButtonDown 
                        pos_x = GetGadgetAttribute(#G_PatternCanvas, #PB_Canvas_MouseX) 
                        pos_y = GetGadgetAttribute(#G_PatternCanvas, #PB_Canvas_MouseY) 
                        SetStampPatternImage(pos_x, pos_y)
                      EndIf
                      
                      ;}
                      
                      ;{-- preset
                    Case #G_PresetChangeBank
                      nom$ = PathRequester("Open a Bank folder", GetCurrentDirectory()+OptionsIE\DirPreset$ )
                      If nom$ <> ""
                        OptionsIE\DirPreset$ = nom$
                        OpenPresetBank()
                      EndIf
                      
                    Case #G_PresetReloadBank
                      OpenPresetBank()
                      
                    Case #G_PresetSavePresetAs
                      SaveBrushPreset()
                      
                    Case #G_PresetSavePreset
                      file$ = GetParentItemText(#G_PresetTG) 
                      SaveBrushPreset(1, file$)
                      
                    Case #G_PresetTG 
                      brush$ = GetGadgetText(#G_PresetTG)
                      file$ = GetParentItemText(#G_PresetTG)
                      OpenPreset(file$,brush$)
                      ;}
                      
                      ;{-- paper
                    Case #G_ListPaper                
                      OptionsIE\Paper$ = GetGadgetItemText(#G_ListPaper,GetGadgetState(#G_ListPaper))
                      PaperUpdate(1)
                      ScreenUpdate(0)
                      
                    Case #G_PaperScaleSG
                      Val = Val(GetGadgetText(#G_PaperScaleSG))
                      If val > 1 And val <200
                        SetGadgetState(#G_PaperScale, val)
                        paper\scale = val
                        PaperUpdate()
                        ScreenUpdate(0)
                      EndIf
                      
                      
                    Case #G_PaperScale
                      SetGadgetText(#G_PaperScaleSG, Str(GetGadgetState(#G_PaperScale)))
                      paper\scale = GetGadgetState(#G_PaperScale)
                      PaperUpdate()
                      ScreenUpdate(0)
                      
                    Case #G_PaperIntensity, #G_PaperIntensitySG
                      If EventGadget = #G_PaperIntensity
                        intensity = GetGadgetState(#G_PaperIntensity)
                        SetGadgetText(#G_PaperIntensitySG, Str(GetGadgetState(#G_PaperIntensity)))
                      Else
                        intensity = Val(GetGadgetText(#G_PaperIntensitySG))
                        SetGadgetState(#G_PaperIntensity, intensity)
                      EndIf
                      If intensity <> paper\intensity
                        paper\intensity = intensity
                        PaperUpdate()
                        ScreenUpdate(0)
                      EndIf
                      
                    Case #G_PaperBrightness, #G_PaperBrightnessSG
                      If EventGadget = #G_PaperBrightness
                        paperbrightness = GetGadgetState(#G_PaperBrightness)
                        SetGadgetText(#G_PaperBrightnessSG, Str(GetGadgetState(#G_PaperBrightness)))
                      Else
                        paperbrightness = Val(GetGadgetText(#G_PaperBrightnessSG))
                        SetGadgetState(#G_PaperBrightness, paperbrightness)
                      EndIf
                      If paperbrightness <> paper\brightness
                        paper\brightness = paperbrightness
                        PaperUpdate()
                        ScreenUpdate(0)
                      EndIf
                      
                    Case #G_PaperAlpha
                      SetGadgetText(#G_PaperAlphaSG, Str(GetGadgetState(#G_PaperAlpha)))
                      paper\alpha = GetGadgetState(#G_PaperAlpha)
                      PaperUpdate()
                      ScreenUpdate(0)
                      
                    Case #G_PaperAlphaSG
                      Val = Val(GetGadgetText(#G_PaperAlphaSG))
                      If val >=0 And val <=255
                        SetGadgetState(#G_PaperAlpha, val)
                        paper\alpha = val
                        PaperUpdate()
                        ScreenUpdate(0)
                      EndIf
                      
                      ;} 
                      
                      ;{-- splitters
                    Case #G_SplitLayerRB,#G_SplitToolCol
                      IE_SaveSplitter(GetGadgetState(#G_SplitLayerRB),GetGadgetState(#G_SplitToolCol), 0)
                      
                      
                      ;}
                      
                      ;{-- color select
                      
                    Case #G_BrushColorFG
                      If eventType = #PB_EventType_LeftClick
                        Brush(Action)\ColorFG = ColorRequester(Brush(Action)\colorFG)
                        ; BrushUpdateColor()      
                        ; color = RGBA(Brush(Action)\colR,Brush(Action)\colG,Brush(Action)\colB,Brush(Action)\alpha)
                        UpdateColorFG()
                      EndIf
                      
                    Case #G_BrushColorBG
                      If eventType = #PB_EventType_LeftClick
                        Brush(Action)\color = ColorRequester(Brush(Action)\color)
                        Brush(Action)\ColorBG\R = Red(Brush(Action)\Color)
                        Brush(Action)\ColorBG\G = Green(Brush(Action)\Color)
                        Brush(Action)\ColorBG\B = Blue(Brush(Action)\Color)                      
                        BrushUpdateColor()      
                        color = RGBA(Brush(Action)\col\R,Brush(Action)\col\G,Brush(Action)\col\B,Brush(Action)\alpha)
                        SetColorSelector(color,Xx8,yy8,3,1)
                        If action = #Action_CloneStamp
                          SetStampPatternImage(-1,-1)
                        EndIf
                      EndIf
                      
                      
                    Case #GADGET_ColorTxtB, #GADGET_ColorTxtR, #GADGET_ColorTxtG
                      ;{ color from string rgb
                      R = Val(GetGadgetText(#GADGET_ColorTxtR))
                      G = Val(GetGadgetText(#GADGET_ColorTxtG))
                      B = Val(GetGadgetText(#GADGET_ColorTxtB))
                      Brush(Action)\color = RGB(R,G,B)
                      Brush(Action)\ColorBG\R = Red(Brush(Action)\Color)
                      Brush(Action)\ColorBG\G = Green(Brush(Action)\Color)
                      Brush(Action)\ColorBG\B = Blue(Brush(Action)\Color)
                      SetColor()
                      SetColorSelector(RGB(R,G,B),Xx8,yy8,2,0)
                      ;}
                      
                    Case #G_ColorArcEnCiel, #G_ColorSelector
                      gadget = EventGadget
                      mode = gadget-#G_ColorArcEnCiel
                      Xx8 = GetGadgetAttribute(gadget, #PB_Canvas_MouseX)
                      Yy8 = GetGadgetAttribute(gadget, #PB_Canvas_MouseY)
                      ; Debug "mode : " +Str(mode)
                      Select  EventType
                        Case #PB_EventType_LeftButtonDown
                          mouseDownC = #True
                          ColorSelect(xx8,yy8,mode)
                          
                        Case #PB_EventType_MouseMove
                          If GetGadgetAttribute(gadget, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton
                            If mouseDownC = #True
                              ColorSelect(xx8,yy8,mode)
                            EndIf                   
                          EndIf
                          
                        Case #PB_EventType_LeftButtonUp
                          mouseDownC = #False
                          BrushChangeColor(1)  
                          If action = #Action_CloneStamp
                            SetStampPatternImage(-1,-1)
                          EndIf
                      EndSelect
                      RGBtoHSL2()
                      
                      ;}
                      
                      ;}
                      
                  EndSelect
                  
                EndIf 
                
                ;}
                
              Case #Win_Level
                ;{ Win level
                gad=1              
                Select EventGadget
                    
                  Case #IE_BrightnessTB, #IE_ContrastTB
                    Max =  GetGadgetState(#IE_BrightnessTB)
                    Min =  GetGadgetState(#IE_ContrastTB)
                    ImageTransf = CopyImage(Layer(LayerID)\Image, #PB_Any)
                    IE_Level(ImageTransf, Min, Max)
                    
                    If StartDrawing(SpriteOutput(#Sp_LayerTempo))
                      DrawingMode(#PB_2DDrawing_AlphaChannel)
                      Box(0,0,layer(layerid)\w,layer(layerid)\h,RGBA(0,0,0,0))
                      DrawingMode(#PB_2DDrawing_AlphaBlend)
                      DrawAlphaImage(ImageID(ImageTransf),0,0)
                      StopDrawing()
                    EndIf
                    
                    If ImageTransf > #Img_Max
                      FreeImage2(ImageTransf)
                    EndIf
                    ScreenUpdate()
                    
                  Case #IE_ContrastOk
                    IE_Level(layer(layerid)\Image, Min, Max)
                    CloseWindow(#Win_Level)
                    OptionsIE\Shape=0
                    NewPainting = 1                   
                    ScreenUpdate()
                    MouseClic = 0
                    
                EndSelect              
                ;}
                
              Case #Win_BrushImage 
                EventBrushImage(eventgadget)
                
              Case #Win_BrushEditor  
                EventBrushEditor(EventGadget)
                
                ; For the other window gagdets on other windows (pref, newdoc..), see include\procedures\window.pbi
                
            EndSelect
            
          Case #PB_Event_CloseWindow
            If EventWindow = #WinMain
              quit = #eventquit
            Else
              If EventWindow = #Win_BrushEditor
                BrushEditorCloseWindow()
              Else
                 CloseWindow(EventWindow)
              EndIf
              MouseClic = 0               
              MenuOpen = 1
              ScreenUpdate()
              If EventWindow < #win_about
                OptionsIE\Shape=0
              EndIf
            EndIf
            
          Case #PB_Event_RestoreWindow, #PB_Event_ActivateWindow
            ;{ 
            mouseclic = 0
            clic = 0
            Paint = 0
            ScreenUpdate()  
            ;}
            
            ; Case #WM_MOUSEMOVE
            
          Case #WM_MOUSEWHEEL
            ; Verify if we are not over a gadget, but we are over the canvas-screen (to zoom in/out if its the case)
            If Gad= 0
              If Mx>0 And My>0 And Mx<GadgetWidth(#G_ContScreen)-1 And My<GadgetHeight(#G_ContScreen)-1 
                If EventType() = -1
                  
                  If startzoom = 0
                    startzoom = 1
                    OldCanvasX = mx - canvasX
                    OldCanvasY = my - canvasY
                  EndIf
                  
                  ePar = EventwParam()
                  wheelDelta.w = ((ePar>>16)&$FFFF) 
                  OptionsIE\zoom + (wheelDelta / 12)     
                  If OptionsIE\zoom > 5000
                    OptionsIE\zoom = 5000
                  EndIf    
                  If OptionsIE\zoom < 10
                    OptionsIE\zoom = 10
                  EndIf 
                  ScreenZoom() ; update screen   
                  
                EndIf
              EndIf
              
            EndIf
            
          Case #WM_LBUTTONDOWN 
            ; we are on the drawing surface, to do action (painting, select...)
            If Mx>0 And My>0 And Mx<GadgetWidth(#G_ContScreen)-1 And My<GadgetHeight(#G_ContScreen)-1
              If GetActiveWindow() = #WinMain
                MouseClic = 1
                Paint = 1
              EndIf
            EndIf
            
          Case #WM_RBUTTONDOWN 
            ; we are on the drawing surface, to do action (painting, select...)
            If OptionsIE\UseRighmouseToPaint
              If Mx>0 And My>0 And Mx<GadgetWidth(#G_ContScreen)-1 And My<GadgetHeight(#G_ContScreen)-1 ; ScreenWidth()-1 And My<ScreenHeight()-1 
                If MouseClic = 1
                  MouseClic = 0
                  Paint = 0
                Else
                  MouseClic = 1
                  Paint = 1 
                EndIf
              EndIf
            EndIf
            
          Case #PB_Event_LeftClick, #WM_LBUTTONUP
            ;{ mouseleft up
            If Gad =0
              MouseClic = 0
              startzoom = 0
              
              If MoveCanvas = 0
                
                If Action = #Action_Select 
                  If OptionsIE\SelectionH >0 And OptionsIE\SelectionW >0
                    OptionsIE\Selection = 2
                    CreateSelection()
                  EndIf            
                ElseIf Action >= #Action_Line And Action <=#Action_Gradient
                  If alt = 0
                    CreateShape()
                  EndIf 
                ElseIf action = #Action_CloneStamp
                  If StartDrawing(ImageOutput(layer(layerid)\image))
                    DrawAlphaImage(ImageID(#image_patternForstamp),0,0,255)
                    StopDrawing()
                  EndIf
                  SetStampPatternImage(-1,-1)
                  NewPainting = 1
                  ScreenUpdate(1)
                EndIf
                
              EndIf 
              
              If paint = 1
                paint = 0 
                ; Debug "left click-paint"
                ; Layer_updateUi(layerId) ; update the gadget-layer current
                
                If (layer(layerid)\MaskAlpha >= 1 And layer(layerid)\MaskAlpha < 3) Or layer(layerid)\typ =#Layer_TypBG Or OptionsIE\SelectAlpha = 1
                  Newpainting = 1
                  ScreenUpdate()
                EndIf
                
                ; change the stroke array // on modifie le tableau des stroke    
                n = ArraySize(Stroke())
                If n < OptionsIE\Maxundo
                  StrokeId +1
                  ReDim Stroke(StrokeId)
                Else
                  If StrokeId = n
                    StrokeId = 0
                  Else
                    StrokeId +1
                  EndIf              
                EndIf
                
                ; save for undo // on sauve pour l'undo
                ; ImageForUndo()
                
                ; wash the brush (set the initial color ) // on lave le pinceau si besoin
                If Brush(Action)\Wash
                  Brush(Action)\Color = RGB(Brush(Action)\ColorBG\R, Brush(Action)\ColorBG\G, Brush(Action)\ColorBG\B)
                  BrushResetColor()
                  BrushUpdateImage(0,1)
                EndIf
                
                ; clear the layer_tempo
                Select action 
                  Case #Action_Box, #Action_Circle, #Action_Line, #Action_Gradient
                    ; I have to delete the sprite layer tempo (the sprite for temporary operations)
                    freesprite2(#Sp_LayerTempo)
                  Case #Action_Select
                    If OptionsIE\SelectionW = 0 Or OptionsIE\SelectionH = 0
                      DisableMenuItem(#Menu_Main, #menu_Crop, 1)
                      OptionsIE\Selection = 0
                      freesprite2(#Sp_LayerTempo)
                    Else
                      DisableMenuItem(#Menu_Main, #menu_Crop, 0)
                    EndIf
                EndSelect
                
                ; update the preview of the layerImage
                Layer_UpdateUi(layerid)
                
              EndIf
              
              NewPainting = 0
              
            EndIf
            MoveCanvas = 0
            
            ;}
            
          Case #PB_Event_SizeWindow
            ;{ resize the window // on resize la fenêtre
            MenuOpen = 1
            ScreenResized = 1
            IE_UpdateGadget()
            ;}
            
        EndSelect
        
      EndIf
      
      FPS()
      
    Until event = 0 Or event = #WM_LBUTTONDOWN Or event = #WM_LBUTTONUP Or quit = #eventquit
    
    IncludeFile "loop_mousekeyb.pb" ; event paint, erase...
    
    ; confirm exit
    If quit = #eventquit
      If OptionsIE\ConfirmExit = 1
        If OptionsIE\ImageHasChanged
          If MessageRequester(Lang("Exit"), Lang("Do you confirm you want to exit this beautiful program ? You have some work which aren't saved."), 
                              #PB_MessageRequester_YesNo) = #PB_MessageRequester_No    
            quit =0
          EndIf
        EndIf
      EndIf
    EndIf
    
  Until quit = #eventquit
  
CompilerEndIf


;{ Close application // on ferme l'application
If tablet
  WTClose(hCtx)
  CloseLibrary(0)
EndIf

If OptionsIE\AutosaveAtExit
  If OptionsIE\ImageHasChanged
    ExportImage(1)
  EndIf
EndIf

SaveOptions()
CloseScreen()
End
;}

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 963
; FirstLine = 205
; Folding = h4HAAGAAuZTMAgAAgBAAAAAgjBjB5
; EnableXP
; EnableUnicode