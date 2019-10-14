#!/bin/bash

set -e

backupdir="dump_repository"
restoredir="backend/web/uploads"
#########################################################################

scrdir="$( cd "$(dirname "$0")" ; pwd -P )"

backpath=$scrdir/$backupdir
restorepath=/home/alexander/make_backup/$restoredir
#set color for display messages
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
LC='\e[96m'

# validation of input

#echo -e "Default \e[96mLight cyan"

# the code below will works if we will input blank string
if [[ ! $1 ]]
    then
    echo -e "${RED}You miss date of backup"
    exit 1
fi

#the code makes error message if we will input not corect data
if [[ $2 ]]
    then
    echo -e  "${LC}To much information was input, try again like this 12-12-2012"
    exit 1
fi

#the code makes error message if it will get not corect data
if [[ ! $1 =~ ^[0-9]{2}-[0-9]{2}-[0-9]{4}$ ]]
  then 
  echo -e "${RED}Not correct format, use DD-MM-YYYY"
  exit 1
fi

# the code below checks does this file exist and if it exist does it directory or not
if [[ ! -d "$backpath" ]] 
    then
    echo "Backup dir ($backpath) not exist"
    exit 1
fi

# the code below checks do we have directory(with time-date) in backups folder
# if it not exist we will have message with affordable backups
if [[ ! -d "$backpath/$1" ]] 
    then
    echo -e "${RED}Backup for date $1 not exist"
    echo -e "${LC}We have this backups:" 
    # grep function matchs right strings
    ls $backpath/ | grep -E "^[0-9]{2}-[0-9]{2}-[0-9]{4}$"
    exit 1
fi

# this code checks do we have file uploads.zip in right time-date folder, 
# backups directory if we don't have  it shows message for us
if [[ ! -f "$backpath/$1/uploads.zip" ]] 
    then
    echo -e "${RED}Backup for date $1 exist but backup files are missing"
    exit 1
fi

# the code below checks file dump.sql.gz in right time-date,
# in backups directory if it not exist we will see a message
if [[ ! -f "$backpath/$1/dump.sql.gz" ]]
    then
    echo -e "${RED}Backup for date $1 exist but backup MySQL are missing"
    exit 1
fi

# the code checks do we have this directorie if we do not have we will see
# a message after it directorie will create
if [[  -d "$restpath" ]]
    then
    echo "destination dir ($restpath) is missing, will create"
    mkdir -p $restpath
fi


echo -e "${LC}-----copy backup files-----"
# exit 1

# the code below unarchived uploads.zip from backups to backend/web/uploads
# $backPath = backups
#unzip {.zip-file-name}-d {/path/to/extract}
unzip $backpath/$1/uploads.zip -d /$restorepath





echo -e "${GREEN}-----copy restore MySQL dump-----restore DB, smth like this:"
echo "user@localhost# mysql -u DBuser -p DBname | someplace/delAllTables.sql"
echo "user@localhost# zcat $backpath/$1/dump.sql.gz | mysql -u DBuser -p DBname"


# unarchived dump.sql.gz
gzip -dc < $backpath/$1/dump.sql.gz > $restorepath/dump.sql
