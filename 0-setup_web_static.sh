#!/usr/bin/env bash

# Sets up a web server for deployment of web_static.

# Install Nginx if not already installed
if [ ! -x "$(command -v nginx)" ]; then
	    apt-get update
	        apt-get install -y nginx
fi

# Create necessary folders and files
mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/
echo "Holberton School" > /data/web_static/releases/test/index.html
ln -sf /data/web_static/releases/test/ /data/web_static/current

# Give ownership of the /data/ folder to the ubuntu user and group
chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config_block="
server {
    listen 80 default_server;
        listen [::]:80 default_server;
	    add_header X-Served-By \$HOSTNAME;
	        root /var/www/html;
		    index index.html index.htm;

		        location /hbnb_static {
			        alias /data/web_static/current;
				    }

			        location /redirect_me {
				        return 301 https://www.linkedin.com/in/honor-pride-865789196/;
					    }

				        error_page 404 /404.html;
					    location /404 {
					            root /var/www/html;
						            internal;
							        }
						}"

					# Check if the config block already exists in the Nginx configuration
					if ! grep -q "location /hbnb_static {" /etc/nginx/sites-available/default; then
						    echo "$config_block" >> /etc/nginx/sites-available/default
					fi

					# Restart Nginx
					service nginx restart

