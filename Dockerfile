#FROM centos:latest
#FROM ubuntu:18.04
FROM nginx:latest

#RUN dnf --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos -y 
#RUN dnf distro-sync -y

#RUN apt-get update
#RUN apt-get install certbot
#RUN apt-get install python3-certbot-nginx

#RUN apt-get update
#RUN apt install nginx-light -y
#RUN yum update -y && yum install -y \
#	httpd  \
#	php 
#	php-mysql \
#	php-xml

# RUN yum install mod_ssl -y

#COPY index.html /var/www/html
#COPY map_process.php /var/www/html
#COPY database.php /var/www/html
#COPY .htaccess /var/www/html

#COPY index.html /usr/share/nginx/html/index.html
#COPY map_process.php /usr/share/nginx/html/index.html
#COPY database.php /usr/share/nginx/html/index.html
#COPY .htaccess /usr/share/nginx/html/index.html


CMD ["mkdir /usr/share/nginx/html/js"]
COPY ./js/ /usr/share/nginx/html/js/

CMD ["mkdir /usr/share/nginx/html/icons"]
COPY ./icons/ /usr/share/nginx/html/icons/

#COPY self-signed.conf /etc/nginx/snippets
#COPY ssl-params.conf /etc/nginx/snippets
#COPY dhparam.pem /etc/ssl/certs
#COPY www.pabrennan.com /etc/nginx/sites-available

#CMD ["ln -s /etc/nginx/sites-available/www.pabrennan.com /etc/nginx/sites-enabled/"]

#COPY ./ssl.crt /etc/apache2/ssl/ssl.crt
#COPY ./ssl.key /etc/apache2/ssl/ssl.key
#RUN mkdir -p /var/run/apache2/

#RUN sed -i 's/#ServerName\ www.example.com:443/ServerName\ www.pabrennan.com:443/g' /etc/httpd/conf.d/ssl.conf

EXPOSE 80
EXPOSE 443

# Simple startup script to avoid some issues observed with container restart
#ADD run-httpd.sh /run-httpd.sh
#RUN chmod -v +x /run-httpd.sh

#CMD ["/run-httpd.sh"]
