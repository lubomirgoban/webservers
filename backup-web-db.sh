#!/bin/bash
# Change domain per domain
DOMAIN=YOUR-DOMAIN
###
TIME=`date +\%F-%HH-%mM-%SS`                                # This Command will read the date.
FILENAME=$DOMAIN-$TIME.tar.gz                   # The filename including the date.
DBNAME=$DOMAIN-DB-$TIME.zip
SRCDIR=/home/runcloud/webapps/$DOMAIN    # Source backup folder.
DESDIR=/home/runcloud/backups/$DOMAIN/WEB       # Destination of backup file.
DESDIRDB=/home/runcloud/backups/$DOMAIN/DB      # Destination of DB backup file.

if [ -d "$DESDIR" ]; then
  ### Take action if $DIR exists ###
  tar -cpzf $DESDIR/$FILENAME $SRCDIR
  rclone copy $DESDIR/$FILENAME gdrive-backup:$DOMAIN
else
  ###  Control will jump here if $DIR does NOT exists ###
  mkdir -p /home/runcloud/backups/$DOMAIN/WEB
  tar -cpzf $DESDIR/$FILENAME $SRCDIR
  rclone copy $DESDIR/$FILENAME gdrive-backup:$DOMAIN
fi

# Change current directory to WP install to export DB
cd $SRCDIR
wp db export

if [ -d "$DESDIRDB" ]; then
  ### Take action if $DIR exists ###
  mv *.sql $DESDIRDB
  # Change directory to zip sql file
  cd $DESDIRDB
  zip -m $DESDIRDB/$DBNAME *
  rclone copy $DESDIRDB/$DBNAME gdrive-backup:$DOMAIN
else
  ###  Control will jump here if $DIR does NOT exists ###
  mkdir -p /home/runcloud/backups/$DOMAIN/DB
  mv *.sql $DESDIRDB
  # Change directory to zip sql file
  cd $DESDIRDB
  zip -m $DESDIRDB/$DBNAME *
  rclone copy $DESDIRDB/$DBNAME gdrive-backup:$DOMAIN
fi
