#!/bin/bash

# Set Server Hostname and Host Node in Backup Script passed in the arguments
sed -i s/^SERVER_HOSTNAME=.*/SERVER_HOSTNAME=$1/ /root/gdrive-backup-cyberpanel/backup.sh
sed -i s/^NODE=.*/NODE=$2/ /root/gdrive-backup-cyberpanel/backup.sh

# Run cron.sh for adding cronjob
bash /root/gdrive-backup-cyberpanel/cron.sh "$3"

# Install rclone https://rclone.org
curl https://rclone.org/install.sh | sudo bash
wait

# Link your Google Account to rclone by creating New Remote
rclone config
wait


