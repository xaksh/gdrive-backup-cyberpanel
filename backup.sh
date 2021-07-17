#!/bin/bash

# Assign values to parameters that will be used in Script
DATE="$(date +%Y-%m-%d)"
SERVER_HOSTNAME=
NODE=
NOTIFY_TO=
FROM=
TO=
MID="$(</dev/urandom tr -dc "A-Za-z0-9" | head -c26)"

#Set the PATH variable
export PATH=

# Suppress Python Warnings
export PYTHONWARNINGS="ignore:Unverified HTTPS request"

# Clean old Backup and Journal Files
rm -rf /home/*/backup/* /var/log/journal/*/*.journal
wait

echo "~~~~~~~~~~~~~~ Starting BACKUP Creation and Upload to Google Drive ~~~~~~~~~~~~~~"
echo $DATE
start=$SECONDS
ls -1 /home -Icyberpanel -Idocker -Ibackup -Ilscache -Ivmail | while read user; do
cyberpanel createBackup --domainName $user > /dev/null 2>> /root/gdrive-backup-cyberpanel/user.log
sleep 5
if [[ -f /home/$user/backup/status ]]; then
	while ! grep "Completed" /home/$user/backup/status > /dev/null;do sleep 60;done
		rclone copy /home/$user/backup/status gdrive:basezap"$NODE"nodebackups/$SERVER_HOSTNAME/$DATE/$user > /dev/null 2>> /root/gdrive-backup-cyberpanel/user.log
		rclone copy /home/$user/backup/*.tar.gz gdrive:basezap"$NODE"nodebackups/$SERVER_HOSTNAME/$DATE/$user > /dev/null 2>> /root/gdrive-backup-cyberpanel/user.log
		# Remove backup file
		rm -f /home/$user/backup/* > /dev/null 2>> /root/gdrive-backup-cyberpanel/user.log
		wait
else
	echo "Missing Backup Status File" >> /root/gdrive-backup-cyberpanel/user.log
        if [[ -s /root/gdrive-backup-cyberpanel/user.log ]]; then
		echo -e "$TO\n$FROM\nMessage-ID: <$MID@bz>\nSubject: Backup Failed - $SERVER_HOSTNAME\n\n$user Backup Failed" | ssmtp $NOTIFY_TO
	fi
fi
# Update temp.log with user.log
cat /root/gdrive-backup-cyberpanel/user.log >> /root/gdrive-backup-cyberpanel/temp.log
# Remove user log file
rm -f /root/gdrive-backup-cyberpanel/user.log
wait
done
if [[ -s /root/gdrive-backup-cyberpanel/temp.log ]]; then
     echo -e "$TO\n$FROM\nMessage-ID: <$MID@bz>\nSubject: Backup Failed - $SERVER_HOSTNAME\n\nFull Backup Failed and Incomplete" | ssmtp $NOTIFY_TO
else
     echo -e "$TO\n$FROM\nMessage-ID: <$MID@bz>\nSubject: Backup Success - $SERVER_HOSTNAME\n\nFull Backup Success" | ssmtp $NOTIFY_TO
fi
# Update temp.log in back.log and remove temp log file
cat /root/gdrive-backup-cyberpanel/temp.log >> /root/gdrive-backup-cyberpanel/backup.log && rm -f /root/gdrive-backup-cyberpanel/temp.log
echo "~~~~~~~~~~~~~~ Backup Creation and Upload to Google Drive Finished ~~~~~~~~~~~~~~"
duration=$(( SECONDS - start ))
echo "Total Time Taken $duration Seconds"

# Remove backup directories
rm -rf /home/*/backup/*

exit
