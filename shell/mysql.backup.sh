mysqldump -h192.168.0.6 -uroot -p123456 eoeshares > /data/backup/eoeshares/mysql/`ruby -e 'print Time.now.strftime("%Y%m%d_%H%M%S")'`.sql
