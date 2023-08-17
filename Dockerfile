#FROM centos:latest
FROM ubuntu:18.04
#RUN dnf --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos -y 
#RUN dnf distro-sync -y


RUN sudo apt-get update
RUN sudo apt install nginx-light -y
#RUN yum update -y && yum install -y \
#	httpd  \
#	php 
#	php-mysql \
#	php-xml

# RUN yum install mod_ssl -y

COPY index.html /var/www/html
COPY map_process.php /var/www/html
COPY database.php /var/www/html
COPY .htaccess /var/www/html

#CMD ["mkdir /var/www/html/js"]
#COPY js/* /var/www/html/js/

#CMD ["mkdir /var/www.html/icons"]
#COPY icons/* /usr/share/httpd/icons/

COPY self-signed.conf /etc/nginx/snippets
COPY ssl-params.conf /etc/nginx/snippets
COPY dhparam.pem /etc/ssl/certs
COPY pabrennan.com /etc/nginx/sites-available

RUN sudo ln -s /etc/nginx/sites-available/www.pabrennan.com /etc/nginx/sites-enabled/

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
