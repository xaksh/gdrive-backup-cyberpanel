#!/bin/bash

# Assign values to parameters that will be used in Script
DATE="$(date +%Y-%m-%d)"
BACKUP_DIR="/backup"
SERVER_HOSTNAME=
NODE=

echo "~~~~~~~~~~~~~~ Starting BACKUP ~~~~~~~~~~~~~~"
echo $DATE

# Clean old Backup Directory and Journal Files and create fresh backup directory
rm -rf /home/*/backup/* /var/log/journal/*/*.journal && mkdir -p "$BACKUP_DIR/$DATE"
wait

# Run CyberPanel's Local Backup Script
echo "Starting CybperPanel Backup Script"
time python /usr/local/CyberCP/plogical/backupScheduleLocal.py
wait

# Copy tar.gz backup files to directory gdrivebackup
echo "Copying tar balls to Backup Directory"
mv /home/*/backup/*.tar.gz "$BACKUP_DIR/$DATE"
wait

# Upload backup files to respected Directory in Google Drive
echo "Uploading Backup tar balls to Google Drive"
time rclone copy $BACKUP_DIR/$DATE gdrive:basezap"$NODE"nodebackups/$SERVER_HOSTNAME/$DATE
wait

# Remove backup directory
time rm -rf $BACKUP_DIR/$DATE
wait

exit
