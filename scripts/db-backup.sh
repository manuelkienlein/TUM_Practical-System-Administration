#!/bin/bash

TARGET="/mnt/storage/backup/postgres"

SQL_HOSTNAME="127.0.0.1"
SQL_USERNAME="backup"
SQL_PASSWORD="<password>"
SQL_PORT="3306"

TIMESTAMP=$(date +%Y-%m-%d)
TARGET=$TARGET/$TIMESTAMP

case "$1" in

backup)

echo "Creating backup of all databases"

# Setup
mkdir -p $TARGET

# Shutdown database
#systemctl stop postgresql

# Create backup
#pg_dumpall -h localhost -p 3306 -U backup > /var/backups/postgres/test6.sql

export PGPASSWORD="<password>"

# Get a list of all databases
databases=`su - postgres -c "psql -l -t | cut -d'|' -f1 | sed -e 's/ //g' -e '/^$/d'"`

# Dump each database into a seperate file
for database in $databases; do
    if [ "$database" != "template0" ] && [ "$database" != "template1" ] && [ "$database" != "template_postgis" ]; then
    echo Dumping $database to $TARGET/$database.sql
    pg_dump -F c -h $SQL_HOSTNAME -p $SQL_PORT -U $SQL_USERNAME $database > $TARGET/$database.sql
    fi
done

echo "Backup completed"

# Start database
#systemctl start postgresql
;;
restore)

su - postgres -c "pg_restore -d sql1_batman -U postgres -h 192.168.8.2 -p 3306 -F custom -c /var/backups/postgres/2022-11-23/sql1_batman.sq>

;;
clear)
rm -rf /var/backups/postgres
;;
esac
