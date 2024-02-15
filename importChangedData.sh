#!/bin/bash

# get import files from wsl
/usr/bin/php /opt/digiverso/kult_dma_object_importer/run.php full 10000000 cold

# clean up import files, sync with last imports
bash /opt/digiverso/kult_sync_import_files/syncFiles.sh

# move images to hotfolder
find /opt/digiverso/viewer/coldfolder/ -name "*_downloadimages" -type d -print0 | xargs -0 -I % mv % /opt/digiverso/viewer/hotfolder/

# move import files to hotfolder
find /opt/digiverso/viewer/coldfolder/ -name "*.xml" -print0 | xargs -0 -I % mv % /opt/digiverso/viewer/hotfolder/

# monitor hotfolder and start new import when last one is done
bash /opt/digiverso/kult_sync_import_files/monitorHotfolder.sh importChanged

# monitor hotfolder and restart tomcat when last import is done
bash /opt/digiverso/kult_sync_import_files/monitorHotfolder.sh restartTom
