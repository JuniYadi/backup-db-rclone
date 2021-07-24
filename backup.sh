#!/bin/bash

cat <<EOF
----------- Important -----------
Backup Database with RCLONE
Source: https://github.com/JuniYadi/backup-db-rclone
---------------------------------
By: Juni Yadi
Update: 2020-02-17 04:04
License: MIT
---------------------------------
EOF

# Default Config Path
backup_config="$HOME/.backup-rclone"

# Custom Config Path
if [ $1 ]; then
    backup_config=$1
fi

# Exit If Config Not Found
if [ ! -f $backup_config ]; then
    echo "Config File Path $backup_config Not Found.!"
    echo "Please Check Config at https://github.com/JuniYadi/backup-db-rclone"
    exit
fi

# Load all variable from config path
source $backup_config

# Create Folder Backup
if [ ! -d $HOME/backup ]; then
    echo "Create Folder Backup: $HOME/backup"
    mkdir $HOME/backup
fi

# Move to Folder Backup
echo "Move to Folder Backup: $HOME/backup"
cd $HOME/backup

# Generate File Backup Name With Date
datenow=$(date '+%Y%m%d_%H%M%S')
filename="$db_name-$datenow"
filename_sql="$filename.sql"
filename_tar="$filename.tar.gz"

# Dump Database
echo "------------------------------"
echo "Backup Database: $filename_sql"

# MySQL Dump With Secure Password Inline
mysqldump --defaults-extra-file=<( echo $'[client]\npassword='"$db_pass" ) --no-tablespaces $db_opts -h $db_host --user=$db_user $db_name > $filename_sql

# Compress File
echo "------------------------------"
echo "Compress File SQL: $filename_sql to $filename_tar"

tar cfz $filename_tar $filename_sql

# ----------- Rclone Copy -----------
# Start Backup File with Rclone Scripts
# -----------------------------------

for x in $(echo $rclone_account | sed "s/,/ /g")
do
    # Set Name of Account
    account_name=$(echo $x | tr a-z A-Z)

    echo "------------------------------"
    echo "Copy File $filename_tar to $account_name"
    echo "PATH: $account_name/$domain/db/$filename_tar"
    echo "------------------------------"

    rclone -v copy $filename_tar $x:$domain/db
done

# ----------- Rclone Delete -----------
# Start Delete Old Files X Days Scripts
# -------------------------------------

# Only Running if Variable Available
if [ $rclone_auto_delete_account ]; then

    for i in $(echo $rclone_auto_delete_account | sed "s/,/ /g")
    do
        # Set Name of Account
        account_name=$(echo $i | tr a-z A-Z)

        echo "------------------------------"
        echo "Delete Old Files in account: $account_name"

        rclone -v delete $i:$domain/db --min-age $rclone_auto_delete_time --drive-use-trash=false
    done

fi

# ----------- Delete Files -----------
#       Start Delete Local Files
# ------------------------------------

if [ $delete_local_file_sql == "yes" ]; then
    echo "------------------------------"
    echo "Delete SQL File: $filename_sql"
    rm -rf $filename_sql
fi

if [ $delete_local_file_tar == "yes" ]; then
    echo "------------------------------"
    echo "Delete TAR File: $filename_tar"
    rm -rf $filename_tar
fi

echo "------------------------------"
