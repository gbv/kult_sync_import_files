#!/bin/bash

# get import files from nfis
# denkxport --limit=100 --no-purge --skip-images
sudo /usr/bin/php /opt/digiverso/kult_dma_object_importer/run.php  --limit=100 --no-purge --skip-images

# clean up import files, sync with last imports
bash /opt/digiverso/kult_sync_import_files/syncFiles.sh

# move images to hotfolder and
# movemedia
# find /opt/digiverso/viewer/coldfolder/ -maxdepth 1 -type d -name '*_media' -print0 | xargs -0 -I {} sudo mv {} /opt/digiverso/viewer/hotfolder/

# set right permissions
# chownmedia
# find /opt/digiverso/viewer/hotfolder/ -maxdepth 1 -mindepth 1 -print0 | xargs -0 sudo chown -R tomcat:tomcat

# move import files to hotfolder
# movedenkx
find /opt/digiverso/viewer/coldfolder/ -maxdepth 1 -mindepth 1 -type f -print0 | xargs -0 -I {} sudo mv {} /opt/digiverso/viewer/hotfolder/

# monitor hotfolder and start new import when last one is done
#bash /opt/digiverso/kult_sync_import_files/monitorHotfolder.sh importChanged

# monitor hotfolder and restart tomcat when last import is done
#bash /opt/digiverso/kult_sync_import_files/monitorHotfolder.sh restartTom
