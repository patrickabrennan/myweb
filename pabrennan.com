server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/html;
    server_name pabrennan.com.com www.pabrennan.com.com;
}
