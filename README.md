# Backup-Dokku-MariaDB-ToFTP
This bash script allow to backup all dokku mariadb databases and upload them to an FTP location

It is based on the union of https://github.com/Leen15/Backup-ToFTP-Bash and https://github.com/Leen15/Backup-Dokku-MariaDB-Container-DB.

So, given a container name and a FTP location, it create a new folder with today date and backup inside all db linked to the container, compressed.

You can use it as follow:

    bash backup_mariadb_to_ftp.sh CONTAINER_NAME /FTP_PATH/

NB: remote folder must exists.
