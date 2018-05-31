#!/bin/bash

# Assign values to parameters that will be used in Script
# Update G_ID value with Google Drive Directory ID
DATE="$(date +%Y-%b-%d)"
G_ID=""
BACKUP_DIR="/home/backups"

# Clean old Backup Directory and Journal Files and create fresh backup directory
rm -rf /home/*/backup/* /var/log/journal/*/*.journal /home/$BACKUP_DIR && mkdir -p "/home/$BACKUP_DIR/$DATE"
wait

# Run CyberPanel's Local Backup Script
python /usr/local/CyberCP/plogical/backupScheduleLocal.py
wait

# Copy tar.gz backup files to directory gdrivebackup
mv /home/*/backup/*.tar.gz "/home/$BACKUP_DIR/$DATE"
wait

# Upload backup files to respected Directory in Google Drive
/usr/local/bin/gdrive upload --recursive --parent $G_ID /home/$BACKUP_DIR/$DATE
wait

# Remove backup directory
rm -rf /home/$BACKUP_DIR
wait

exit
