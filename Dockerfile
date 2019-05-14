FROM centos:latest

RUN yum update -y && yum install -y \
	httpd \
	php \
	php-mysql \
	php-xml

COPY index.html /var/www/html
COPY map_process.php /var/www/html
COPY database.php /var/www/html

EXPOSE 80
# Simple startup script to avoid some issues observed with container restart
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]
