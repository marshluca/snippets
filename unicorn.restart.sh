_pid=`cat tmp/pids/unicorn.pid`; sudo kill -USR2 $_pid; sudo kill -QUIT $_pid; ps -ef | grep unicorn | grep master
