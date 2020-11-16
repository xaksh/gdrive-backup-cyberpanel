# cyberpanel-backups-upload-to-gdrive
Automate Creation and Uploading of CyberPanel Backups to Google Drive using rclone and send email notifications.

1) Install and Setup SSMTP on CyberPanel Server
   [Steps to install and configure SSMTP](https://www.basezap.com/send-an-email-from-cli-using-smtp-in-linux/).

2) Clone this repo in /root directory of the server with directory name gdrive-backup-cyberpanel using following Command
 
 > git clone https://github.com/xaksh/gdrive-backup-cyberpanel -b jbc+email gdrive-backup-cyberpanel
 
 or you can use wget to download Zip Archive and Extract.
 
 > wget 'https://github.com/xaksh/gdrive-backup-cyberpanel/archive/jbc+email.zip'

 > unzip -j jbc+email.zip -d gdrive-backup-cyberpanel

3) Run setup.sh with Server Hostname, Host Node, Cron Job Time and email details as arguments.

 > cd gdrive-backup-cyberpanel

 > source setup.sh "server.hostname.com" "swift" "30 5 * * *" "notify@domain.com" "From: Backups<backups@domain.com>" "To: notify@domain.com"

   server.hostname.com = Server's Hostname where Backup Script will run or Primary Domain Name
   
   swift = Host Node name
   
   30 5 * * * = Backup Upload Script will run daily @5:30 AM

   notify@domain.com = Email address where notifications will be sent

   'From: Backups<backups@domain.com>' = Email addresses of the SMTP Sender for setting headers

   'To: notify@domain.com' = Email address of notification reciever for setting headers

   Example: 
 > source setup.sh "swift.basezap.com" "swift" "30 5 * * *" "sys-admin@basezap.com" "From: Backups<backups@basezap.com>" "To: sys-admin@basezap.com"

4) rclone will ask to create a new remote. Make remote for Google drive with "gdrive" as remote name without qoutes.
