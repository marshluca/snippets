sudo rm -f /usr/local/mongodb_data/mongod.lock
sudo mongod --repair --dbpath /usr/local/mongodb_data/
