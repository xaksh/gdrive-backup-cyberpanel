#!/bin/bash

# Run cron.sh
source /root/gdrive-backup-cyberpanel/cron.sh

# Download gdrive Binary from https://github.com/prasmussen/gdrive and Run Below commands
# For Linux 64-bit
wget -O gdrive "https://docs.google.com/uc?id=0B3X9GlR6EmbnQ0FtZmJJUXEyRTA&export=download"
wait
sudo install gdrive /usr/local/bin/gdrive
wait

# Link your Google Account to gdrive-cli
gdrive about
wait

