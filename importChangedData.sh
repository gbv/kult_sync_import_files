#!/bin/bash

# get import files from nfis
denkxport --limit=100 --no-purge --skip-images

# clean up import files, sync with last imports
bash /opt/digiverso/kult_sync_import_files/syncFiles.sh

# move images to hotfolder and
#movemedia

#set right permissions
#chownmedia

# move import files to hotfolder
movedenkx

# monitor hotfolder and start new import when last one is done
#bash /opt/digiverso/kult_sync_import_files/monitorHotfolder.sh importChanged

# monitor hotfolder and restart tomcat when last import is done
#bash /opt/digiverso/kult_sync_import_files/monitorHotfolder.sh restartTom
