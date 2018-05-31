#!/bin/bash

# Assign values to parameters that will be used in Script
# Edit root MySQL password in DB_USER_PASSWORD parameter
DATE="$(date +%Y-%b-%d)"
DB_USER="root"
DB_USER_PASSWORD="password"
DB_BACKUP_DIR="/home/backups/$DATE/databases"

# Delete old Databases backups and create fresh database directory
rm -rf $DB_BACKUP_DIR && mkdir -p $DB_BACKUP_DIR > /dev/null 2>&1

# Start Database backup
databases=`mysql -u $DB_USER -p$DB_USER_PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != "cphulkd" ]] && [[ "$db" != "roundcube" ]] && [[ "$db" != "leechprotect" ]] && [[ "$db" != "modsec" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump -u $DB_USER -p$DB_USER_PASSWORD --databases $db > $DB_BACKUP_DIR/$DATE.$db.sql
    fi
done
