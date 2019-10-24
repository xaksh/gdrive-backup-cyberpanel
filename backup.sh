#!/bin/bash

# Assign values to parameters that will be used in Script
DATE="$(date +%Y-%m-%d)"
SERVER_HOSTNAME=
NODE=

# Clean old Backup and Journal Files
rm -rf /home/*/backup/* /var/log/journal/*/*.journal
wait

echo "~~~~~~~~~~~~~~ Starting BACKUP Creation and Upload to Google Drive ~~~~~~~~~~~~~~"
echo $DATE
start=$SECONDS
ls -1 /home -Icyberpanel -Idocker -Ibackup -Ilscache -Ivmail | while read user; do
cyberpanel createBackup --domainName $user > /dev/null
sleep 45
rclone copy /home/$user/backup gdrive:basezap"$NODE"nodebackups/$SERVER_HOSTNAME/$DATE/$user
wait
# Clean backup directory
rm -rf /home/$user/backup/*
wait
done
echo "~~~~~~~~~~~~~~ Backup Creation and Upload to Google Drive Finished ~~~~~~~~~~~~~~"
duration=$(( SECONDS - start ))
echo "Total Time Taken $duration Seconds"

exit
