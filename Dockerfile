FROM centos:latest

RUN dnf --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos -y 
RUN dnf distro-sync -y

RUN yum update -y && yum install -y \
	httpd \
	php 
#	php-mysql \
#	php-xml

COPY index.html /var/www/html
COPY map_process.php /var/www/html
COPY database.php /var/www/html
COPY .htaccess /var/www/html

CMD ["mkdir /var/www/html/js"]
COPY js/* /var/www/html/js/

CMD ["mkdir /var/www.html/icons"]
COPY icons/* /usr/share/httpd/icons/

COPY ./path/to/ssl.crt /etc/apache2/ssl/ssl.crt
COPY ./path/to/ssl.key /etc/apache2/ssl/ssl.key
RUN mkdir -p /var/run/apache2/

EXPOSE 80
# Simple startup script to avoid some issues observed with container restart
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]
