# sudo kill -HUP `cat /var/run/nginx/nginx.pid`
sudo nginx -s stop && sudo nginx -c /opt/nginx/conf/nginx.conf
