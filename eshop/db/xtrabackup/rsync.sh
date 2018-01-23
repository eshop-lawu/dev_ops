sudo chown -R dev2:dev2 /data/backup/full
data=`date "+%Y-%m-%d"`
rsync -r -avz /data/backup/full/$data* dev2@192.168.100.227:/data/backup/backup_206/ >/dev/null 2>&1 
