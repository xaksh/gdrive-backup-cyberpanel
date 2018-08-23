#!/bin/bash

# Assign values to parameters that will be used in Script
# Update G_ID value with Google Drive Directory ID
DATE="$(date +%Y-%b-%d)"
G_ID=""
BACKUP_DIR="/home/backups"

echo "~~~~~~~~~~~~~~ Starting BACKUP ~~~~~~~~~~~~~~"
echo $DATE
# Clean old Backup Directory and Journal Files and create fresh backup directory
rm -rf /home/*/backup/* /var/log/journal/*/*.journal $BACKUP_DIR && mkdir -p "$BACKUP_DIR/$DATE"
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
time /usr/local/bin/gdrive upload --recursive --parent $G_ID $BACKUP_DIR/$DATE
wait

# Remove backup directory
time rm -rf $BACKUP_DIR
wait

exit
