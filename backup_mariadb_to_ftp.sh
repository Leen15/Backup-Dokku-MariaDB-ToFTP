#!/bin/bash

CONTAINER=$1   #Container name in first parameter
BACKUP_PATH=$2 #FTP backup path in second parameter


HOST=          #This is the FTP servers host or IP address.
USER=          #This is the FTP user that has access to the server.
PASS=          #This is the password for the FTP user.

DBS="$(dokku mariadb:list $CONTAINER)"

#echo "${OUTPUT}"

# Check if local and remote $today_path exists.
today=`date +%Y-%m-%d`
today_path=./$today

if [ ! -d $today_path ]
then
  mkdir -p $today_path
fi

cd $today_path


FTP_CREATE_TODAY_FOLDER=`ftp -n $HOST << EOF
user $USER $PASS
cd $BACKUP_PATH
mkdir $today_path
bye
EOF
`
echo $FTP_CREATE_TODAY_FOLDER


#start with backup
for DB in $DBS; do

  sql_file=$DB-`date +%H%M`.sql
  tar_file=$DB-`date +%H%M`.tar.gz

  echo "Creating dump for $DB..."
  dokku mariadb:dump $1 $DB > $sql_file

  echo "Compressing $DB..."
  tar zcf $tar_file $sql_file
  rm $sql_file

  echo "Upload $DB to FTP..."
  FTP_UPLOAD_FILE=`ftp -n $HOST << EOF
user $USER $PASS
cd $BACKUP_PATH
cd $today_path
put $tar_file
bye
EOF
`
  echo $FTP_UPLOAD_FILE

done

cd ..
rm -R $today_path


echo "All Done."
