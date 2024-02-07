#!/bin/bash
startTime=$(date +"%Y-%m-%d_%H-%M-%S")
logFile="/opt/digiverso/kult_sync_import_files/logs/synchronized."$startTime".log"
importFiles="*.xml"
importFilePath="/opt/digiverso/viewer/coldfolder/"
indexedFilesPath="/opt/digiverso/viewer/orig_denkxweb/"

countAll=0
countUnchanged=0
countChanged=0
countNew=0
countImportFiles=`find $importFilePath -type f -print | wc -l`

if [ "$countImportFiles" -gt 0 ] 
then
# for each import file
for currentFile in $importFilePath$importFiles
do
  let countAll++
  echo -ne $countAll'/'$countImportFiles'\r'
  currentFileName=$(basename $currentFile)
  currentObjectID=$(basename $currentFile .xml)
  currentMediaDirectory=$importFilePath$currentObjectID"_downloadimages"
  echo $currentFileName >> $logFile
  indexedFile=$indexedFilesPath$currentFileName

  # check if indexed files exists
  if test -f "$indexedFile" 
  then  
     echo "-- Indexed file exists." >> $logFile
    # check if import and index file are from the same size
    if $indexedFileExists cmp -s "$currentFile" "$indexedFile" 
    then
      let countUnchanged++
      # we do not need the same files and want to clear the import from them
      echo "---- No differences detected." >> $logFile   
      # delete the import file and its media directory
      echo "---- Delete import file and its media directory."  >> $logFile
      echo $(rm -v $currentFile)  >> $logFile
      echo $(rm -v -rf $currentMediaDirectory)  >> $logFile
    else
      let countChanged++
      echo "---- Differences detected." >> $logFile
      echo $(diff $indexedFile $currentFile) >> $logFile
    fi
  else
    let countNew++
    echo "-- New File detected." >> $logFile
  fi
done
fi
# write report  
echo "---------------------------------" >> $logFile
echo "Files in Coldfolder: "$countImportFiles >> $logFile  
echo "Checked Importfiles: "$countAll >> $logFile  
echo "Unchanged:           "$countUnchanged >> $logFile  
echo "Changed:             "$countChanged >> $logFile  
echo "New:                 "$countNew >> $logFile

#send email report
recipient="goobi-viewer-support@lists.gbv.de"
sender="no-reply@gbv.de"
subject="[goobi-viewer] [Denkmalatlas] WFS Import Status"
body="<p>Files in Coldfolder: "$countImportFiles"</br>"
body=$body"Checked Importfiles: "$countAll"</br>"
body=$body"Unchanged:           "$countUnchanged"</br>"
body=$body"Changed:             "$countChanged"</br>"
body=$body"New:                 "$countNew"</p>"

# For HTML emails, add the following line
MIME="MIME-Version: 1.0\nContent-Type: text/html\n"

echo -e "To: $recipient\nFrom: $sender\nSubject: $subject\n$MIME\n\n$body" | sendmail -t
