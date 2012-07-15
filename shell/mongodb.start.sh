# rm -f /usr/local/log/mongodb/mongod.lock
# launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist
# /usr/local/mongodb/bin/mongod run --config /usr/local/mongodb/mongod.conf
# mongod --dbpath /usr/local/mongodb_data --logpath /var/log/mongodb/out.log --fork  --logappend  --port 27017

# If this is your first install, automatically load on login with:
    mkdir -p ~/Library/LaunchAgents
    cp /usr/local/Cellar/mongodb/2.0.3-x86_64/homebrew.mxcl.mongodb.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist

# If this is an upgrade and you already have the homebrew.mxcl.mongodb.plist loaded:
    launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist
    cp /usr/local/Cellar/mongodb/2.0.3-x86_64/homebrew.mxcl.mongodb.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist

# Or start it manually:
    mongod run --config /usr/local/Cellar/mongodb/2.0.3-x86_64/mongod.conf

# The launchctl plist above expects the config file to be at /usr/local/etc/mongod.conf.
# If this is a first install, you can copy one from /usr/local/Cellar/mongodb/2.0.3-x86_64/mongod.conf:
    cp /usr/local/Cellar/mongodb/2.0.3-x86_64/mongod.conf /usr/local/etc/mongod.conf
