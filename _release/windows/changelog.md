## Animatoon Version 0.5.9.0 (pre-release 24 march 2021) : 

# New
- Background (paper) editor : preview paper image and names, color, alpha, scale.
- Menu/layer : transform image into line, to convert a drawing in black line.
- Picker tool : all layers or selected layer.
- Gradient : save/load now the colors and alpha (in the pref.ini)
- Options (pref.ini) : a lot of parameters have been added to the pref.ini to save/load options.
- new brush images
- new tool presets
- new papers
- add : autosave, and option (AutoSaveIfQuit, message ConfirmExit...)
- OpenGL version is ok (need to create a release special)
- add a logError file, to know the errors if needed

# Changes / improvements
- tool zoom : some changes and new parameters (zoom center, zoom on mouse (still wip))
- language system improved. We should get by default always a word in the UI. The menu language is updated in real time if we change the langage (need to add the gadgets now)
- some improvements in options save/load (relative path for swatch, roughboard, presets...)
- when import an image, it create now a new layer
- other minor changes and improvements (check if some images exists...)

#  Bugfixes
- Bug paper is we open an image with height > width. 
- New doc, open doc, resize, crop, trim... : didn't update the temporary layer
- Bug with shaped if we have changed the size of the document.
- Newdoc : didn't free the image od the lapha mask of layer 0
- several bugfixes with "merge layer"
- Bug layer merge-bottom and Blendmode (not used when merge). 
- when we paint, preview image for layer isn't updated.
- Size and position of the container-screen isn't ok
- gradient and shape : bug if we create and move the canvas (is drawn several times)
- when close the app, the paths of the bank (for brush presets) isn't saved 
- CTRL+x (cut) and copy (CTRL+c) didn't copy the selected area or layer
- paste didn't work 
- the clipboard image isn't used.
- Bug spingadgets (panel brush, tra, dyn, color..) we cant' write a number > 99
- various minor bugfixes and improvements