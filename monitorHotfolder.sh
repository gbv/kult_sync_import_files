#!/bin/bash
startTime=$(date +"%Y-%m-%d_%H-%M-%S")
hotfolderPath="/opt/digiverso/viewer/hotfolder/"

countFiles=`find $hotfolderPath -type f -print | wc -l`
startFiles=$countFiles

# clear line
echo -e "\033[2K"

while [ $countFiles != 0 ]
do
  countFiles=`find $hotfolderPath -type f -print | wc -l`
  echo -ne "Dateien im Hotfolder: "$countFiles'\r'
  sleep 5s
done

if [ $# -eq 0 ]
then
  bashCall="monitor starts with no param"
else
  bashCall=$1

  case $1 in

    "restartTom")
      systemctl restart tomcat9.service
      ;;

    "silentRestartTom")
      systemctl restart tomcat9.service >/dev/null 2>&1
      ;;

    "importChanged")
      /usr/bin/php /opt/digiverso/kult_dma_object_importer/run.php required
      ;;

    "silentImportChanged")
      /usr/bin/php /opt/digiverso/kult_dma_object_importer/run.php required  >/dev/null 2>&1
      ;;

    *)
      bashCall="unknown: "$1
      ;;

  esac
fi

endTime=$(date +"%Y-%m-%d_%H-%M-%S")

recipient="goobi-viewer-support@lists.gbv.de"
#recipient="tilo.neumann@gbv.de"
sender="no-reply@gbv.de"
subject="[goobi-viewer] [Denkmalatlas] Hotfolder Status"
body="<p>Number of Files in Hotfolder when Monitor starts: "$startFiles"</br>"
body=$body"Start Time: "$startTime"</br>"
body=$body"Bash Call: "$bashCall"</br>"
body=$body"End Time: "$endTime"</p>"

# For HTML emails, add the following line
MIME="MIME-Version: 1.0\nContent-Type: text/html\n"

echo -e "To: $recipient\nFrom: $sender\nSubject: $subject\n$MIME\n\n$body" | sendmail -t
