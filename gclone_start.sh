#!/bin/sh
# RCLONE UPLOAD CRON TAB SCRIPT 
# chmod a+x /home/plex/scripts/rclone-upload.sh
# Type crontab -e and add line below (without #) and with correct path to the script
# * * * * * /home/plex/scripts/rclone-upload.sh >/dev/null 2>&1
# if you use custom config path add line bellow in line 20 after --log-file=$LOGFILE 
# --config=/path/rclone.conf (config file location)
# echo "process name: gclone_start.sh"
if pidof -o %PPID "gclone_start.sh"; then
  # echo "killing my self as gclone_start.sh is running "
   exit 1
fi

#get from path 

# /usr/bin/gclone ls niefamilydrive:/poorna
#LOGFILE="/home/poorna/rclone_copy/rclone-upload.log"
# LOGFILE="/home/poorna/rclone_copy/logs.log"
# FROM="/mnt/6tbhdd/plex"
# TO="/mnt/rclone/Media"

FROM=$from_path
TO=$to_path
#TO="gdrivecrypt:/"

# CHECK FOR FILES IN FROM FOLDER THAT ARE OLDER THAN 15 MINUTES
if find $FROM* -type f -mmin +15 | read
  then
  start=$(date +'%s')
  echo "$(date "+%d.%m.%Y %T") RCLONE UPLOAD STARTED" | tee -a $LOGFILE
  # MOVE FILES OLDER THAN 15 MINUTES 
  #rclone move "$FROM" "$TO" --transfers=20 --checkers=20 --delete-after --min-age 15m --log-file=$LOGFILE
  # /usr/bin/gclone --help
  /usr/bin/gclone copy "$FROM" "$TO" --ignore-existing  --min-age 15m  --log-level=INFO --log-file="/tmp/aa.txt"
  #cp -r "$FROM" "$TO"
  cat /tmp/aa.txt
  rm /tmp/aa.txt
  echo "$(date "+%d.%m.%Y %T") RCLONE UPLOAD FINISHED IN $(($(date +'%s') - $start)) SECONDS" | tee -a $LOGFILE
fi

exit
