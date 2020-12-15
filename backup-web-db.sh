#!/bin/bash
# Change domain per domain
USERNAME=
DOMAIN=
#RCLONE REMOTE LOCATION
RCLONEDRIVE=gdrive-backup                     # Name for rclone drive
RCDWEB=$RCLONEDRIVE:$DOMAIN/WEB               # Web backup folder
RCDDB=$RCLONEDRIVE:$DOMAIN/DB                 # DB backup folder
#EXCLUDE=folder-name
###
TIME=`date +\%F-%HH-%mM-%SS`                    # This Command will read the date.
FILENAME=$DOMAIN-$TIME.tar.gz                   # The filename including the date.
DBNAME=$DOMAIN-DB-$TIME.zip                     # The DB name including the date.
SRCDIR=/home/$USERNAME/webapps/$DOMAIN           # Source backup folder.
DESDIR=/home/$USERNAME/backups/$DOMAIN/WEB       # Destination of backup file.
DESDIRDB=/home/$USERNAME/backups/$DOMAIN/DB      # Destination of DB backup file.

# WEB LOCATION BACKUP
if [ -d "$DESDIR" ]; then
  ### Take action if $DIR exists ###
  #tar -cpzf $DESDIR/$FILENAME --exclude "$EXCLUDE" $SRCDIR
  tar -cpzf $DESDIR/$FILENAME $SRCDIR
  rclone copy $DESDIR/$FILENAME $RCDWEB
else
  ###  Control will jump here if $DIR does NOT exists ###
  mkdir -p /home/$USERNAME/backups/$DOMAIN/WEB
  #tar -cpzf $DESDIR/$FILENAME --exclude "$EXCLUDE" $SRCDIR
  tar -cpzf $DESDIR/$FILENAME $SRCDIR
  rclone copy $DESDIR/$FILENAME $RCDWEB
fi

# DB LOCATION BACKUP
# Change current directory to WP install to export DB
cd $SRCDIR
wp db export    # Basic WP-Cli export command

if [ -d "$DESDIRDB" ]; then
  ### Take action if $DIR exists ###
  mv *.sql $DESDIRDB
  # Change directory to zip sql file
  cd $DESDIRDB
  zip -m $DESDIRDB/$DBNAME *.sql
  rclone copy $DESDIRDB/$DBNAME $RCDDB
else
  ###  Control will jump here if $DIR does NOT exists ###
  mkdir -p /home/$USERNAME/backups/$DOMAIN/DB
  mv *.sql $DESDIRDB
  # Change directory to zip sql file
  cd $DESDIRDB
  zip -m $DESDIRDB/$DBNAME *.sql
  rclone copy $DESDIRDB/$DBNAME $RCDDB
fi
