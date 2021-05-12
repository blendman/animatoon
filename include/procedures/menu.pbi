
; Menu
Procedure AddMenu(clear=0)
  
  If CreateMenu(#Menu_Main,WindowID(#WinMain))
    
    ;{ menu 
    ; FILE
    MenuTitle(Lang("File"))  
    MenuItem(#menu_New,         Lang("New")+Chr(9)+"Ctrl+N")
    MenuBar()
    MenuItem(#Menu_Open,        Lang("Open")+Chr(9)+"Ctrl+O")
    MenuItem(#Menu_Import,      Lang("Import")+Chr(9)+"Ctrl+I")
    MenuBar()
    MenuItem(#Menu_Save,        Lang("Save")+Chr(9)+"Ctrl+S")
    MenuItem(#Menu_SaveAs,      Lang("Save As")+Chr(9)+"Ctrl+Shift+S")
    OpenSubMenu(Lang("Export"))
    MenuItem(#Menu_SaveImage,   Lang("Save image"))    
    MenuItem(#Menu_ExportAll,   Lang("Export layers (in png)")+Chr(9)+"Ctrl+Alt+E")
    MenuItem(#Menu_ExportAllZip,Lang("Export layers (zip)")+Chr(9)+"Alt+E")
    MenuItem(#Menu_Export,      Lang("Export layer image")+Chr(9)+"Ctrl+E")
    CloseSubMenu()
    MenuBar()
    MenuItem(#Menu_Pref,        Lang("Preferences"))
    MenuBar()
    MenuItem(#Menu_Exit,        Lang("Exit")+Chr(9)+"Escape")
    
    ; EDITIONS
    MenuTitle(Lang("Edit"))
    MenuItem(#Menu_Cut,         Lang("Cut")+Chr(9)+"Ctrl+X")
    MenuItem(#Menu_Copy,        Lang("Copy")+Chr(9)+"Ctrl+C")
    MenuItem(#Menu_Paste,       Lang("Paste")+Chr(9)+"Ctrl+V")
    MenuBar()
    MenuItem(#Menu_clear,       Lang("Clear")+Chr(9)+"Ctrl+W")
    MenuBar()
    OpenSubMenu(Lang("Fill"))
    MenuItem(#Menu_FillAll,      Lang("Fill with BG color")+Chr(9)+"Ctrl+K")
    MenuItem(#Menu_Fill,         Lang("Fill the transparent pixel with BG color"))
    MenuItem(#Menu_FillPatern,   Lang("Fill with pattern"))
    CloseSubMenu()
    
    
    ; VIEW
    MenuTitle(Lang("View"))
    MenuItem(#menu_IE_Grid,       Lang("Grid") + Chr(9) + "Ctrl + G")
    MenuBar()
    MenuItem(#menu_IE_ZoomPlus,   Lang("Zoom +") + Chr(9) + "Ctrl '+'")
    MenuItem(#menu_IE_ZoomMoins,  Lang("Zoom -")+ Chr(9) + "Ctrl '-'")
    OpenSubMenu(Lang("Zoom"))
    MenuItem(#menu_IE_Zoom50,     Lang("Zoom")+" 50%")
    MenuItem(#menu_IE_Zoom100,    Lang("Zoom")+" 100%"+ Chr(9) + "Ctrl + Pad0")
    MenuItem(#menu_IE_Zoom200,    Lang("Zoom")+" 200%")
    MenuItem(#menu_IE_Zoom300,    Lang("Zoom")+" 300%"+ Chr(9) + "Ctrl + Pad3")
    MenuItem(#menu_IE_Zoom400,    Lang("Zoom")+" 400%"+ Chr(9) + "Ctrl + Pad4")
    MenuItem(#menu_IE_Zoom500,    Lang("Zoom")+" 500%")
    MenuItem(#menu_IE_Zoom1000,   Lang("Zoom")+" 1000%")
    CloseSubMenu()
    MenuBar()
    ;OpenSubMenu(Lang("Canvas"))
    ;CloseSubMenu()
    OpenSubMenu(Lang("Canvas drawing"))
    MenuItem(#Menu_RealTime,      Lang("Update the screen (Real Time)"))
    SetMenuItemState(0,#Menu_RealTime,Clear)
    MenuItem(#menu_ChangeCenter,  Lang("Change the Center"))
    MenuItem(#menu_ScreenRedraw,  Lang("Refresh the screen"))
    MenuItem(#menu_ScreenQuality, Lang("Screen Filtering"))
    
    CloseSubMenu()
    MenuBar()
    MenuItem(#Menu_ResetCenter,   Lang("Reset view")+ Chr(9) + "Ctrl + Pad1")
    MenuItem(#Menu_CenterView,    Lang("Center view")+ Chr(9) + "Ctrl + Pad5")
    ;MenuBar()
    ;MenuItem(#Menu_CenterView,    Lang("Center view")+ Chr(9) + "Ctrl + Pad5")
    
    
    ; selection
    MenuTitle(Lang("Selection"))
    MenuItem(#Menu_SelectAll,     Lang("Select all")+Chr(9)+"Ctrl+A")
    MenuItem(#Menu_DeSelect,      Lang("Deselect")+Chr(9)+"Ctrl+D")
    MenuBar()
    ; MenuItem(#Menu_SelectionsEditor, Lang("Selections (save/load)"))
    MenuItem(#Menu_SelectAlphaLayer, Lang("Select the alpha of the layer"))

    ;MenuItem(#Menu_SelExtend,     Lang("Extend"))
    ;MenuItem(#Menu_SelContract,   Lang("Contract"))
    ;MenuItem(#Menu_SelInverse,    Lang("Inverse"))
    ;MenuBar()
    ;     OpenSubMenu(Lang("Selection"))
    ;     MenuItem(#Menu_SelectExtend,  Lang("Extend"))
    ;     CloseSubMenu()
    
    ; IMAGE
    MenuTitle(Lang("Image")) 
    OpenSubMenu(Lang("Adjustement"))
    MenuItem(#menu_Constrast,     Lang("Brightness/constrast"))
    MenuItem(#menu_Level,         Lang("Level"))
    MenuBar()
    ; MenuItem(#menu_HueSat,         Lang("Hue/Saturation"))
    MenuItem(#menu_ColorBalance,  Lang("Color balance"))
    MenuBar()    
    MenuItem(#menu_InverseColor,  Lang("Inverse Color"))
    MenuItem(#menu_Posterize,     Lang("Posterize"))
    MenuBar()   
    MenuItem(#menu_Desaturation,  Lang("Desaturate"))
    CloseSubMenu()
    MenuBar()    
    MenuItem(#Menu_ResizeDoc,     Lang("Image Size"))
    MenuItem(#Menu_ResizeCanvas,  Lang("Canvas Size"))
    MenuBar()
    MenuItem(#menu_Crop,          Lang("Crop"))
    MenuItem(#menu_Trim,          Lang("Trim"))
    DisableMenuItem(0, #menu_Crop, 0)
    MenuBar()    
    OpenSubMenu(Lang("Rotation"))
    MenuItem(#menu_Rotate90,      Lang("Rotation 90"))
    MenuItem(#menu_Rotate180,     Lang("Rotation 180"))
    MenuItem(#menu_Rotate270,     Lang("Rotation 270"))
    MenuItem(#menu_RotateFree,    Lang("Rotation free"))
    CloseSubMenu()
    
    
    
    ; LAYER
    MenuTitle(Lang("Layer"))
    MenuItem(#Menu_LayerAdd,      Lang("Add a layer"))
    MenuItem(#Menu_LayerDel,      Lang("Delete the layer"))
    ; MenuBar()
    MenuItem(#Menu_LayerDuplicate,Lang("Duplicate the layer"))
    MenuBar()
    MenuItem(#Menu_LayerMoveDown, Lang("Move layer down"))
    MenuItem(#Menu_LayerMoveUp,   Lang("Move layer up"))
    MenuBar()
    MenuItem(#Menu_LayerMergeDown,Lang("Merge layer down"))
    ; MenuItem(#Menu_LayerMergeAllVisible,"Merge all visible Layer")
    MenuItem(#Menu_LayerMergeAll, Lang("Merge all layers"))
    ; MenuItem(#Menu_LayerMergeLinked,"Merge all Layers linked")
    MenuBar()
    OpenSubMenu(lang("Transformations"))
    MenuItem(#Menu_MirorH,        Lang("Flip layer horizontaly"))
    MenuItem(#Menu_MirorV,        Lang("Flip layer verticaly"))
    MenuItem(#Menu_LayerRotate,   Lang("Rotate the layer"))
    CloseSubMenu()
    MenuBar()
    OpenSubMenu(lang("Alpha"))
    MenuItem(#Menu_LayerTransformToLine,    Lang("Transform the image of the layer in line"))
    MenuItem(#Menu_LayerAddBackgroundOnAlpha,   Lang("Add a background on the alpha of the layer"))
    MenuItem(#Menu_LayerEraseAlpha,         Lang("Erase the alpha of the layer"))
    CloseSubMenu()
    
    
    ; FILTERS
    MenuTitle(Lang("Filters"))
    
    OpenSubMenu(lang("Blur"))
    MenuItem(#Menu_IE_Blur,       Lang("Blur"))
    CloseSubMenu()
    OpenSubMenu(lang("Sharpen"))
    ; MenuItem(#Menu_IE_Sharpen,    Lang("Sharpen"))
    MenuItem(#Menu_IE_SharpenAlpha,    Lang("Sharpen alpha"))
    CloseSubMenu()
    OpenSubMenu(lang("Noise"))
    MenuItem(#menu_IE_Noise,      Lang("Noise"))
    ; MenuItem(#menu_IE_Clouds,     Lang("Clouds"))
    CloseSubMenu()
;     OpenSubMenu(lang("Misc"))
;     MenuItem(#menu_IE_Offset,      Lang("Offset"))
;     CloseSubMenu()
    
    
    If plugin = 1
      OpenSubMenu(lang("Plugins"))
      
      If ExamineDirectory(0,"./data/Plugins/Filters/","*.dll")
        While NextDirectoryEntry(0)
          If DirectoryEntryType(0) = #PB_DirectoryEntry_File
            pluginFile.s = DirectoryEntryName(0)
            
            lib = OpenLibrary(#PB_Any,"./data/plugins/Filters/"+pluginFile)
            If lib
              ; OptionsIE\nbPlugins + 1
              AddElement(Ani_Plugins())
              Ani_Plugins()\lib= lib
              
              n =ListSize(Ani_Plugins())
              Ani_Plugins()\menuId= n
              Ani_Plugins()\name$ = RemoveString(pluginFile,".dll")
              
              ; AddElement(*aP\pluginLibrary())
              ; *aP\pluginLibrary() = lib
              MenuItem(#Menu_Last +n , Ani_Plugins()\name$)
            Else
              MessageRequester(Lang("Error"), Lang("Unable To load the dll")+" "+pluginFile)
            EndIf 
            
            
          EndIf
        Wend 
        FinishDirectory(0)
      EndIf 
      
      CloseSubMenu()
    EndIf
    
    
    ; ACTIONS
    MenuTitle(Lang("Actions"))
    MenuItem(#Menu_ActionSave,    Lang("Save action"))
    MenuItem(#Menu_ActionStop,    Lang("Stop action"))
    MenuItem(#Menu_ActionRun,     Lang("Run action"))
    
    
    ; window
    MenuTitle(Lang("Window"))
    MenuItem(#Menu_SHowHideAllUI,    Lang("Show all UI") +" (Tab)")
    MenuBar()
    OpenSubMenu(lang("Show/hide"))
    MenuItem(#menu_ShowToolParameters,    Lang("Show tools parameters"))    
    MenuItem(#menu_ShowColor,    Lang("Show colors"))    
    ; MenuItem(#menu_Showgradient,    Lang("Show Gradients"))   
    MenuItem(#menu_ShowLayers,    Lang("Show layers"))    
    ; MenuItem(#menu_ShowPresets,    Lang("Show presets"))    
    ; MenuItem(#menu_Showoptions,    Lang("Show options"))    
    MenuItem(#menu_ShowSwatchs,    Lang("Show swatchs"))    
    ; MenuItem(#menu_ShowRoughBoard,    Lang("Show Roughboards"))    
    ; MenuItem(#menu_ShowPatterns,    Lang("Show patterns"))
    CloseSubMenu()
    ; MenuBar()
    ; MenuItem(#menu_ShowStatus,    Lang("Show status bar")) 
    MenuBar()
    MenuItem(#Menu_BackgroundEditor,   Lang("Background editor"))
    MenuItem(#Menu_BrushEditor,   Lang("Brush editor"))
    
    
    ; HELP
    MenuTitle(Lang("Help"))
    MenuItem(#Menu_about,         Lang("About"))
    MenuItem(#Menu_Infos,         Lang("Info"))
    ;}
    
    ;{ shortcuts
    ; file
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_N|#PB_Shortcut_Control,#menu_New)
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_O|#PB_Shortcut_Control,#Menu_Open)
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_S|#PB_Shortcut_Control,#menu_Save)
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_S|#PB_Shortcut_Control|#PB_Shortcut_Shift,#Menu_SaveAs)
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_I|#PB_Shortcut_Control,#Menu_Import)
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_E|#PB_Shortcut_Control,#Menu_Export)
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_E|#PB_Shortcut_Control|#PB_Shortcut_Alt,#Menu_ExportAll)
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_E|#PB_Shortcut_Alt,#Menu_ExportAllZip)
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_Escape,#menu_Exit)
    
    ; edit
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_C|#PB_Shortcut_Control,#Menu_Copy)
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_W|#PB_Shortcut_Control,#menu_Clear)
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_X|#PB_Shortcut_Control,#Menu_Cut)
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_V|#PB_Shortcut_Control,#Menu_Paste)
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_K|#PB_Shortcut_Control,#Menu_FillAll)
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_D|#PB_Shortcut_Control,#Menu_DeSelect)
    AddKeyboardShortcut(#WinMain,#PB_Shortcut_A|#PB_Shortcut_Control,#Menu_SelectAll)
    
    ; view
    AddKeyboardShortcut(#WinMain, #PB_Shortcut_G|#PB_Shortcut_Control, #menu_IE_Grid)
    AddKeyboardShortcut(#WinMain, #PB_Shortcut_Pad0|#PB_Shortcut_Control, #menu_IE_Zoom100)
    AddKeyboardShortcut(#WinMain, #PB_Shortcut_Pad5|#PB_Shortcut_Control, #Menu_CenterView)
    AddKeyboardShortcut(#WinMain, #PB_Shortcut_Pad1|#PB_Shortcut_Control, #Menu_ResetCenter)
    AddKeyboardShortcut(#WinMain, #PB_Shortcut_Pad4|#PB_Shortcut_Control, #menu_IE_Zoom400)
    AddKeyboardShortcut(#WinMain, #PB_Shortcut_Pad3|#PB_Shortcut_Control, #menu_IE_Zoom300)
    
    ; window
    AddKeyboardShortcut(#WinMain, #PB_Shortcut_Tab, #Menu_SHowHideAllUI)

    ;}
    
  EndIf 
  
  
  If CreatePopupMenu(#Menu_Layer) 
    
    MenuItem(#Menu_Layer_Normal,Lang("Layer bitmap"))
    MenuItem(#Menu_Layer_Text,  Lang("Layer text"))
    MenuItem(#Menu_Layer_BG,    Lang("Layer background"))
    MenuItem(#Menu_Layer_Shape, Lang("Layer shape"))
    MenuBar()
    MenuItem(#Menu_Layer_Group, Lang("Layer group"))
    
  EndIf
  
  
EndProcedure

Procedure AddLogError(error, info$)
  
  LogError$ +info$ + Chr(13)
  Date$ = FormatDate("%yyyy%mm%dd", Date()) 
  Thedate$= FormatDate("%yyyy/%mm/%dd(%hh:%ii:%ss)", Date())
  LogFile$ =  "save\logError.txt" ; "save\logError"+Date$+".txt"
  
  If OpenFile(0,    LogFile$, #PB_File_Append) 
    
    ; read and save the previous infos ?
    
    WriteStringN(0, Thedate$)
    WriteString(0,  LogError$)
    CloseFile(0)
  Else
    If CreateFile(0,  LogFile$)
      WriteStringN(0, Thedate$ )
      WriteString(0,  LogError$)
      CloseFile(0)
    EndIf
    
  EndIf
  
EndProcedure

Procedure UpdateLanguageUI()
  
  ; to update the langage for the Interface
  
  ; I need to update the menu (change the lang)
  ;   SetMenuTitleText(#Menu_Main, 0, Lang("File"))
  ;   SetMenuTitleText(#Menu_Main, 1, Lang("Edit"))
  ;   SetMenuTitleText(#Menu_Main, 2, Lang("View"))
  ;   SetMenuTitleText(#Menu_Main, 3, Lang("Selection"))
  ;   SetMenuTitleText(#Menu_Main, 4, Lang("Image"))
  ;   SetMenuTitleText(#Menu_Main, 5, Lang("Layer"))
  ;   SetMenuTitleText(#Menu_Main, 6, Lang("Filters"))
  ;   SetMenuTitleText(#Menu_Main, 7, Lang("Actions"))
  ;   SetMenuTitleText(#Menu_Main, 8, Lang("Help"))
  
  FreeMenu(#Menu_Main) 
  RemoveKeyboardShortcut(#WinMain, #PB_Shortcut_All )
  
  AddMenu()
  
  
  ; update the gadgets of the main Windows
  
  
EndProcedure


;{ File + options (pref) & autosave

Procedure.a GetFileExist(filename$)
  
  Directory$ = GetPathPart(filename$)
  name$ = GetFilePart(filename$)
  
  If ExamineDirectory(0, Directory$, "*.*")  
    While NextDirectoryEntry(0)
      If DirectoryEntryType(0) = #PB_DirectoryEntry_File
        If DirectoryEntryName(0) = name$
          ProcedureReturn #True
          Break
        EndIf        
      EndIf
    Wend
    FinishDirectory(0)
  EndIf
  
  
  ProcedureReturn #False
EndProcedure
Procedure ChangeCursor(load=0)
  ; on crée le cursor
  With OptionsIE
    
    FreeImage2(\CursorImgId)
    FreeSprite2(\CursorSpriteId)
    
    \CursorImgId = CopyImage(#BrushOriginal,#PB_Any)
    \CursorW = ImageWidth(#BrushCopy)
    \CursorH = ImageHeight(#BrushCopy)
    ResizeImage(\CursorImgId,\CursorW,\CursorH)
    \CursorSpriteId = CreateSprite(#PB_Any,\CurSorW,\CursorH)
    
    If StartDrawing(SpriteOutput(\CursorSpriteId))
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      Box(0,0,\CursorW,\CursorH,RGBA(0,0,0,255))
      DrawAlphaImage(ImageID(\CursorImgId),0,0,50)
      DrawingMode(#PB_2DDrawing_AlphaClip)
      ;DrawImage(ImageID(\CursorImgId),1,1,\CursorW-2,\Cursorh-2)
      StopDrawing()
    EndIf
    
  EndWith
  
EndProcedure
Procedure InitProgram()
  
  Shared PanelToolsW_IE, AutosaveTimeStart
  
  ; for autosave
  AutosaveTimeStart = ElapsedMilliseconds()
  
  ; needed to have the screen centered
  PanelLayerW_IE  = 175
  ScreenX = PanelLayerW_IE +10
  
  If OpenPreferences("Pref.ini")
    
    PreferenceGroup("General")
    
    PanelLayerW_IE  = ReadPreferenceInteger("PanelLayerW", 175)
    ScreenX = PanelLayerW_IE +10
    
    ClosePreferences()
    
  EndIf
  
EndProcedure

; Window info
Procedure CreateWindowInfo(info$, name$="")
  
  ; to create a temporary window to draw information about action (saving, autosave, opening...)
  w = 300
  If name$ = ""
    name$ = lang("Information")
  EndIf
  
  If OpenWindow(#win_autosave, (WindowWidth(#WinMain)- w)/2, 170, w, 110, name$, #PB_Window_SystemMenu, WindowID(#WinMain))
    
    If StartDrawing(WindowOutput(#win_autosave))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(),OutputHeight(), RGB(150,150,150))
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawingFont(FontID(#FontArial20Bold))
      DrawText(10, 5, info$, RGB(255, 255, 255))
      StopDrawing()
    EndIf
  EndIf
  
EndProcedure
Procedure UpdateWindowInfo(info$)
  
  ; count the number of line to draw
  nb = CountString(info$, "#")
  Dim txt$(nb)
  
  For i=0 To nb
    
    Txt$(i) = StringField(info$, i+1, "#")
    ; check if need to resize the window
    w = Len(txt$(i))*20 
    h = 5+(1+nb*35)
    
    If h > WindowHeight( #win_autosave)
      ResizeWindow(#win_autosave, #PB_Ignore, #PB_Ignore, #PB_Ignore, h)
    EndIf
    If w > WindowWidth( #win_autosave)
      ResizeWindow(#win_autosave, #PB_Ignore, #PB_Ignore, w, #PB_Ignore)
    EndIf
    
  Next
  
  If StartDrawing(WindowOutput(#win_autosave))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(),OutputHeight(), RGB(150,150,150))
      
      ; draw the infos
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawingFont(FontID(#FontArial20Bold))
      For i = 0 To nb
        DrawText(10, 5+30*i, txt$(i), RGB(255, 255, 255))
      Next 
      
      StopDrawing()
    EndIf
    
    FreeArray(txt$())
    
EndProcedure


; options
Procedure OpenOptions()
  
  Shared PanelToolsW_IE, PanelToolsH_IE, PanelLayerW_IE, PanelLayerH_IE, BarAnimH_IE 
  
  If OpenPreferences("Pref.ini")
    
    If ExaminePreferenceGroups()
      
      While NextPreferenceGroup()
        
        pgn$ = PreferenceGroupName()
        
        If pgn$ = "General"
          
          ;{ options
          
          With OptionsIE
            
            ; theme and color
            \Theme$         = ReadPreferenceString("Theme","data\Themes\Animatoon")
            c = -1; RGB(100,100,100)
            \ThemeColor     = c ; ReadPreferenceInteger("ThemeColor",RGB(150,150,150))
            \ThemeGadCol    = c ; ReadPreferenceInteger("ThemeColor",RGB(150,150,150))
            \ThemeMenuCol   = c ; ReadPreferenceInteger("ThemeColor",RGB(150,150,150))
            \ThemeStaCol    = c ; ReadPreferenceInteger("ThemeColor",RGB(150,150,150))
            \ThemeTBCol     = c ; ReadPreferenceInteger("ThemeColor",RGB(150,150,150))
            
            ; set the UI color      
            SetWindowColor(#WinMain, OptionsIE\ThemeColor)
            
            
            ; Options
            \zoom           = ReadPreferenceInteger("Zoom",       100)
            \ConfirmExit    = ReadPreferenceInteger("ConfirmExit",   1)
            \ModeAdvanced    = ReadPreferenceInteger("ModeAdvanced",   1)
            \UseRighmouseToPaint    = ReadPreferenceInteger("UseRighmouseToPaint",   0)
            \UseCanvas    = ReadPreferenceInteger("UseCanvas",   0)
            \UsePaperForRendering    = ReadPreferenceInteger("UsePaperForRendering",   1)
            
            
            ; autosave
            \autosaveAtExit = ReadPreferenceInteger("autosaveAtExit",   0)
            \autosave       = ReadPreferenceInteger("autosave",   1)
            \AutosaveTime   = ReadPreferenceInteger("autosaveTime",   10)
            If \AutosaveTime <= 0
              \AutosaveTime = 1
            EndIf
            
            \Maxundo        = ReadPreferenceInteger("Maxundo",    16)
            If \Maxundo > 32
              \Maxundo = 32
            EndIf
            \SaveImageRT = 1
            
            \SpriteQuality  = ReadPreferenceInteger("Filtering",  1)
            
            ; view
            \Statusbar      = ReadPreferenceInteger("Statusbar",  1)
            
            \Grid           = ReadPreferenceInteger("Grid",       1)
            \GridW          = ReadPreferenceInteger("GridW",      32)
            \GridH          = ReadPreferenceInteger("GridH",      32)
            \GridColor      = ReadPreferenceInteger("GridColor",  0)
            
            
            ; UI
            \AreaBGColor    = ReadPreferenceInteger("AreaBGColor",  RGB(120,120,120))
            PanelLayerW_IE  = ReadPreferenceInteger("PanelLayerW", 150)
            PanelLayerH_IE  = ReadPreferenceInteger("PanelLayerH", 400)
            PanelToolsW_IE  = ReadPreferenceInteger("PanelToolsW", 165)
            ScreenX = PanelToolsW_IE +10
            PanelToolsH_IE  = ReadPreferenceInteger("PanelToolsH", 300)
            
            \ShowPanelToolparameters = ReadPreferenceInteger("ShowPanelToolparameters", 1)
            \ShowPanelColors = ReadPreferenceInteger("ShowPanelColors", 1)
            \ShowPanelLayers = ReadPreferenceInteger("ShowPanelLayers", 1)
            \ShowPanelswatchs = ReadPreferenceInteger("ShowPanelswatchs", 1)
            \ShowFullUI = ReadPreferenceInteger("ShowFullUI", 1)
            
            
            
            ; optimisation, realtime, fps
            \DelayMax         = ReadPreferenceInteger("DelayMax", 15) 
            \Delay            = \DelayMax
            
            ; toolbar
            \ToolbarH       = ReadPreferenceInteger("ToolbarH",     36)
            \ToolInfoH      = ReadPreferenceInteger("ToolInfoH",    36)
            \ToolbarFileY   = ReadPreferenceInteger("ToolbarFileY",  0)
            \ToolbarFileX   = ReadPreferenceInteger("ToolbarFileX",  -2)
            \ToolbarFile    = ReadPreferenceInteger("ToolbarFile",   1)
            
            \ToolbarToolY   = ReadPreferenceInteger("ToolbarToolY",  36)
            \ToolbarToolX   = ReadPreferenceInteger("ToolbarToolX",  -2)
            \ToolbarTool    = ReadPreferenceInteger("ToolbarTool",    1)
            
            If \ToolbarToolY > 36
              \ToolbarToolY = 36        
            EndIf
            If \ToolbarFileY > 36
              \ToolbarFileY = 36        
            EndIf
            
            If \ToolbarFileY < \ToolbarH And \ToolbarToolY < OptionsIE\ToolbarH
              
              \ToolInfoH = 0        
              
            Else
              
              \ToolInfoH = OptionsIE\ToolbarH
              
            EndIf
            
            ; border // bordure
            \BordureX  = ReadPreferenceInteger("BordureX",      50)
            \BordureY  = ReadPreferenceInteger("BordureY",      50)
            BarAnimH_IE         = ReadPreferenceInteger("BarAnimH",     80)
            
            ; options background paper
            \paper$       = ReadPreferenceString("Paper", "paper1.png")
            paper\alpha   = ReadPreferenceInteger("PaperAlpha", 255)
            paper\scale   = ReadPreferenceInteger("PaperScale", 10)
            paper\intensity   = ReadPreferenceInteger("PaperIntensity", 10)
            
            ; Document by default ?
            \ImageW       = ReadPreferenceInteger("ImageW", 1024)
            \ImageH       = ReadPreferenceInteger("ImageH", 768)
            
            ; colors
            
            ; directories
            \DirPattern$  = ReadPreferenceString("DirPattern", "data\Presets\Patterns\")
            \DirPreset$   = ReadPreferenceString("DirPresets", "data\Presets\Bank\Blendman\")
            \DirBrush$    = ReadPreferenceString("DirBrush", "blendman")
            \RB_Img$      = ReadPreferenceString("RB_img", GetCurrentDirectory() + "data\Presets\RoughBoard\rb.png") 
            \Swatch$      = ReadPreferenceString("Swatch", GetCurrentDirectory() + "data\Presets\Swatch\Tango.gpl") 
            \SwatchColumns = ReadPreferenceInteger("SwatchColumns", 7) 
            If \SwatchColumns < 3
              \SwatchColumns = 6
            EndIf
            
            \PathOpen$  = ReadPreferenceString("PathOpen", GetCurrentDirectory() +"save\")
            \PathSave$  = ReadPreferenceString("PathSave", GetCurrentDirectory() + "save\")
            ; \FileBGcolor$  = ReadPreferenceString("FileBGcolor", GetCurrentDirectory() + "data\Presets\Background\colors.gpl")
            
            
            \Version$ = "6"
            ; GM = 1, Construct = 2, PB-canvas = 3, pb_teo = 4, agk = 5, pb_screen = 6, pb_openGL = 7
            
            
            ; statistics
            \NbNewFile       = ReadPreferenceInteger("NbNewFile", 1)
            \NbMinutes       = ReadPreferenceInteger("NbMinutes", 0)
            
            
          EndWith
          
          doc\w = OptionsIE\ImageW
          doc\h = OptionsIE\ImageH
          
          ;}
          
        Else
          
          ;{ tool (brush, eraser, pen, gradient....)
          
          ;     ; gradient
          ;     PreferenceGroup("Gradient")
          ;     With brush(#Action_Gradient)
          ;       \Color    = ReadPreferenceInteger("GradientBG",    RGB(255, 255, 255))
          ;       \ColorBG\R = Red(\Color)
          ;       \ColorBG\G = Green(\Color)
          ;       \ColorBG\B = Blue(\Color)
          ;       \alpha = ReadPreferenceInteger("GradientBGAlpha",    255)
          ;       \AlphaFG = ReadPreferenceInteger("GradientFGAlpha",    255)
          ;       \ColorFG  = ReadPreferenceInteger("GradientFG",    0)
          ;       \Type     = ReadPreferenceInteger("GradientType",  0)
          ;     EndWith
          
          
          If pgn$ = "Brush" Or pgn$ = "Eraser" Or pgn$ = "Pen"
            
            ; first I load the paint and eraser tool parameters
            For i = 0 To 2 
              
              ; we open the tools parameters (brush, pen...)
              ; on réouvre les tools brush, eraser et pen, 
              ; pour les autres, je les sauvegarder plus tard, lorsque j'aurai créer leur propres paramètres
              Select  i 
                  
                Case 0
                  theaction = #action_brush
                  PreferenceGroup("Brush")
                  
                Case 1 ; eraser
                  theaction = #Action_Eraser 
                  PreferenceGroup("Eraser")
                  
                Case 2 ; pen
                  theaction = #Action_Pen 
                  PreferenceGroup("Pen")
                  
              EndSelect
              
              With Brush(theaction)
                
                
                \Id  = ReadPreferenceInteger("BrushImage", 1)
                If \Id <=0
                  \Id=1
                EndIf
                \BrushNum  = ReadPreferenceInteger("BrushNum", 0)
                \BrushForm = ReadPreferenceInteger("BrushForm", 0)
                
                \BrushDir$ = ReadPreferenceString("BrushDir", "data\Presets\Brush\blendman\")
                If ExamineDirectory(0, \brushDir$, "*.png")
                  
                  While NextDirectoryEntry(0)
                    If DirectoryEntryType(0) = #PB_DirectoryEntry_File
                      \BrushNumMax +1
                    EndIf
                  Wend        
                  FinishDirectory(0)        
                  \BrushNumMax -1 
                  
                EndIf
                
                ; size
                \Size      = ReadPreferenceInteger("size",     15)
                \SizeW     = ReadPreferenceInteger("sizeW",     100)
                \SizeH     = ReadPreferenceInteger("sizeH",     100)
                \SizeMin   = ReadPreferenceInteger("sizeMin",   0)
                \Sizepressure = ReadPreferenceInteger("sizePressure",1)
                
                ; dynamincs
                \Scatter   = ReadPreferenceInteger("Scatter",  0)
                \rotate    = ReadPreferenceInteger("rotate",   0)
                \randRot   = ReadPreferenceInteger("randrotate", 360)
                \RotateByAngle   = ReadPreferenceInteger("rotateangle", 1)
                
                ; alpha
                \Alpha     = ReadPreferenceInteger("alpha",    255)
                \alphaMax = \Alpha
                \AlphaBlend= ReadPreferenceInteger("alphablend",255)
                \AlphaFG   = ReadPreferenceInteger("alphaFG",  255)
                \AlphaPressure   = ReadPreferenceInteger("alphaPressure",  0)
                \AlphaRand = ReadPreferenceInteger("alpharand",  0)
                
                ; color
                \Color    = ReadPreferenceInteger("color",    1)
                Brush(Action)\ColorBG\R = Red(Brush(Action)\Color)
                Brush(Action)\ColorBG\G = Green(Brush(Action)\Color)
                Brush(Action)\ColorBG\B = Blue(Brush(Action)\Color)
                
                ;If \color  = 0
                ;\Color   = 1
                ;EndIf 
                \ColorFG    = ReadPreferenceInteger("colorFG",    1)
                ;If \ColorFG = 0
                ; \ColorFG   = 1
                ;EndIf 
                
                \mix      = ReadPreferenceInteger("mixing",  50)
                \MixType  = ReadPreferenceInteger("mixtyp",  0)
                \MixLayer = ReadPreferenceInteger("mixlayer",  0)
                
                ; \Mix       = \mixing/100
                \Visco    = ReadPreferenceInteger("visco",  3)
                \Wash   = ReadPreferenceInteger("wash", 1)
                \Wash   = ReadPreferenceInteger("lavage", 1)
                \Water    = ReadPreferenceInteger("water",  0)
                
                
                ; parameters
                \pas      = ReadPreferenceInteger("pas",      50)
                \Type     = ReadPreferenceInteger("type",     0)
                \Trait    = ReadPreferenceInteger("trait",    1)
                \Smooth   = ReadPreferenceInteger("smooth",   0)
                \Hardness = ReadPreferenceInteger("hardness", 0)
                
                
                ; shape
                \ShapeOutline = ReadPreferenceInteger("ShapeOutline",  0)
                \ShapeOutSize = ReadPreferenceInteger("ShapeOutSize",  1)
                \ShapePlain   = ReadPreferenceInteger("ShapePlain",    1)
                \ShapeType    = ReadPreferenceInteger("ShapeType",     0)
                \RoundX       = ReadPreferenceInteger("RoundX",        5)
                \RoundY       = ReadPreferenceInteger("RoundY",        5)
                
                ; spray
                \Spray        = ReadPreferenceInteger("Spray",        10)
                \NbSpray      = ReadPreferenceInteger("NbSpray",      15)
                
                
              EndWith
              
            Next i
            
          Else
            
            ; for old version of pref.ini
            For i = #Action_Spray To #Action_Text
              If i <> #Action_Eraser
                brush(i)\Alpha = 255
                brush(i)\AlphaFG = 255
              EndIf
            Next i
            
            ; then I load the other tool parameters
            tool$ = "Pen,Brush,Spray,Stamp,Particles,Line,Box,Circle,Shape,Gradient,Fill,Text,Eraser,Clear,Pickcolor,Select,Move,Transform,Rotate,Hand,Zoom"
            
            For i = #Action_Spray To #Action_Zoom 
              
              If i <> #Action_Eraser
                
                theaction  = i
                
                If pgn$ = (StringField(tool$,i+1,","))
                  
                  With Brush(theaction)
                    \Size         = ReadPreferenceInteger("size",         15)
                    \Type         = ReadPreferenceInteger("type",         0)
                    \Alpha        = ReadPreferenceInteger("alpha",        255)
                    \alphaMax = \Alpha
                    \AlphaBlend   = ReadPreferenceInteger("alphablend",    255)
                    \AlphaFG      = ReadPreferenceInteger("alphaFG",       255)
                    \Color    = ReadPreferenceInteger("color",    1)
                    \ColorBG\R = Red(\Color)
                    \ColorBG\G = Green(\Color)
                    \ColorBG\B = Blue(\Color)
                    \ColorFG    = ReadPreferenceInteger("colorFG",    1)
                    \ShapeOutline = ReadPreferenceInteger("ShapeOutline",  0)
                    \ShapeOutSize = ReadPreferenceInteger("ShapeOutSize",  1)
                    \ShapePlain   = ReadPreferenceInteger("ShapePlain",    1)
                    \ShapeType    = ReadPreferenceInteger("ShapeType",     0)
                    \RoundX       = ReadPreferenceInteger("RoundX",        5)
                    \RoundY       = ReadPreferenceInteger("RoundY",        5)          
                  EndWith
                  
                EndIf
                
              EndIf
              
            Next
            
          EndIf
          
          ;}
          
        EndIf
        
      Wend
      
    EndIf
    
    ; change some parameters For selection
    OptionsIE\SelectionType = Brush(#Action_Select)\Type
    
    ClosePreferences()
    
  Else
    
    ; MessageRequester(Lang("Info"),"Unable to load the pref file")
    
  EndIf
  
  
EndProcedure
Procedure WriteDefaultOption()
  
  Shared PanelToolsW_IE, PanelToolsH_IE, PanelLayerW_IE, PanelLayerH_IE, BarAnimH_IE 
  
  WritePreferenceString("Lang",  OptionsIE\Lang$)
  
  PreferenceGroup("General")
  
  With OptionsIE
    
    WritePreferenceString("Paper",          \Paper$)
    WritePreferenceInteger("PaperAlpha",      paper\alpha)
    WritePreferenceInteger("PaperScale",      paper\scale)
    WritePreferenceInteger("PaperIntensity",  paper\intensity)
    WritePreferenceInteger("Papercolor",      paper\Color)
    
    
    WritePreferenceInteger("SwatchColumns",  \SwatchColumns)
    
    WritePreferenceString("Theme",  \Theme$)
    WritePreferenceString("ThemeColor",  Str(\ThemeColor))
    
    ; Paths & directories
    WritePreferenceString("DirPattern",  RemoveString(\DirPattern$, GetCurrentDirectory()))
    WritePreferenceString("RB_img",       RemoveString(\RB_Img$, GetCurrentDirectory()))
    WritePreferenceString("Swatch",       RemoveString(\Swatch$, GetCurrentDirectory()))
    If \PathOpen$ = ""
      \PathOpen$ = "save\"
    EndIf
    WritePreferenceString("PathOpen",  RemoveString(\PathOpen$, GetCurrentDirectory()))
    If \PathSave$ = ""
      \PathSave$ = "save\"
    EndIf
    WritePreferenceString("PathSave", RemoveString(\PathSave$, GetCurrentDirectory()))
    WritePreferenceString("DirPresets", RemoveString(\DirPreset$, GetCurrentDirectory()))
    ; WritePreferenceString("FileBGcolor", RemoveString(\FileBGcolor$, GetCurrentDirectory()))
    
    ; Grid
    WritePreferenceInteger("Grid",          \Grid)
    WritePreferenceInteger("ToolbarFileY",  \ToolbarFileY)
    WritePreferenceInteger("ToolbarFileX",  \ToolbarFileX)
    WritePreferenceInteger("ToolbarToolY",  \ToolbarToolY)
    WritePreferenceInteger("ToolbarToolX",  \ToolbarToolX)
    WritePreferenceInteger("Statusbar",     \Statusbar)
    
    WritePreferenceInteger("DelayMax",      \DelayMax)
    
    WritePreferenceInteger("Maxundo",       \Maxundo)
    WritePreferenceInteger("ConfirmExit",   \ConfirmExit)
    WritePreferenceInteger("ModeAdvanced",   \ModeAdvanced)
    WritePreferenceInteger("UseRighmouseToPaint",   \UseRighmouseToPaint)
    WritePreferenceInteger("UseCanvas",   \UseCanvas)
    WritePreferenceInteger("UsePaperForRendering",   \UsePaperForRendering)
    
    ; autosave
    WritePreferenceInteger("autosave",      \Autosave)
    WritePreferenceInteger("autosaveTime",  \AutosaveTime)
    WritePreferenceInteger("autosaveAtExit",  \autosaveAtExit)
    WritePreferenceInteger("Filtering",     \SpriteQuality)
    
    WritePreferenceInteger("NbNewFile",     \NbNewFile)
    WritePreferenceInteger("NbMinutes",     \NbMinutes)
    
    ; UI show/hide
    WritePreferenceInteger("ShowPanelToolparameters", \ShowPanelToolparameters)
    WritePreferenceInteger("ShowPanelColors",         \ShowPanelColors)
    WritePreferenceInteger("ShowPanelLayers",         \ShowPanelLayers)
    WritePreferenceInteger("ShowPanelswatchs",        \ShowPanelswatchs)
    WritePreferenceInteger("ShowFullUI",              \ShowFullUI)

    
  EndWith
  
  ; SAve the position and size for some gadgets // on sauve ensuite les positions et tailles de certains gagets
  WritePreferenceInteger("PanelLayerH", PanelLayerH_IE)
  WritePreferenceInteger("PanelToolsH", PanelToolsH_IE)
  ;       PanelLayerW_IE  = ReadPreferenceInteger("PanelLayerW", 150)
  ;       PanelLayerH_IE  = ReadPreferenceInteger("PanelLayerH", 400)
  ;       PanelToolsW_IE  = ReadPreferenceInteger("PanelToolsW", 150)
  ;       PanelToolsH_IE  = ReadPreferenceInteger("PanelToolsH", 300)
  
  
  ;{ tools options
  
  ; gradient color, alpha and type
  ;     PreferenceGroup("Gradient")
  ;     With brush(#Action_Gradient)
  ;       WritePreferenceInteger("GradientBG", \Color)
  ;       WritePreferenceInteger("GradientFG", \ColorFG)
  ;       WritePreferenceInteger("GradientType", \Type)
  ;       WritePreferenceInteger("GradientBGAlpha", \alpha)
  ;       WritePreferenceInteger("GradientFGAlpha", \AlphaFG)
  ;     EndWith
  
  
  ;  save the paint tools parameters // puis on sauve les outils (brush, eraser et pen pour le moment, plus tard les autres
  For i = 0 To 2
    
    Select  i 
      Case 0
        theaction = #action_brush
        PreferenceGroup("Brush")
        
      Case 1 ;  eraser
        theaction = #Action_Eraser
        PreferenceGroup("Eraser")
        
      Case 2 ;  pen
        theaction = #Action_Pen
        PreferenceGroup("Pen")
        
    EndSelect
    
    With brush(theaction)
      
      WritePreferenceInteger("BrushImage",\Id)
      WritePreferenceInteger("BrushNum",  \BrushNum)
      WritePreferenceInteger("BrushForm", \BrushForm)
      WritePreferenceString("BrushDir",   RemoveString(\BrushDir$, GetCurrentDirectory()))
      
      ; size
      WritePreferenceInteger("size",    \Size)
      WritePreferenceInteger("sizeW",   \SizeW)
      WritePreferenceInteger("sizeH",   \SizeH)
      WritePreferenceInteger("sizeMin", \SizeMin)
      WritePreferenceInteger("sizePressure", \Sizepressure)
      
      ; alpha
      WritePreferenceInteger("alpha",     \Alpha)
      WritePreferenceInteger("alphablend",\AlphaBlend)
      WritePreferenceInteger("alphaFG",   \AlphaFG)
      WritePreferenceInteger("alphaPressure", \AlphaPressure)
      WritePreferenceInteger("alpharand", \AlphaRand)
      
      ; colors
      WritePreferenceInteger("visco",   \Visco)
      WritePreferenceInteger("mixing",  \Mix)
      WritePreferenceInteger("mixtyp",  \MixType)
      WritePreferenceInteger("mixlayer",  \MixLayer)
      WritePreferenceInteger("wash",  \wash)
      WritePreferenceInteger("lavage",  \wash)
      WritePreferenceInteger("water",   \Water)
      WritePreferenceInteger("color",   \Color)
      WritePreferenceInteger("colorFG", \ColorFG)
      
      ; dynamnics
      WritePreferenceInteger("scatter",   \Scatter)
      WritePreferenceInteger("randrotate",\randRot)
      WritePreferenceInteger("rotate",    \Rotate)
      WritePreferenceInteger("rotateangle",\RotateByAngle)
      
      ; parameters
      WritePreferenceInteger("pas",       \pas)
      WritePreferenceInteger("type",      \Type)
      WritePreferenceInteger("trait",     \Trait)
      WritePreferenceInteger("smooth",    \Smooth)
      WritePreferenceInteger("hardness",  \Hardness)
      
      ; shape
      WritePreferenceInteger("ShapeOutline", \ShapeOutline)
      WritePreferenceInteger("ShapeOutSize", \ShapeOutSize)
      WritePreferenceInteger("ShapePlain",   \ShapePlain)
      WritePreferenceInteger("ShapeType",    \ShapeType)
      WritePreferenceInteger("RoundX",       \RoundX)
      WritePreferenceInteger("RoundY",       \RoundY)
      
    EndWith
    
  Next i
  
  
  
  ; then I save the other tool parameters
  tool$ = "Pen,Brush,Spray,Stamp,Particles,Line,Box,Circle,Shape,Gradient,Fill,Text,Eraser,Clear,Pickcolor,Select,Move,Transform,Rotate,Hand,Zoom"
  
  For i = #Action_Spray To #Action_Zoom 
    
    If i <> #Action_Eraser
      theaction  = i
      PreferenceGroup(StringField(tool$,i+1,","))
      
      With Brush(theaction)
        WritePreferenceInteger("size", \Size)
        WritePreferenceInteger("type", \Type)
        WritePreferenceInteger("alpha", \Alpha)
        WritePreferenceInteger("alphablend", \AlphaBlend)
        WritePreferenceInteger("alphaFG", \AlphaFG)
        WritePreferenceInteger("color", \Color)
        WritePreferenceInteger("colorFG", \ColorFG)
        WritePreferenceInteger("ShapeOutline", \ShapeOutline)
        WritePreferenceInteger("ShapeOutSize", \ShapeOutSize)
        WritePreferenceInteger("ShapePlain", \ShapePlain)
        WritePreferenceInteger("ShapeType", \ShapeType)
        WritePreferenceInteger("RoundX", \RoundX)
        WritePreferenceInteger("RoundY", \RoundY)          
      EndWith
      
    EndIf
    
  Next
  
  ;}
  
  
  
EndProcedure
Procedure SaveOptions()
  
  If OpenPreferences("Pref.ini")
    
    WriteDefaultOption()
    
    ClosePreferences()
    
  Else
    
    If CreatePreferences("Pref.ini")
      
      WriteDefaultOption() 
      
      ClosePreferences()  
      
    EndIf
    
  EndIf
  
EndProcedure
Procedure CreateOptionsFile()
  
  Shared PanelToolsW_IE, PanelToolsH_IE, PanelLayerW_IE, PanelLayerH_IE, BarAnimH_IE 
  
  PanelToolsW_IE = 180
  PanelToolsH_IE = 287
  PanelLayerW_IE = 155
  PanelLayerH_IE = 379
  ToolbarToolX = 174
  
  
  If CreatePreferences("Pref.ini")
    WriteDefaultOption()
    ClosePreferences()
  EndIf
  
EndProcedure


; NEW document
; windowDocNew() in window.pbi


; OPEN
Procedure DocHasChanged()
  ; verify if the current docuemtn has changed (or current layer)
  
  For i = 0 To ArraySize(layer())
    If layer(i)\Haschanged
      LayerHasChanged = 1
      Break
    EndIf
  Next
  
  If OptionsIE\ImageHasChanged = 1 Or LayerHasChanged = 1
    
    answer =  MessageRequester(LAng("Infos"), 
                        lang("The document has changed. Do you want to save your progress ? If Not, you will lost your work."), 
                        #PB_MessageRequester_YesNoCancel|#PB_MessageRequester_Warning)
    Select answer
        
      Case #PB_MessageRequester_Yes 
        If Doc_Save() = 1
          ProcedureReturn 0
        Else
          MessageRequester(lang("Error"), LAng("Unable to save the current document"))
          ProcedureReturn 1
        EndIf
        
      Case #PB_MessageRequester_No 
        ProcedureReturn 0
        
      Case #PB_MessageRequester_Cancel    
        ProcedureReturn 1
        
    EndSelect
    
  EndIf
  
  ProcedureReturn 0 
  
EndProcedure

Procedure Doc_Open()
  
  Shared OpenLayer
  
  
  ; procedure to open a document.
  
  
  ; procedure pour ouvrir un document (animatoon old (abi), new, teo=, c'est à dire avec tous les calques, les paramètres, etc..
  
  ; first, we get the file to open.
  ; d'abord, on va chercher le fichier à ouvrir
  
  ; File$ = OpenFileRequester(Lang("Open Teo"), "", "Teo (*.teo)|*.teo|Abi (*.abi)|*.abi",0)
  ; Pattern$ = "All |*.jpg;*.png;*.bmp;*.ani;*.teo;*.abi"
  
  ; Pattern$ = "Files |*.txt;*.bat;*.pb;*.doc;*.png"
  
  
  
  If DocHasChanged() = 0
    
    
    ; open a document/image
    Pattern$ ="All Images format|*.jpg;*.png;*.bmp;*.abi;*.teo|JPG|*.jpg|PNG|*.png|BMP|*.bmp|"+
              "Ani (Animatoon document)|*.ani|Ani (Animatoon - Old version)|*.ani|Abi (old animatoon file)|*.abi|Teo (Tile editor organisation)|*.teo"
    
    
    File$ = OpenFileRequester("Open an image or an animatoon document", OptionsIE\PathOpen$, Pattern$, OptionsIE\OpenDocPatternPos) 
    Index = SelectedFilePattern()
    OptionsIE\OpenDocPatternPos = index
    
    Debug "index :"+ Str(Index)
    
    If File$ <> ""
      
      OptionsIE\PathOpen$ = GetPathPart(file$)
      
      
      CreateWindowInfo("Open document")
      
      ; we can erase the layers  
      Layer_FreeAll()
      ; ClearGadgetItems(#G_LayerList)
      
      ; change the variable OpenLayer
      OpenLayer = 1
      
      DocName$  = GetFilePart(File$, #PB_FileSystem_NoExtension)
      DocPath$  = GetPathPart(File$)
      Ext$      = LCase(GetExtensionPart(File$))
      Filemain$ = DocName$ + ".txt"
      NewName$ = RemoveString(File$,".ani")+".zip"
      OldName$ = File$
      
      Select Ext$
          
          
        Case "ani","abi","teo"
          
          If Ext$ = "abi"
            MessageRequester(lang("Info"), lang("Not implemented yet"))
          Else
            
            If Index  = 4 
              ;{ new file format : *.ani
              Debug "on dépacke le fichier " +  File$
              
              UseZipPacker()
              
              ZipFile$ = File$
              Debug ZipFile$
              
              ; Ne gérant pas la destination de la décompression on va créer un dossier de destination
              ; Ce dossier sera un sous dossier du dossier courrant de l'application
              ; Il portera le nom du fichier en cours de décompression
              
              ; Mémorisation du dossier à créer et sur lequel on se positionnera pour la décompression
              path$ = GetPathPart(ZipFile$)
              dirname$ = Mid(GetFilePart(ZipFile$), 1, Len(GetFilePart(ZipFile$))-Len(GetExtensionPart(ZipFile$))-1) + "_tmp_"
              Directory$ = path$ + dirname$
              Debug  "le répertoire dans lequel on va copier les éléments du zip : "+Directory$
              
              ; Création  du dossier de destination de la décompression
              Resultat=CreateDirectory(Directory$)
              
              If resultat = 1 
                Debug "on crée le répertoire "   
              EndIf
              
              ;Mémorisation du dossier de destination de la décompression
              ; CurrentDirectory$ = GetCurrentDirectory() + Directory$ + "\"
              CurrentDirectory$ = Directory$ + "\"
              
              
              Pack = OpenPack(#ZipFile, ZipFile$, #PB_PackerPlugin_Zip)
              Dim nom$(n)
              
              
              CurentDir$ = GetCurrentDirectory()
              
              ;Lecture séquentielle des entrées du fichier compressé
              If ExaminePack(#ZipFile) 
                
                While NextPackEntry(#ZipFile)
                  
                  PackEntryName$ = PackEntryName(#ZipFile)
                  Debug PackEntryName$
                  
                  Select PackEntryType(#ZipFile)
                      
                    Case #PB_Packer_File
                      SetCurrentDirectory(CurrentDirectory$)
                      
                      ; Création du ou des dossiers si inexistant
                      For i=1 To CountString(PackEntryName$, "/")
                        Directory$ = StringField(PackEntryName$, i, "/")
                        CreateDirectory(Directory$)
                        SetCurrentDirectory(CurrentDirectory$ + Directory$)
                      Next 
                      
                      SetCurrentDirectory(CurrentDirectory$)
                      ReDim nom$(n)
                      ; nom$(n) = PackEntryName$
                      UncompressPackFile(#ZipFile, PackEntryName$)
                      
                    Case #PB_Packer_Directory ;C'est un dossier contenant des sous dossiers
                      SetCurrentDirectory(CurrentDirectory$)
                      
                      ; Création du ou des dossiers si inexistant
                      For i=1 To CountString(PackEntryName$, "/")
                        Directory$ = StringField(PackEntryName$, i, "/")
                        CreateDirectory(Directory$)
                        SetCurrentDirectory(CurrentDirectory$ + Directory$)
                      Next
                      
                  EndSelect
                Wend 
              EndIf
              
              SetCurrentDirectory(CurentDir$)
              ; puis On ouvre le fichier texte
              Filemain$ = Directory$ + "/"+Filemain$
              ;}
            Else
              pack = 2
              Filemain$ = File$
            EndIf
            
            
            ; read the file and open the images
            If ReadFile(0, Filemain$) 
              
              If pack >=1 
                Debug "pack : "+Str(pack)
                
                Debug "on va lire le fichier"
                
                ; then we open the file
                While Eof(0) = 0
                  
                  event = WaitWindowEvent(1)
                  
                  line$ = ReadString(0)
                  info$ = StringField(line$, 1, "|")
                  
                  Debug info$
                  Select info$
                      
                    Case "Version"; la version du logiciel
                      
                      versionDoc = Val(StringField(line$, 2, "|")) 
                      VersionTeo = Val(OptionsIE\Version$) 
                      If VersionTeo > versionDoc  
                        ; MessageRequester(Lang("Info"), Lang("File outdated"))
                      EndIf
                      
                      
                    Case "Background"; info about the background (paper..)
                      
                      UpdateWindowInfo("Open doc : #Update the paper")

                      OptionsIE\Paper$ = StringField(line$, 2, "|")
                      paper\alpha = Val(StringField(line$, 3, "|"))
                      paper\scale = Val(StringField(line$, 4, "|"))
                      paper\intensity = Val(StringField(line$, 5, "|"))
                      paper\Color = Val(StringField(line$, 6, "|"))
                      ; update the background parameters
                      SetGadgetState(#G_paperScale, paper\scale)
                      SetGadgetText(#G_PaperScaleSG, Str(paper\scale))
                      SetGadgetState(#G_PaperAlpha, paper\alpha)
                      SetGadgetText(#G_PaperAlphaSG, Str(paper\alpha))
                      SetGadgetState(#G_PaperIntensity, paper\intensity)
                      SetGadgetText(#G_PaperIntensitySG, Str(paper\intensity))
                      ; SetGadgetState(#G_ListPaper, paper\intensity)
                      ; update the paper
                      PaperUpdate(2)
                      
                    Case "Image";  informations on the document
                      
                      doc\W = Val(StringField(line$, 2, "|"))
                      doc\H = Val(StringField(line$, 3, "|"))
                      
                      ; les calques
                      NB = Val(StringField(line$, 4, "|")) ; nbre de layers
                      LayerNb = 0
                      LayerIdMax = 0
                      OptionsIE\Zoom = Val(StringField(line$, 5, "|"))
                      If OptionsIE\Zoom <=0
                        OptionsIE\Zoom = 100
                      EndIf
                      canvasX = Val(StringField(line$, 6, "|"))
                      canvasY = Val(StringField(line$, 7, "|"))
                      
                    Case "LayerVecto" 
                      
                    Case "Layer"  
                      
                      UpdateWindowInfo("Open doc : #Add a layer: #"+StringField(line$, 2, "|"))

                      OptionsIE\LayerTyp = Val(StringField(line$, 17, "|"))
                      
                      Layer_Add()
                      
                      ; on redéfinit les infos des calques
                      With Layer(LayerId)
                        
                        \Name$     = StringField(line$, 2, "|")
                        \Alpha     = Val(StringField(line$, 3, "|"))
                        \BM        = Val(StringField(line$, 4, "|"))
                        \LockAlpha = Val(StringField(line$, 5, "|"))
                        \locked    = Val(StringField(line$, 6, "|"))
                        \LockMove  = Val(StringField(line$, 7, "|"))
                        \LockPaint = Val(StringField(line$, 8, "|"))
                        \ordre     = Val(StringField(line$, 9, "|"))
                        \View      = Val(StringField(line$, 10, "|"))                    
                        
                        \X         = Val(StringField(line$, 11, "|"))
                        \Y         = Val(StringField(line$, 12, "|"))                    
                        \W         = Val(StringField(line$, 13, "|"))                    
                        \H         = Val(StringField(line$, 14, "|"))                    
                        \Group     = Val(StringField(line$, 15, "|"))
                        \Link      = Val(StringField(line$, 16, "|"))
                        \Typ       = Val(StringField(line$, 17, "|"))
                        \Text$     = StringField(line$, 18, "|")
                        \CenterX   = Val(StringField(line$, 19, "|"))
                        \CenterY   = Val(StringField(line$, 20, "|"))                    
                        \MaskAlpha = Val(StringField(line$, 21, "|"))                    
                        \FontColor = Val(StringField(line$, 22, "|"))
                        \FontName$ = StringField(line$, 23, "|")
                        \FontSize  = Val(StringField(line$, 24, "|"))
                        \FontStyle = Val(StringField(line$, 25, "|"))
                        
                        \FontID = LoadFont(#PB_Any,\FontName$,\FontSize,\FontStyle)
                        
                        
                        If VersionDoc < VersionTeo 
                          imageloaded$ = DocPath$+DocName$+"_"+\name$+".png"         
                        Else                        
                          imageloaded$ = DocPath$+dirname$+"/"+DocName$+"_Layer"+Str(ArraySize(layer()))+".png"
                        EndIf
                        
                        temp =  LoadImage(#PB_Any, imageloaded$)
                        ;                       If pack <> 2 And pack >=1
                        ;                         Debug "on supprime le fichier : "+imageloaded$
                        ;                         ;DeleteFile(imageloaded$)
                        ;                       EndIf
                        
                        
                        
                        If temp = 0
                          reponse = MessageRequester("Error", "unable to load the image " + imageloaded$ + ".png. Do you want To open by yourself ?",#PB_MessageRequester_YesNo)     
                          If reponse = 6
                            Layer_importImage(0)
                          EndIf                  
                        EndIf
                        
                        If temp
                          
                          ; <-- test
                          ;                           FreeImage(layer(LayerId)\Image)
                          ;                           If canvasX <0
                          ;                             cx = -canvasX
                          ;                           EndIf
                          ;                           If canvasY <0
                          ;                             cy = -canvasY
                          ;                           EndIf
                          ;                        
                          ;                           layer(LayerId)\Image = GrabImage(temp, #PB_Any, cx, cy, GadgetWidth(#G_CanvasMain), GadgetHeight(#G_CanvasMain))
                          ; -->
                          
                          
                          ; copy image
                          ;                           If StartDrawing(ImageOutput(layer(LayerId)\Image))
                          ;                             DrawingMode(#PB_2DDrawing_AlphaBlend)
                          ;                             DrawAlphaImage(ImageID(temp),0,0)
                          ;                             StopDrawing()
                          ;                           EndIf     
                          ;                           FreeImage(temp)
                          
                          ; use image loaded
                          layer(LayerId)\Image = temp
                          
                          
                          If OptionsIE\UseCanvas
                            If layer(LayerId)\bm <> #Bm_Normal
                              Layer_ConvertToBm(LayerId)
                            EndIf
                          Else
                            Layer_UpdateSprite(LayerId) 
                          EndIf
                        
                        EndIf
                        
                        If \w =0 Or \h =0
                          \w =ImageWidth(layer(LayerId)\Image)
                          \h =ImageHeight(layer(LayerId)\Image)
                        EndIf
                        
                      EndWith
                      NewPainting = 1
                      ; Layer_Update(LayerId)
                      ScreenUpdate(1)
                      
                  EndSelect
                  
                Wend
                
                
              EndIf
              
              ; close // on ferme le fichier
              CloseFile(0)
              
              ; delete temporary folder // supprime le dossier temporaire
              If pack >= 1 And pack <> 2
                ;DeleteFile(Filemain$)
                DeleteDirectory(Directory$,"",#PB_FileSystem_Recursive)
              EndIf
              
              ; update list for layers
              Layer_UpdateList()
              
              
;               ; <--- temporaire test
;               doc\w = GadgetWidth(#G_CanvasMain)
;               doc\h = GadgetHeight(#G_CanvasMain)
;               canvasX = 0
;               canvasY = 0
;               ;--> 
              If OptionsIE\usecanvas =1
                OptionsIE\Zoom = 100
              EndIf
              
              
              ; I have to delete the sprite layer tempo and other sprite (the sprite for temporary operations) and re create it (because it has new size)
              RecreateLayerUtilities()
              
              
              ;  update  screen
              NewPainting =1
              ScreenUpdate(0)
              
            Else
              Debug "pas de fichier à lire : " +Filemain$
              MessageRequester(lang("Error"),lang("No file to open. Please with the old .ani format."))
              Layer_Add()
              
              ; I have to delete the sprite layer tempo (the sprite for temporary operations) and re create it (because it has new size)
              RecreateLayerUtilities()
              
            EndIf
            
            FreeArray(nom$())
            
          EndIf
          
        Case "jpg", "png", "bmp"
          ;{ on ouver une image 
          OpenLayer = 0
          tmp = LoadImage(#PB_Any, File$)
          Doc\w = ImageWidth(tmp)
          Doc\h = ImageHeight(tmp)
          
          
          Layer_Add()
          
          ; then draw the image
          If StartDrawing(ImageOutput(Layer(layerId)\Image))
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(ImageID(tmp),0,0)
            StopDrawing()
          EndIf 
          
          FreeImage2(tmp)
          
          ; I have to delete the sprite layer tempo and other sprite (the sprite for temporary operations) and re create it (because it has new size)
          RecreateLayerUtilities()
          
          
          ; on update la liste des calques
          Layer_UpdateList()
          ; on update le screen
          NewPainting =1
          ScreenUpdate(0)
          ;}
          
      EndSelect
      
      OpenLayer = 0
      
    EndIf 
    
    IE_StatusBarUpdate()
    If IsWindow(#win_autosave)
      CloseWindow(#win_autosave)
    EndIf
    
    
  EndIf

EndProcedure


; saving
Procedure SelectFormat(file$)
  
  Select GetExtensionPart(file$) 
    Case"png"
      format = #PB_ImagePlugin_PNG
    Case "jpg"
      format = #PB_ImagePlugin_JPEG
    Case "bmp"
      format = #PB_ImagePlugin_BMP 
  EndSelect
  
  ProcedureReturn format
EndProcedure
Procedure Doc_Save()
  
  ;p$ = SaveFileRequester(Lang("Save Document"),"","Teo (*.teo)",0)
  p$ = SaveFileRequester("Save Document", OptionsIE\PathSave$,"Ani (*.ani)",0)
  
  If p$<>"" 
    
    If GetFileExist(p$) = #True
      rep = MessageRequester(Lang("Info"), Lang("The file already exists. Do you want to overwrite it ?"), #PB_MessageRequester_YesNo|#PB_MessageRequester_Warning)
      If rep = #PB_MessageRequester_Yes
        ok = 1
      EndIf
    Else
      ok = 1
    EndIf 
    
    If ok = 0
      Doc_Save()
    Else
     
      zip$  = RemoveString(p$, ".ani")
      p$    = RemoveString(p$, ".ani")  + ".ani"    
      Name$ = GetFilePart(p$, #PB_FileSystem_NoExtension)    
      Path$ = GetPathPart(p$) 
      ; Dir$  = path$ + Name$
      
      Nb = ArraySize(Layer())
      
      ; If CreateDirectory(Dir$) : EndIf
      
      ;dir$ + "\"
      
      Dim FileToDelete$(0)
      
      UseZipPacker()   
      If CreatePack(0, p$)
        
        w_exp = Doc\W
        h_exp = Doc\H
        
        
        CreateWindowInfo("Save document")
        
        ; no more used
        ;         temp = CreateImage(#PB_Any, w_exp, h_exp, 32, #PB_Image_Transparent)
        
        ; I need to convert layers, to get the blendmode // je dois convertir les calques pour prendre en comte les blendmodes 
        For i =0 To Nb
          Layer_ConvertToBm(i)
        Next i
        
        ;{
        ; puis, je dessine tout sur une image temporaire, avant de la sauver et de la supprimer en mémoire.
        ;         If StartDrawing(ImageOutput(temp))
        ;           
        ;           DrawingMode(#PB_2DDrawing_AlphaChannel)
        ;           Box(0, 0, w_exp, h_exp,RGBA(0,0,0,0))
        ;           DrawingMode(#PB_2DDrawing_AlphaBlend)
        ;           
        ;           For i = 0 To nb
        ;             
        ;             If Layer(i)\View
        ;               Layer_Bm2(i) ; pour définir le drawingmode / blendmode
        ;                            ; j'utilise layer()\Imagetemp et non layer()\image car je dois prendre en comtpe le blendmode.
        ;               DrawAlphaImage(ImageID(Layer(i)\ImageTemp), 0, 0,Layer(i)\Alpha ) 
        ;             EndIf
        ;             
        ;           Next
        ;           
        ;           StopDrawing()
        ;           
        ;         EndIf 
        ;}
        
        File$ = RemoveString(p$,".ani")
        ; in old version, I was saving an image with all layers
        ;         nom$ = Name$ +".png"
        ;         SaveImage(temp, nom$, #PB_ImagePlugin_PNG)
        ;         AddPackFile(0, nom$, nom$)
        ;         
        ;         ; puis, on supprime les images créées, pour libérer de la mémoire.
        ;         FreeImage2(temp)
        ;         ; result = DeleteFile(nom$,#PB_FileSystem_Force)
        ;         FileToDelete$(0) = nom$
        
        ; delete the temprorary layer // puis, on supprime les images temporaire
        ;         For i =0 To ArraySize(layer())
        ;           FreeImage2(layer(i)\ImageTemp)
        ;         Next i
        
        ; on sauvegarde tous les layers
        For i = 0 To nb
          event = WaitWindowEvent(1)
          If IsImage(Layer(i)\Image)
            nom$ = Name$ + "_Layer"+ Str(i)+".png"
            ; update the window infos
            UpdateWindowInfo("SAVE : #Save layer Image : #"+nom$)
            
            ; save image
            SaveImage(Layer(i)\Image, nom$, #PB_ImagePlugin_PNG)
            AddPackFile(0, nom$, nom$)
            ; DeleteFile(nom$,#PB_FileSystem_Force)
            ; DeleteFile(GetCurrentDirectory()+nom$)
            ; MessageRequester("",GetCurrentDirectory()+nom$)
            n = ArraySize(FileToDelete$())+1
            ReDim FileToDelete$(n)
            FileToDelete$(n) = nom$
          EndIf
        Next
        
        ; Then, we save the text document // enfin, On sauvegarde le fichier texte
        nom$ = Name$ + ".txt"
        If OpenFile(0, Nom$)
          UpdateWindowInfo("SAVE : #Save text info")
          WriteStringN(0, "; Made By Animatoon ")
          WriteStringN(0, "Version|"+ OptionsIE\Version$+ "|")
          WriteStringN(0, "Background|"+ OptionsIE\Paper$+ "|"+Str(paper\alpha)+ "|"+Str(paper\scale)+ "|"+Str(paper\intensity)+ "|"+Str(paper\Color))
          
          image$ = "Image|"+Str(Doc\W)+"|"+Str(Doc\H)+"|"+Str(Nb)+"|"+Str(OptionsIE\Zoom)+"|"+Str(CanvasX)+"|"+Str(CanvasY)+"|"
          WriteStringN(0, Image$)
          
          For i = 0 To Nb
            
            With Layer(i)
              
              Label$ = "Layer|"
              
              Select \Typ
                  ;                 Case #Layer_TypBitmap
                  ;                   Typ$ = "Layer|"
                  ;                   
                  ;                 Case #Layer_TypText
                  ;                   Typ$ = "LayerText|"
                  ;                   
                Case #Layer_TypVecto
                  Label$ = "LayerVecto|"
                  
                Default
                  info$ = Label$  +  \Name$ + "|" + Str(\Alpha) + "|" + Str(\BM) + "|"
                  info$ + Str(\LockAlpha) + "|" + Str(\Locked) + "|" + Str(\LockMove)+ "|" + Str(\LockPaint)
                  info$ + "|" + Str(\ordre) + "|" + Str(\View) + "|" + Str(\X) + "|" + Str(\Y)+ "|"+ Str(\W) + "|" + Str(\H)+ "|"
                  info$ + Str(\Group)+"|"+Str(\Link)+"|"+Str(\Typ)+"|"+\Text$+"|"+Str(\CenterX)+"|"+Str(\CenterY)+"|"+Str(\MaskAlpha)+"|"
                  info$ + Str(\FontColor)+"|"+\FontName$+"|"+Str(\FontSize)+"|"+Str(\FontStyle)+"|"
                  
              EndSelect
              
              WriteStringN(0, info$)
              
            EndWith
            
          Next i
          
          CloseFile(0)
          
        EndIf
        
        AddPackFile(0, nom$, nom$)
        ClosePack(0)
        
        UpdateWindowInfo("SAVE : #Finish and clean up")
        
        DeleteFile(nom$, #PB_FileSystem_Force)
        For i =0 To n
          DeleteFile(FileToDelete$(i))
        Next 
        
        FreeArray(FileToDelete$())
        
        If IsWindow(#win_autosave)
          CloseWindow(#win_autosave)
        EndIf
    
        ProcedureReturn 1
      EndIf 
      
    EndIf 
    
  Else
     ProcedureReturn 0
    
  EndIf 
  
  
EndProcedure
Procedure ExportImage(auto=0)
  
  ; to export the image, the current layer
  ; pour exporter l'image, le calque actif
  
  If auto = 0
    filename$ = SaveFileRequester("Save Image","","png|*.png",0)
  EndIf
  
  If filename$ <>"" Or auto = 1
    
    If auto = 1
      filename$ = "save\autosav"+Str(Random(1000000))
    EndIf  
    
    For i=0 To ArraySize(layer())
      name$=filename$+"_Layer"+Str(i)+ ".png"
      If OptionsIE\SaveImageRT
        If IsImage(layer(i)\Image)
          SaveImage(Layer(i)\image, name$,#PB_ImagePlugin_PNG)
        EndIf 
      Else
        If IsSprite(layer(i)\Sprite)
          CopySprite(Layer(LayerId)\Sprite,#Sp_CopyForsave, #PB_Sprite_AlphaBlending)
          SaveSprite(#Sp_CopyForsave, name$,#PB_ImagePlugin_PNG)
          FreeSprite2(#Sp_CopyForsave)
        EndIf 
      EndIf
      
    Next i  
    
  EndIf
  
EndProcedure
Procedure.s ExportOnImage()
  
  ; export the image with all layers visible and background.
  filename$ = SaveFileRequester("Save Image","","jpg|*.jpg|png|*.png|bmp|*.bmp",0)
  
  If filename$ <>""      
    
    ; d'abord, on doit modifier l'image en fonction du blendmode
    For i = 0 To ArraySize(layer())
      With layer(i)
        If IsImage(\Image)
          If \view
            Layer_convertToBm(i)
          EndIf
        EndIf
      EndWith
    Next i
    
    If IsImage(#ImageExport)=0
      CreateImage(#ImageExport, doc\w, doc\h, 32, #PB_Image_Transparent)
    EndIf
    
    If StartDrawing(ImageOutput(#ImageExport))  
      ; erase the image (not usefull ?)
      DrawingMode(#PB_2DDrawing_AlphaChannel)
      Box(0,0,canvasW,canvasH,RGBA(0,0,0,0)) 
      
      ; draw the background ground
      DrawingMode(#PB_2DDrawing_AlphaBlend) 
      
      
      ; draw the paper
      If paper\alpha > 0 And OptionsIE\UsePaperForRendering
        ; the color
        Box(0, 0,  doc\w, doc\h, paper\color) 
      
        ; the background paper
        DrawAlphaImage(ImageID(#Img_PaperForMainCanvas), 0, 0, paper\alpha)
        
      EndIf
      
      For i=0 To ArraySize(layer())
        If layer(i)\view = 1
          Layer_bm2(i)
          ;DrawAlphaImage(ImageID(layer(i)\ImageTemp),0,0,layer(i)\alpha)
          If layer(i)\Bm = #bm_normal
            DrawAlphaImage(ImageID(layer(i)\Image),  layer(i)\x, layer(i)\y , layer(i)\Alpha)
          Else
            DrawAlphaImage(ImageID(layer(i)\ImageTemp), layer(i)\x, layer(i)\y , layer(i)\Alpha)
          EndIf
        EndIf
      Next i
      
      StopDrawing()
      
    EndIf
    
    ; we will save the image (all layers visibles) // on sauve ensuite l'image obtenue    
    Filtre = SelectedFilePattern() ; 0 = jpg, 1 = png, 2 = bmp
    
    ; set extension if needed
    Ext$ = GetExtensionPart(filename$)
    If (Ext$ <> "jpg" And filtre = 0)
      filename$ + ".jpg"
      Ext$ = ".jpg"
    EndIf  
    If (Ext$ <> "png" And filtre = 1) 
      filename$ + ".png"
      Ext$ = ".png"
    EndIf     
    If (Ext$ <> "bmp" And filtre = 2)
      filename$ + ".bmp"
      Ext$ = ".bmp"
    EndIf   
    
    ; set the format for image saving.
    Select filtre
      Case 0
        ; jpg
        format = #PB_ImagePlugin_JPEG
      Case 1
        ; png
        format = #PB_ImagePlugin_PNG
      Case 2 
        ; bmp
        format = #PB_ImagePlugin_BMP
    EndSelect
    
    ; result$ = RemoveString(filename$, ext$)
    
    ; save the image
    If ext$ = ".jpg" Or ext$ = "jpg"
      If SaveImage(#ImageExport, filename$, format, 8) = 0
         MessageRequester(LAng("Error"), Lang("Unable to save the canvas image")+" (jpg)")
      EndIf
    Else
      If SaveImage(#ImageExport, filename$, format) =0
        MessageRequester(LAng("Error"), Lang("Unable to save the canvas image")+" ("+ext$+")")
      EndIf
    EndIf
    
    
    ; free image
    FreeImage(#ImageExport)
        
    
  EndIf
  
  ProcedureReturn filename$
EndProcedure

Procedure.i CaptureScreenToImage(x.i, y.i, width.i, height.i)
  Protected TmpImage.i, srcDC.i, trgDC.i
  Protected BMPHandle.i, dm.Devmode
  
  ; Attention, windows only !!! :(
  
  srcDC = CreateDC_("DISPLAY", "", "", dm)
  trgDC = CreateCompatibleDC_(srcDC)
  BMPHandle = CreateCompatibleBitmap_(srcDC, width, height)
  
  RedrawWindow_(#Null,#Null,#Null,#RDW_INVALIDATE)
  
  SelectObject_( trgDC, BMPHandle)
  BitBlt_( trgDC, 0, 0, width, height, srcDC, x, y, #SRCCOPY)
  
  DeleteDC_( trgDC)
  ReleaseDC_( BMPHandle, srcDC)
  
  TmpImage.i = CreateImage(#PB_Any, width, height)
  If StartDrawing(ImageOutput(TmpImage))
    DrawImage(BMPHandle, 0, 0)
    StopDrawing()
  EndIf
  
  DeleteDC_(trgDC)
  ReleaseDC_(BMPHandle, srcDC)
  
  ProcedureReturn TmpImage
  
EndProcedure
Procedure MakeScreenshot(x,y,Width,Height,File.s) 
  hImage = CreateImage(#PB_Any,Width,Height,32)
  If hImage
    hDC    = StartDrawing(ImageOutput(hImage))
    If hDc
      DeskDC = GetDC_(GetDesktopWindow_()) 
      BitBlt_(hDC,0,0,Width,Height,DeskDC,x,y,#SRCCOPY) 
      ReleaseDC_(GetDesktopWindow_(),DeskDC)
      DrawImage(hImage,0,0)
      StopDrawing()
      If SaveImage(hImage, File) :EndIf
      FreeImage(hImage)
    EndIf
  EndIf
EndProcedure


Procedure testlayer(n)
   ;<-- need to be comment
  Debug "on update un ou des layers. Layerid : "+Str(n)
  For i = 0 To ArraySize(layer())
;     Debug "layer "+Str(i)+" nom : "+layer(i)\name$+" / image : "+Str(layer(i)\image)+" / imagetemp : "+Str(layer(i)\imagetemp)
;       Debug "layer "+Str(i)+" nom : "+layer(i)\name$+" / bm : "+Str(layer(i)\Bm)
    info$ = "layer "+Str(i)+" nom : "+layer(i)\name$+
            " / image : "+Str(layer(i)\image)+
            " / imagetemp : "+ Str(layer(i)\imagetemp)+
            " / sprite : "+Str(layer(i)\sprite)
    
    Debug info$  

  Next
  ;--> 
EndProcedure

Procedure File_SaveImage()
  
  ; d'abord, on sauvegarde l'image normal, avec les blendemode
  
  ; on va ensuite sauvegarder toutes les parties de l'image, en décalant les calques pour capturer 
  ; ce qu'on voit à l'écran, puis tout coller ensuite en une seule grosse image 
  ; si c'est plus gros que la taille de l'écran ^^
  
  If OptionsIE\UseCanvas
    
    ;{ export the canvas As image
    
    ;   ; update all if needed
    ;   UseCanvas = OptionsIE\usecanvas
    ;   OptionsIE\usecanvas = 1
    ;   
    ;   ; change the element
    ;   Layer_UpdateElementsForRenderingSystem()
    ; 
    ;   
    ;   ; save the image from the canvas
    ;   name$ = ExportOnImage()
    ;   
    ; ;   If UseCanvas = 0
    ; ;     FreeImage2(#Img_PaperForMainCanvas)
    ; ;   EndIf
    
    ExportOnImage()
    
    ;}
    
  Else
    
    ;{ then export the screen as image
    
    ;     OptionsIE\usecanvas = 0
    ;     Layer_UpdateElementsForRenderingSystem()
    ;     
    ;     If name$ = ""
    ;       name$ = "Img_"+Str(Random(1000000))+"_"
    ;     Else
    ;       ext$ = GetExtensionPart(name$)
    ;       name$ = RemoveString(name$,ext$)
    ;       name$ = RemoveString(name$,".")
    ;     EndIf
    
    name$ = SaveFileRequester("Save Image","","jpg|*.jpg|png|*.png|bmp|*.bmp",0)
    
    If name$ <>""  
      
      If GetFileExist(name$) = #True
        rep = MessageRequester(Lang("Info"), Lang("The file already exists. Do you want to overwrite it ?"), #PB_MessageRequester_YesNo|#PB_MessageRequester_Warning)
        If rep = #PB_MessageRequester_Yes
          ok = 1
        EndIf
      Else
        ok = 1
      EndIf 
      
      If ok = 0
        
        File_SaveImage()
        
      Else
        
        ;{ save the image
        
        ; get extension and name
        ext$ = GetExtensionPart(name$)
        name$ = RemoveString(name$, ext$)
        name$ = RemoveString(name$,".")
        
        ; calcul the number of parts for the image from screen.
        If doc\w > CanvasW
          NbPartX = Round(doc\w/CanvasW, #PB_Round_Up) -1 
        Else
          NbPartX = 0
        EndIf
        If doc\h > CanvasH
          NbPartY = Round(doc\h/CanvasH, #PB_Round_Up) -1 
        Else
          NbPartY = 0
        EndIf
        
        OldCanvasX = CanvasX
        OldCanvasY = CanvasY
        
        OldZoom = OptionsIE\Zoom
        OptionsIE\Zoom = 100
        
        ;Debug "on va sauver l'image issue du screen"
        
        ; create the sprite temporary of the size of the portions of the screen // on crée des sprites temporaires de la taille des écrans
        NbPart = (NbPartX+1) * (NbPartY+1)
        Dim TempoImg.i(NbPart)
        
        
        ;Debug "nbre de partie : "+Str(NbPartX)+"*"+Str(NbPartY)+"="+Str(NbPart)
        
        uu=0
        For i = 0 To NbPartX
          For j = 0 To NbPartY
            
            W = ScreenWidth()
            H = ScreenHeight()
            CheckIfInf2(doc\w, w)
            CheckIfInf2(doc\h, h)
            
            ; on va déplacer tous les calques en même temps, pour avoir toutes les parties de l'écran au complet :)
            CanvasX = - i*W
            CanvasY = - j*H
            
            ;Debug "position du canvas : "+Str(CanvasX)+"/"+Str(CanvasY)
            ; puis, j'update le screen
            If OptionsIE\UsePaperForRendering 
              ; on efface tout  
              ClearScreen(RGB(120,120,120))
              ; the paper
              PaperDraw()  
            Else
              ClearScreen(RGB(0,0,0))
            EndIf
            
            ; draw the layers and flipbuffers
            Layer_DrawAll(); tous les calques
            FlipBuffers(): ; affiche l'ecran
            
            
            ; grab the sprite, and save it as image.
            If GrabSprite(#Sp_ToSaveImage, 0, 0, w, h, #PB_Sprite_AlphaBlending)
              If SaveSprite(#Sp_ToSaveImage, "sprite__0__0.png", #PB_ImagePlugin_PNG)
                If LoadImage(#Img_saveImage, "sprite__0__0.png") 
                  ; CatchImage(#Img_saveImage, @tmpSprite) 
                  ;Debug "U : "+Str(u) + " sprite : "+Str(#Sp_ToSaveImage)+ "- Image : "+Str(#Img_saveImage)
                  ; TempoImg(u) = CatchImage(#PB_Any, @tmpSprite) 
                  TempoImg(uu) = CopyImage(#Img_saveImage, #PB_Any)
                  FreeImage(#Img_saveImage)
                EndIf
                FreeSprite(#Sp_ToSaveImage)
                uu+1
              EndIf
            EndIf
            
          Next j
        Next i  
        
        ; create finale image and draw on it with the parts of images // on créé l'image finale et on dessine dessus les bouts d'image)  
        If CreateImage(#Img_saveImage, doc\w, doc\h, 32, #PB_Image_Transparent)
          u=0
          If StartDrawing(ImageOutput(#Img_saveImage))
            DrawingMode(#PB_2DDrawing_AllChannels)
            Box(0,0,doc\w,doc\h,RGBA(0,0,0,255))
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            For i = 0 To NbPartX
              For j = 0 To NbPartY
                If IsImage(TempoImg(u))
                  DrawAlphaImage(ImageID(TempoImg(u)),i*w,j*h)
                Else
                  ;Debug "pas d'image en :"+Str(u)
                EndIf
                u+1
              Next j
            Next i
            StopDrawing()
          EndIf
          
          ; on sauve l'image
          ;Debug "on sauve l'image"
          savefile$ = name$+"_Screen."+ext$
          format = SelectFormat(savefile$)
          
          If SaveImage(#Img_saveImage,savefile$,format)=0
            MessageRequester("error","unable to save the part of the image screen !"+savefile$)
          EndIf
          
          ; puis on libère la mémoire
          FreeImage(#Img_saveImage)
          
        Else
          MessageRequester("Error", "unable to create the final image")
          
        EndIf
        
        For i = 0 To NbPart
          FreeImage2(TempoImg(i))
        Next i
        
        FreeArray(TempoImg())
        
        ; on supprime l'image temporaire
        DeleteFile("sprite__0__0.png")
        
        ; Then, set the variable for canvas position and zoom // et on rétablit le screen tel qu'il était
        CanvasX = OldCanvasX
        CanvasY = OldCanvasY
        OptionsIE\Zoom = OldZoom
        
        ;}
       
      EndIf
        
    EndIf
    
    ;}
    
  EndIf
  
  ;   ; update the rendering systeme if needed
  ;   If UseCanvas = 1
  ;     OptionsIE\usecanvas = usecanvas
  ;     Layer_UpdateElementsForRenderingSystem()
  ;   EndIf
  
EndProcedure

; Autosave (thread or not threaded)


Procedure AutoSaveThreaded(Parameter) ; with thread
  
  Repeat
    
    
    If OptionsIE\ImageHasChanged
      OptionsIE\ImageHasChanged = 0
      For i= 0 To ArraySize(layer())
        If layer(i)\Haschanged
          layer(i)\Haschanged = 0 
          Date$ = FormatDate("%yyyy_%mm_%dd", Date()) 
          ;Debug "save\AutoSave_"+Date$+"_"+layer(i)\Name$+"_"+Str(i)+".png"
          If SaveImage(layer(i)\Image, GetCurrentDirectory() + "save\AutoSave_"+Date$+"_"+layer(i)\Name$+"_"+Str(i)+".png",#PB_ImagePlugin_PNG)
          EndIf
        EndIf      
      Next i
      Delay(40000); toutes les minutes, on sauvegarde l'image, uniquement si elle a changée
    EndIf
    
    ; si elle n'a pas changé, on revérifie toutes les 10 s
    Delay(10000) ; mettre un délai ici pour éviter de bouffer le tps processeur
                 ;Debug "autosave"
    
  ForEver
  
EndProcedure

Procedure AutoSave()
  
  Shared AutosaveTimeStart
  
  ; autosave, not in a thread, there is an autosave function with thread if needed (in procedures.pb)
  If  OptionsIE\Autosave = 1
    
    autosavetime_ = ElapsedMilliseconds() - AutosaveTimeStart
    
    ; StatusBarText(0, 3, Str(autosavetime_)+"/"+Str(AutosaveTimeStart)+"/"+Str(ElapsedMilliseconds())+"/"+Str(OptionsIE\AutosaveTime)+"/")
    
    If autosavetime_ >= OptionsIE\AutosaveTime * 60000
      AutosaveTimeStart = ElapsedMilliseconds()
      
     CreateWindowInfo("AUTOSAVE")
      
      ; verify if a layer has changed
      For i = 0 To ArraySize(layer())
        If layer(i)\Haschanged <> 0
          LayerHasChanged = 1
          Break
        EndIf
      Next
          
      
      If OptionsIE\ImageHasChanged <> 0 Or LayerHasChanged = 1
        
        OptionsIE\ImageHasChanged = 0
        
        ;MessageRequester("infos", Str(autosavetime_)+"/"+Str(AutosaveTimeStart)+"/"+Str(ElapsedMilliseconds())+"/"+Str(OptionsIE\AutosaveTime)+"/")
        
        ; First, examine if directories exists // d'abord on vérifie que le dossier "save existe
        saveDir$ = GetCurrentDirectory()+"save\"
        If ExamineDirectory(0, GetCurrentDirectory(), "")
          ;           If IsDirectory(0) = 0
          ;             If CreateDirectory(saveDir$) = 0
          ;               MessageRequester(LAng("Error"), lang("Unable to create the 'save' directory."))
          ;               saveDir$ = GetCurrentDirectory()
          ;             EndIf
          ;           EndIf
          While NextDirectoryEntry(0)
            If DirectoryEntryType(0) = #PB_DirectoryEntry_Directory
              If DirectoryEntryName(0) = "save";"autosave"
                trouve = 1
              EndIf
            EndIf
          Wend 
          
          FinishDirectory(0)
        EndIf
        
        If trouve = 0
          If CreateDirectory(saveDir$) = 0
            MessageRequester(Lang("Error"), lang("Unable to create the 'save' directory."))
            saveDir$ = GetCurrentDirectory()
          EndIf
        EndIf
        
        ;Debug GetCurrentDirectory()
        ;Debug saveDir$
        
        ; create autosave if needed
        autosaveDir$ = saveDir$ 
        ;+"autosave\"
        ;Debug autosaveDir$
        ;         If ExamineDirectory(0, autosaveDir$, "")
        ;           If IsDirectory(0) = 0
        ;             If CreateDirectory(autosaveDir$) = 0
        ;               MessageRequester(LAng("Error"), lang("Unable to create the 'autosave' directory."))
        ;               autosaveDir$ =  GetCurrentDirectory()
        ;             
        ;             EndIf
        ;           Else
        ;             While NextDirectoryEntry(0)
        ;               If DirectoryEntryType(0) = #PB_DirectoryEntry_Directory
        ;                 If
        ;                 EndIf
        ;               EndIf
        ;             Wend 
        ;           EndIf
        ;           FinishDirectory(0)
        ;         Else
        ;           Debug "erreur examinedirectory "+
        ;         EndIf
        
        
        ; Debug autosaveDir$
        
        ; the save the image from layers
        For i= 0 To ArraySize(layer())
          
          If layer(i)\Haschanged
            layer(i)\Haschanged = 0 
            ; Debug "autosave !!! "
            Date$ = FormatDate("%yyyy%mm%dd", Date()) 
            
            ;Debug "save\AutoSave_"+Date$+"_"+layer(i)\Name$+"_"+Str(i)+".png"
            
            theAutosavedir$ = autosaveDir$ ; GetCurrentDirectory() + "save\autosave\"
            
            ; check if we have still an autosavefilename$
            If OptionsIE\AutosaveFileName$ = ""
              OptionsIE\AutosaveFileName$ = theAutosavedir$+"AutoSave_"+Doc\name$+"_"+Str(OptionsIE\NbNewFile)+"_"+Str(Random(100000))+Date$
            EndIf
            
            UpdateWindowInfo("AUTOSAVE : #Save layer Image : #"+layer(i)\Name$)
            
            
            If SaveImage(layer(i)\Image,  optionsIE\AutosaveFileName$ +"_"+layer(i)\Name$+"_"+Str(i)+".png", #PB_ImagePlugin_PNG)
              ; Debug LAng("ok save image layer "+layer(i)\Name$)
            Else
              ; Debug LAng("Error") +" /"+ lang("Unable To save the 'autosave' image layer : "+layer(i)\Name$)
              ; add a log error !!
              AddLogError(1, lang("Unable To save the 'autosave' image layer : "+layer(i)\Name$))
            EndIf
            
          EndIf
          
        Next i
        
        ; Debug Str(AutosaveTimeStart)+"/"+ Str(autosavetime)+"/"+ElapsedMilliseconds()+"/"+Str(AutosaveTimeStart + OptionsIE\AutosaveTime * 60000)
        
        ; Delay(40000 * OptionsIE\AutosaveTime); toutes les 5 minutes, on sauvegarde l'image, uniquement si elle a changée
        
      EndIf
      
      If IsWindow(#win_autosave)
        CloseWindow(#win_autosave)
      EndIf
      
      
      ; reset the clic/paint variable
      Paint = 0
      clic = 0
      MouseClic = 0
      
    EndIf
    
  EndIf
  
EndProcedure


;}

;{ editions
Procedure Edit_Copy()
  
  ; first free the selection image
  FreeImage2(#img_selection)
  
  ; define parameters for the iumage copy
  x = OptionsIE\SelectionX
  y = OptionsIE\SelectionY
  w = OptionsIE\SelectionW
  h = OptionsIE\SelectionH
  If w=0 Or h=0
    w= ImageWidth(layer(layerid)\Image)
    h= ImageHeight(layer(layerid)\Image)
  EndIf
  
  ; grab the image
  tmp = GrabImage(layer(layerid)\Image, #PB_Any, X, Y, W, H)
  Layer(layerId)\Haschanged = 1
  
  ;Select OptionsIE\SelectionType
      
    ;Case #selectionRectangle
      ;SetClipboardImage(tmp)
      
    ;Case #selectionCircle, #selectionRectangle
      ; because we can cut a portion of an image with selection
      ; we have to create an "selection image"
      If OptionsIE\Selection > 0
        If CreateImage(#img_selection, w, h, 32, #PB_Image_Transparent)
          If StartDrawing(ImageOutput(#img_selection))
            
            ; draw the selection on alpha
            DrawingMode(#PB_2DDrawing_AllChannels)
            Layer_DrawSelection(0, 0, RGBA(0,0,0,255))
            
            ; draw the image tmp
            DrawingMode(#PB_2DDrawing_CustomFilter)
            CustomFilterCallback(@Filtre_AlphaSel()) 
            DrawAlphaImage(ImageID(tmp), 0, 0)
            
            StopDrawing()
          EndIf
        EndIf
      EndIf

  ;EndSelect
  
  If OptionsIE\Selection = 0 And Not IsImage(#img_selection)
    SetClipboardImage(tmp)
    FreeImage2(tmp)
  EndIf
  
EndProcedure
Procedure Edit_Paste()
  
  If OptionsIE\Selection = 0 And Not IsImage(#img_selection)
    tmp = GetClipboardImage(#PB_Any, 32)
  Else
    tmp = #img_selection
  EndIf

  If tmp
    
    ; variable needed
    x = 0
    y = 0
    Z.d = OptionsIE\Zoom * 0.01
    
    ; check if we have selected first something or not
    If OptionsIE\Selection = 2
      OptionsIE\Selection = 0
      x = OptionsIE\SelectionX ;* z
      y = OptionsIE\SelectionY ;* z
    EndIf
    
    ; add a new layer to paste the clipboardimage
    Layer_Add()
    
    ; then draw on this layer
    If StartDrawing(ImageOutput(layer(LayerId)\Image))
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      DrawAlphaImage(ImageID(tmp),x,y)
      StopDrawing()
    EndIf
    
    ; update
    Newpainting = 1
    ScreenUpdate()
    
    ; free image if needed
    If OptionsIE\Selection = 0 And Not IsImage(#img_selection)
      FreeImage(tmp)
    EndIf
    
    
  EndIf
  
EndProcedure

Procedure Edit_Select(selectAll=1)
  
  ; reset some selection parameters
  OptionsIE\Selection = 1-selectAll
  OptionsIE\SelectionType = 0
  
  OptionsIE\SelectAlpha = 0
  
  OptionsIE\SelectionX = 0
  OptionsIE\SelectionY = 0
  OptionsIE\SelectionW = doc\w
  OptionsIE\SelectionH = doc\h
  
  ScreenUpdate()
  
EndProcedure

Procedure ResizeDoc(canvas=0)
  
  ; If OpenWindow(#Win_ResizeDoc,
  
  ; need To be changed by a window to resize the doc (like to create a new doc)
  w = Val(InputRequester("Width","New Width of the Document", ""))
  h = Val(InputRequester("Height","New Height of the Document", ""))
  oldW = doc\w
  oldH = doc\h
  
  If w*h >= 3000*3000
    rep = MessageRequester("Info","The new size will be big. Continue ?",#PB_MessageRequester_YesNo)
  Else 
    ok = 1
  EndIf
  
  If rep = #PB_MessageRequester_Yes Or ok =1
    
    ok =0
    
    If w >= 1
      ok = 1
      doc\w = w
    EndIf
    If  h >= 1
      ok = 1
      doc\h = h
    EndIf
    
    If oldW > doc\w Or oldH > doc\h
      
      rep = MessageRequester("Info","The new size is smaller than the original, The image will be cropped. Continue ?",#PB_MessageRequester_YesNo)
      
      If rep = #PB_MessageRequester_Yes     
        ok = 1
      Else
        ok = 0
      EndIf
      
    EndIf
    
    If ok
      
      
      ;Debug "On va redimensionner. New size : "+Str(doc\w)+"/"+Str(doc\h)
      
      
      n = ArraySize(layer())
      n1 = (n+1)*10 +20
      ;Debug "nb layer : "+Str(n)
      StatusBarProgress(#Statusbar,3,5,#PB_StatusBar_BorderLess,0,n1)
      
      If canvas = 0  
        
        ; resize the document size //  on agrandit le document, on redimensionne 
        
        For i=0 To n
          
          StatusBarProgress(#Statusbar, 3, (i+1)*10,#PB_StatusBar_BorderLess,0,n1)
          
          ; on redimensionne nos calques (images et bm)
          If IsImage(layer(i)\ImageTemp)
            ResizeImage(layer(i)\ImageTemp,doc\w,doc\h)
          EndIf
          ResizeImage(layer(i)\Image,doc\w,doc\h)
          If IsImage(layer(i)\ImageBM)
            ResizeImage(layer(i)\ImageBM,doc\w,doc\h)
          EndIf
          
          FreeSprite(layer(i)\Sprite)
          Layer(i)\Sprite = CreateSprite(#PB_Any,doc\w,doc\h,#PB_Sprite_AlphaBlending)
          Layer(i)\w = doc\w
          Layer(i)\h = doc\h
          Layer(i)\NewW = doc\w
          Layer(i)\NewH = doc\h
          Layer_UpdateSprite(i)
        Next i 
        
      Else 
        ;{ Resize the canvas // on agrandit/diminue la surface de travail 
        
        ;Debug "canvas resize ! "
        
        StatusBarProgress(#Statusbar, 3, 5)
        
        ; on crée des images temporaires, on va dessiner dessus chaque calque image et calque BM
        ; puis, on effacera les calque (image et bm) et on redessinera l'image orginal 
        ; (non agrandie, car on ne fait qu'agrandir le canvas, pas l'image complète
        
        Tmp = CreateImage(#PB_Any,doc\w,doc\h,32,#PB_Image_Transparent)
        TmpBm = CreateImage(#PB_Any,doc\w,doc\h,32,#PB_Image_Transparent)
        
        If Tmp > 0 And TmpBm > 0
          
          For i=0 To n
            
            ;Debug i
            
            StatusBarProgress(#Statusbar, 3, (i+1)*10,#PB_StatusBar_BorderLess,0,n1)
            
            ; d'abord, on sauve les images et imageBm
            If StartDrawing(ImageOutput(Tmp))
              DrawingMode(#PB_2DDrawing_AllChannels)
              Box(0,0,doc\w,doc\h,RGBA(0,0,0,0))
              DrawingMode(#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(ImageID(layer(i)\Image),0,0)
              StopDrawing()          
            EndIf
            If StartDrawing(ImageOutput(TmpBm))
              DrawingMode(#PB_2DDrawing_AllChannels)
              Box(0,0,doc\w,doc\h,RGBA(0,0,0,0))
              DrawingMode(#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(ImageID(layer(i)\ImageBM),0,0)
              StopDrawing()          
            EndIf
            
            ; puis, on redimensionne nos calques (images et bm)
            ResizeImage(layer(i)\Image,doc\w,doc\h)
            If StartDrawing(ImageOutput(layer(i)\Image))
              DrawingMode(#PB_2DDrawing_AllChannels)
              Box(0,0,doc\w,doc\h,RGBA(0,0,0,0))
              DrawingMode(#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(ImageID(Tmp),0,0)
              StopDrawing()          
            EndIf
          
            ; puis, on les efface et on redessine dessus
            If IsImage(layer(i)\ImageBM)
              ResizeImage(layer(i)\ImageBM,doc\w,doc\h)
              
              If StartDrawing(ImageOutput(layer(i)\ImageBM))
                DrawingMode(#PB_2DDrawing_AllChannels)
                Box(0,0,doc\w,doc\h,RGBA(0,0,0,0))
                DrawingMode(#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(ImageID(TmpBm),0,0)
                StopDrawing()          
              EndIf
            EndIf
            
            ; change sprite
            FreeSprite2(layer(i)\Sprite)
            layer(i)\Sprite = CreateSprite(#PB_Any,doc\w,doc\h,#PB_Sprite_AlphaBlending)
            
            Layer(i)\w = doc\w
            Layer(i)\h = doc\h
            
            Layer_UpdateSprite(i)
            ;Debug "size : " +Str(ImageWidth(layer(layerid)\Image))+"/"+Str(layer(layerId)\Image)
          Next i 
          
          ; on supprime les images temporaires
          
          FreeImage2(Tmp)
          FreeImage2(TmpBm)
          
        EndIf  
        
        ;}
        
      EndIf  
      
      
      ; I have to delete the sprite layer tempo (the sprite for temporary operations) and other sprite and re create it (because it has new size)
      RecreateLayerUtilities()

      
    EndIf
    
    NewPainting = 1
    StatusBarProgress(#Statusbar, 3, n1-10,#PB_StatusBar_BorderLess,0,n1)
    ScreenUpdate(1)
    StatusBarProgress(#Statusbar, 3, n1,#PB_StatusBar_BorderLess,0,n1)
    IE_StatusBarUpdate()
    
    ;Debug "New size : "+Str(doc\w)+"/"+Str(doc\h)
    
  EndIf
  
EndProcedure
Procedure CropDoc()
  
  x = OptionsIE\SelectionX
  y = OptionsIE\SelectionY
  w = OptionsIE\SelectionW
  h = OptionsIE\SelectionH
  
  If w > 0 And h > 0 And w-x>0 And h-y>0
    
    Doc\w = w ; - x
    Doc\h = h ; - y
    
    ;Debug Str(x)+"/"+Str(y)
    
    ;x - canvasX
    ;y - canvasY
    
    w1 = doc\w
    h1 = doc\h
    
    n = ArraySize(layer())
    n1 = (n+1)*10 +20
    StatusBarProgress(#Statusbar,3,5, #PB_StatusBar_BorderLess,0,n1)
    
    StatusBarProgress(#Statusbar, 3, 5)
    
    ; on crée des images temporaires, on va dessiner dessus chaque calque image et calque BM
    
    For i=0 To n
      
      StatusBarProgress(#Statusbar, 3, (i+1)*10,0,0,n1)
      
      tmp = GrabImage(layer(i)\Image,#PB_Any,x,y,w1,h1)
;       If IsImage(layer(i)\ImageBM)
;         ;tmpBM = GrabImage(layer(i)\ImageBM,#PB_Any,x,y,w1,h1)
;       EndIf
      
      If Tmp > 0 ;And TmpBm > 0
        FreeImage2(layer(i)\Image)
        FreeImage2(layer(i)\ImageBM)
        
        layer(i)\Image = GrabImage(tmp,#PB_Any,0,0,w1,h1)
        ; layer(i)\ImageBM = GrabImage(tmpBM,#PB_Any,0,0,w1,h1)
        
        ;{ old
        ;             ; d'abord, on sauve les images et imageBm
        ;             If StartDrawing(ImageOutput(Tmp))
        ;               DrawingMode(#PB_2DDrawing_AllChannels)
        ;               Box(0,0,doc\w,doc\h,RGBA(0,0,0,0))
        ;               DrawingMode(#PB_2DDrawing_AlphaBlend)
        ;               DrawAlphaImage(ImageID(layer(i)\Image),x,y)
        ;               StopDrawing()          
        ;             EndIf
        ;             If StartDrawing(ImageOutput(TmpBm))
        ;               DrawingMode(#PB_2DDrawing_AllChannels)
        ;               Box(0,0,doc\w,doc\h,RGBA(0,0,0,0))
        ;               DrawingMode(#PB_2DDrawing_AlphaBlend)
        ;               DrawAlphaImage(ImageID(layer(i)\ImageBM),x,y)
        ;               StopDrawing()          
        ;             EndIf
        ;             
        ;             ; puis, on redimensionne nos calques (images et bm)
        ;             ResizeImage(layer(i)\Image,doc\w,doc\h)
        ;             ResizeImage(layer(i)\ImageBM,doc\w,doc\h)
        ;             
        ;             ; puis, on les efface et on redessine dessus
        ;             If StartDrawing(ImageOutput(layer(i)\Image))
        ;               DrawingMode(#PB_2DDrawing_AllChannels)
        ;               Box(0,0,doc\w,doc\h,RGBA(0,0,0,0))
        ;               DrawingMode(#PB_2DDrawing_AlphaBlend)
        ;               DrawAlphaImage(ImageID(Tmp),0,0)
        ;               StopDrawing()          
        ;             EndIf
        ;             If StartDrawing(ImageOutput(layer(i)\ImageBM))
        ;               DrawingMode(#PB_2DDrawing_AllChannels)
        ;               Box(0,0,doc\w,doc\h,RGBA(0,0,0,0))
        ;               DrawingMode(#PB_2DDrawing_AlphaBlend)
        ;               DrawAlphaImage(ImageID(TmpBm),0,0)
        ;               StopDrawing()          
        ;             EndIf
        ;             
        ;}
        
        
        FreeSprite2(layer(i)\Sprite)
        layer(i)\Sprite = CreateSprite(#PB_Any,w1,h1,#PB_Sprite_AlphaBlending)
        
        Layer(i)\w = doc\w
        Layer(i)\h = doc\h
        
        Layer_UpdateSprite(i)
        ;Debug "size : " +Str(ImageWidth(layer(layerid)\Image))+"/"+Str(ImageHeight(layer(layerId)\Image))
        ; on supprime les images temporaires
        FreeImage2(Tmp)
        FreeImage2(TmpBm)
      EndIf
      
    Next i 
    
    ; I have to delete the sprite layer tempo (the sprite for temporary operations) and other sprite and re create it (because it has new size)
    RecreateLayerUtilities()

    
    ; puis, on met à jour
    NewPainting = 1
    StatusBarProgress(#Statusbar, 3, n1-10,#PB_StatusBar_BorderLess,0,n1)
    ScreenUpdate(1)
    StatusBarProgress(#Statusbar, 3, n1, #PB_StatusBar_BorderLess,0,n1)
    IE_StatusBarUpdate()
    
    
  EndIf
  
  
  OptionsIE\SelectionX =0
  OptionsIE\SelectionY =0
  OptionsIE\Selection =0
  OptionsIE\SelectionW =0
  OptionsIE\SelectionH =0
  DisableMenuItem(0, #menu_Crop, 1)
  
  
EndProcedure

Procedure TrimDoc(img,crop=0)
  
  w=ImageWidth(img)
  h=ImageHeight(img)
  
  Dim x(3)
  x(0) = w
  x(1) = h
  
  If StartDrawing(ImageOutput(img))
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    ; calcul dimension to crop image without alpha border // on calcule x et Y et W et H pour recadrer l'image en enlevant les bordures alpha.
    For u=0 To 3    
      For i =0 To w-1
        For j=0 To h-1
          
          col=Point(i,j)        
          If Alpha(col) >0
            
            Select u 
                
              Case 0 ; x
                If i < x(0)
                  x(0) = i
                  If i=0
                    Break
                  EndIf
                EndIf 
                
              Case 1 ; y
                If j < x(1)
                  x(1) = j
                  If j=0
                    Break
                  EndIf
                EndIf 
                
              Case 2 ; w
                If i > x(2)
                  x(2) = i
                  If i=w-1
                    Break
                  EndIf                
                EndIf 
                
              Case 3 ; h
                If j > x(3)
                  x(3) = j
                  If j=h-1
                    Break
                  EndIf                
                EndIf 
                
            EndSelect
          EndIf
          
        Next
      Next
    Next
    StopDrawing()
  EndIf
  
  If crop=0
    tempimg = GrabImage(img,#PB_Any,x(0),x(1),x(2)-x(0),x(3)-x(1))  
    ProcedureReturn tempimg 
  Else     
    OptionsIE\SelectionX = x(0)
    OptionsIE\SelectionY = x(1)
    OptionsIE\SelectionW = x(2)-x(0)
    OptionsIE\SelectionH = x(3)-x(1)
    CropDoc()    
  EndIf
  
  
  
EndProcedure
;}

;{ selection

Procedure SelectionSet()
  
  ; not finished
  
  If StartDrawing(ImageOutput(layer(layerId)\Image))
    
    
    StopDrawing()
  EndIf
  
  
EndProcedure


;}

; Layers : see layer.pbi


; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 2402
; FirstLine = 21
; Folding = AAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAA--BAAAAAAw
; EnableXP
; Executable = ..\..\animatoon0.52.exe
; EnableUnicode