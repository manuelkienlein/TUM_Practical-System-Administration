#!/bin/bash

# ----------------------------------------
#         Postgres Database Backup        
#
#
# Required packages:
#   apt install tree postgresql-client-12
# ----------------------------------------


# ===== CONFIGURATION =====

TARGET_LOCATION="/mnt/storage/backup/postgres"
RETENTION_DAYS=7

SQL_HOSTNAME="127.0.0.1"
SQL_USERNAME="backup"
SQL_PASSWORD="<password>"
SQL_PORT="3306"


# ===== DO NOT MODIFY BELOW =====

TIMESTAMP=$(date +%Y-%m-%d)
TARGET=$TARGET_LOCATION/$TIMESTAMP

# -- Methods

create_backup() {
	# Setup
	export PGPASSWORD=$SQL_PASSWORD
	
	echo "Preparing backup directory"
	mkdir -p $TARGET
	
	# Get a list of all databases
	echo "Fetching list of available databases"
	databases=`su - postgres -c "psql -l -t | cut -d'|' -f1 | sed -e 's/ //g' -e '/^$/d'"`

	# Dump each database into a seperate file
	echo "Creating backup of all databases"
	for database in $databases; do
		if [ "$database" != "template0" ] && [ "$database" != "template1" ] && [ "$database" != "template_postgis" ]; then
			echo Dumping $database to $TARGET/$database.sql
			pg_dump -F c -h $SQL_HOSTNAME -p $SQL_PORT -U $SQL_USERNAME $database > $TARGET/$database.sql
		fi
	done

	echo "Backup completed"
}

restore_backup() {
	echo "*** Restore backup from $1 *** "
	read -p "Database name: " restore_database_name
	read -p "Database user (postgres): " restore_database_user
	read -p "Database host (primary 192.168.8.2): " restore_database_host
	read -p "Database port (3306): " restore_database_port
	su - postgres -c "pg_restore -d ${restore_database_name} -U ${restore_database_user} -h ${restore_database_host} -p ${restore_database_port} -F custom -c ${TARGET}/$1/${restore_database_name}.sql"
}

list_backups() {
	tree $TARGET_LOCATION
}

delete_backup() {
	folder=$TARGET_LOCATION/$1
	echo "Deleting backups in $folder"
	rm -rf $folder
}

rotate_backups() {
	echo "Rotating backups for $RETENTION_DAYS days"
	find $TARGET_LOCATION/* -type d -mtime +$RETENTION_DAYS | xargs rm -rf
}

clear_backups() {
	echo "Deleting backups in $TARGET_LOCATION"
	rm -rf $TARGET_LOCATION
	mkdir $TARGET_LOCATION
}

# -- Main

case "$1" in

backup)
	create_backup
;;
restore)
	if [ -z "$2" ]
	then
		  echo "Usage: ./db-backup.sh restore <Backup-Date>"
	else
		  restore_backup $2
	fi
;;
list)
	list_backups
;;
delete)
	if [ -z "$2" ]
	then
		  echo "Usage: ./db-backup.sh delete <Backup-Date>"
	else
		  delete_backup $2
	fi
;;
rotate)
	rotate_backups
;;
clear)
	clear_backups
;;
esac
