# TrEd-bridge
[![DOI](https://zenodo.org/badge/150578265.svg)](https://zenodo.org/doi/10.5281/zenodo.10604322)

Program to act as a bridge between [TrEd treebank-editor](https://ufal.mff.cuni.cz/tred/) and [Alpino parser](https://www.let.rug.nl/vannoord/alp/Alpino/). 

## warning!
Do not use the CHAT/Alpino editor on files already edited in TrEd. This is currently unsupported, and the editor will fail to launch. Open a file, use the CHAT/Alpino editor if necesarry and THEN continue editing in TrEd. This will be fixed soon.

## Installing
- In Tred, select `Setup` -> `Manage Extensions...`  
- In the menu, uncheck any Alpino mode for Tred extensions currently enabled  
- Select `Edit Repositories`  
- Select `Add`  
- For Repository URL, enter `http://dhstatic.hum.uu.nl/tred/extensions/`. Click OK. Close this menu  
- Select `Get New Extensions`. A few warnings errors concerning other Tred Extensions may pop up. Select the first option (skip) for each of these  
- In the window `Install New Extensions`, search for 'Alpino' and check the 'install' checkbox for this extension, and select `Install Selected`  
- In `Manage Extensions` menu, enable the Alpino package you just installed  
- Quit and restart Tred once to reload the extension  
- You are now ready to use the extension

## Building distributable
Run the scrip `build.sh` to build a new distribution in `./dist`.

## Updating
- In Tred, select `Setup` -> `Manage Extensions...`  
- In the menu select `Check Updates`  
- If no entires are displayed here, there are no updates available 
- Check the box for the `Alpino Plus` extensions  
- Select `Install Selected`  
- Close the menu and restart TrEd

## Usage 
This extension adds a single macro: `Launch CHAT/Alpino Editor`. This program takes the file currently open in TrEd as input, and allows editing of utterance, sentence, CHAT-annotations and Alpino input. After editing, click `Save & Exit` to automatically return to TrEd. 
