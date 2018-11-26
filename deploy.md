Deployment
=====
- First thing we did was add our domain name to cloudflare.
- Cloudflare gave us 2 links to name servers that we had to plug into Google Domains (where we bought the domain) so that Google knows that Cloudflare will be taking over the routing when people hit the domain name. 
- Then we added a DNS record with the name `@`, which means that the DNS wont have any subdomains 

Initalisation
----

Steps taken to initialise the server (largely following [this](https://medium.com/@zek/deploy-early-and-often-deploying-phoenix-with-edeliver-and-distillery-part-one-5e91cac8d4bd))

- Launched a new Ubuntu EC2 instance
  (https://www.digitalocean.com/community/tutorials/how-to-automate-elixir-phoenix-deployment-with-distillery-and-edeliver-on-ubuntu-16-04)
- Associated IP to instance via Cloudflare
- instll Nginx (https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-16-04)



##### Deploy User Setup

Might need to set locales first: https://stackoverflow.com/questions/32407164/the-vm-is-running-with-native-name-encoding-of-latin1-which-may-cause-elixir-to#32407431

```bash
su - deploy
mkdir .ssh



#https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04
#cat ~/.ssh/id_rsa.pub
#public key ends in .pub that you can share, dont share the other one 
# follow the Option 2: Manually Install the Key part 
#instead of user `sammy` use `deploy`

sudo cp /home/ubuntu/.ssh/authorized_keys ~/.ssh/authorized_keys
sudo chown `whoami` ~/.ssh/authorized_keys
chmod 700 .ssh
chmod 600 .ssh/authorized_keys
```

For every deploy machine you need to add your public key to the deploy user:
```
# Run on local machine. Copy output
cat ~/.ssh/id_rsa.pub

# On deploy user for Prod machine
sudo nano ~/.ssh/authorized_keys # paste in new line and save
chmod 600 .ssh/authorized_keys
```

You should be able to SSH as "deploy" without the keypair: `ssh deploy@kunvince.com`
IMPORTANT: you must make sure you can SSH without having to input your local password (https://superuser.com/questions/1127067/macos-keeps-asking-my-ssh-passphrase-since-i-updated-to-sierra)

##### Git
```bash
sudo apt-get update && sudo apt-get install git
```

##### Firewall
```bash
sudo ufw app list    # You should see OpenSSH listed
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status     # Status: active
```

##### Node
```bash
curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt-get install nodejs
sudo apt-get install build-essential
```

##### Elixir
```bash
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang=1:19.3
sudo apt-get install elixir
```

##### Nginx

```
sudo apt-get install nginx
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'
sudo nano /etc/nginx/sites-available/kunvince

# Paste the following
upstream kunvince {
  server 127.0.0.1:8888;
}

map $http_upgrade $connection_upgrade {
  default upgrade;
  '' close;
}

server {
  listen 80;
  server_name kunvince.com;
  location / {
    try_files $uri @proxy;
  }
  location @proxy {
    include proxy_params;
    proxy_redirect off;
    proxy_pass http://kunvince;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Host $host;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
  }
}

# enable:
sudo ln -s /etc/nginx/sites-available/kunvince /etc/nginx/sites-enabled/kunvince
sudo nginx -t
```
Install postgres on the server
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-16-04
When we installed postgres in the server we could elevate the privilages of the built in postgres user so that they could have overall priviliges to change the database. Below that we could create another layer of users (lani / kunvince / etc) that has priviligies to only modify 1 database. 

WE didnt do that now, because having the original postgres user is enough

We need to add a hostname to prod.secret.exs that can have an IP address or a domain name (lani.com) 

Our end goal is to be able to run 
`MIX_ENV=prod mix ecto.create` on our local machine and have it create a db in our server db

##### Set up the project on the server

```bash
# From local:
mix edeliver build release production --verbose # this will fail because you need to add prod secret

ssh deploy@104.248.146.100
nano prod.secret.exs    # copy the contents from local machine here

# Re-run
mix edeliver build release production --verbose
mix edeliver deploy release to production --verbose
# mix edeliver start production --verbose # we don't need to run this since we will start the app as a service
```

##### Start Phoenix on boot

- `sudo nano /lib/systemd/system/kunvince.service`

Paste:
```bash
[Unit]
Description=Phoenix server for kunvince app
After=network.target

[Service]
User=deploy
Group=deploy
Restart=on-failure

Environment=HOME=/home/deploy/kunvince

ExecStart= /home/deploy/kunvince/bin/kunvince foreground
ExecStop= /home/deploy/kunvince/bin/kunvince stop

[Install]
WantedBy=multi-user.target
```
- `sudo systemctl enable kunvince.service`
- `sudo systemctl daemon-reload`


##### SSL with LetsEncrypt

- Make sure the security group is open for SSL

```bash

sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot
mkdir /home/deploy/certbot
sudo nano /etc/nginx/sites-enabled/kunvince

## change this:
server {
  ## ADD THIS AT THE TOP
  location /.well-known {
    alias /home/deploy/certbot/.well-known;
  }
  # ...
}

sudo nginx -t # test to see if config is OK
sudo systemctl restart nginx # restart

#Create the cert
sudo certbot certonly --webroot --webroot-path=/home/deploy/certbot/ -d kunvince.com

# Generate a Diffie-Hellman Key for additional security
sudo openssl dhparam -out /etc/letsencrypt/dhparam.pem 2048
```

Configuring SSL on Nginx:

- Run `sudo nano /etc/nginx/snippets/kunvince.com.conf` and add:
```bash
ssl_certificate /etc/letsencrypt/live/kunvince.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/kunvince.com/privkey.pem;
```

- Run `sudo nano /etc/nginx/snippets/ssl-params.conf` and add:
```bash
# from https://cipherli.st/

ssl_protocols TLSv1.2;
ssl_prefer_server_ciphers on;
ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
ssl_ecdh_curve secp384r1;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off;
ssl_stapling on;
ssl_stapling_verify on;
# use Google DNS
resolver 8.8.8.8 8.8.4.4 valid=300s;
resolver_timeout 5s;

# HSTS header: BE CAREFUL!
# Uncommenting this setting means that your site needs to support HTTPS in the future (including subdomains),
# otherwise users who have previously been to your site won't be able to access.
# add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";

add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;

ssl_dhparam /etc/letsencrypt/dhparam.pem;
```

Updating our Nginx config file:
```bash
# Let's back up our config file first.
sudo cp /etc/nginx/sites-available/kunvince /etc/nginx/sites-available/kunvince.backup
sudo nano /etc/nginx/sites-available/kunvince
```


Change to this:
```bash
upstream kunvince {
  server 127.0.0.1:8888;
}

map $http_upgrade $connection_upgrade {
  default upgrade;
  '' close;
}

# REDIRECT HTTP kunvince.com to HTTPS kunvince.com
server {
  listen 80;
  server_name kunvince.com;
  return 301 https://api.kunvince.com$request_uri;
}

server {
  listen 443 ssl http2;

  server_name api.kunvince.com;

  # INCLUDE SSL SNIPPETS
  include snippets/kunvince.com.conf;
  include snippets/ssl-params.conf;

  # for LetsEncrypt certbot
  location /.well-known {
    alias /home/deploy/certbot/.well-known;
  }

  location / {
    try_files $uri @proxy;
  }

  location @proxy {
    include proxy_params;
    proxy_redirect off;
    proxy_pass http://kunvince;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Host $host;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;

  }
}
```
- `sudo nginx -t` test
- `sudo systemctl restart nginx` restart


##### SSL Cert Auto Renewal

- `sudo crontab -e`
Add this to the bottom:
```bash
# at 3:47am, renew all Let's Encrypt certificates over 60 days old
47 3 * * *   certbot renew --renew-hook "service nginx reload"
```



LATER 
Change the redirects on Cloudfare so that people visiting www.kunvince.com will be redirected to the main site