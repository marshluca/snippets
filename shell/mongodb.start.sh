sudo rm -f /usr/local/mongodb_data/mongod.lock
sudo launchctl load /Library/LaunchDaemons/org.mongodb.mongod.plist
#/usr/local/mongodb/bin/mongod run --config /usr/local/mongodb/mongod.conf
#mongod --dbpath /usr/local/mongodb_data --logpath /var/log/mongodb/out.log --fork  --logappend  --port 27017
