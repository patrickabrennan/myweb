FROM centos:latest

RUN yum update -y && yum install -y \
	httpd \
	php 

COPY index.html /var/www/html

EXPOSE 80
# Simple startup script to avoid some issues observed with container restart
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]
