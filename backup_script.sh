#!/bin/bash
#rsync -azP source destination
echo "1. backup_db for backing up remote db"
echo "2. load_db for loading data to remote db"
echo "3. rsync_pull for backing up data to local pc"
echo "4. rsync_push for pushing data to remote db from local pc"
echo "write the name of the function"
echo
read input

backup_db(){
    echo "backing up remote database in ~/db_backup"
    ssh -i new.pem ubuntu@52.64.52.81 'cd db_backup; mysqldump -u username -ppassword db_name > dbname.sql; git add dbname.sql; git commit -m "Backup on `date`"'
}

load_db(){
    echo "loading data to the database"
    ssh -i new.pem ubuntu@52.64.52.81 'cd db_backup; mysql -u username -ppassword db_name < dbname.sql'

}

rsync_push () {
    echo
    echo "Pushing db to remote computer"
    echo
    rsync -qrav -e 'ssh -i new.pem' ~/db_backup/ ubuntu@52.64.52.81:/home/ubuntu/db_backup/
} 

rsync_pull () {
    echo
    echo "Pulling db on local computer"
    echo
    rsync -qrav -e 'ssh -i new.pem' ubuntu@52.64.52.81:/home/ubuntu/db_backup/ ~/db_backup
} 
$input
