#FROM centos:latest
#FROM ubuntu:18.04
#FROM nginx:latest

#stuff from git hub guy
FROM nginx:1.25.2
LABEL maintainer="Jonas Alfredsson <jonas.alfredsson@protonmail.com>"

ENV CERTBOT_DNS_AUTHENTICATORS \
    cloudflare \
    cloudxns \
    digitalocean \
    dnsimple \
    dnsmadeeasy \
    gehirn \
    google \
    linode \
    luadns \
    nsone \
    ovh \
    rfc2136 \
    route53 \
    sakuracloud \
    ionos

# Needed in order to install Python packages via PIP after PEP 668 was
# introduced, but I believe this is safe since we are in a container without
# any real need to cater to other programs/environments.
ARG PIP_BREAK_SYSTEM_PACKAGES=1

# Do a single run command to make the intermediary containers smaller.
RUN set -ex && \
# Install packages necessary during the build phase (for all architectures).
    apt-get update && \
    apt-get install -y --no-install-recommends \
            build-essential \
            cargo \
            curl \
            libffi8 \
            libffi-dev \
            libssl-dev \
            openssl \
            pkg-config \
            procps \
            python3 \
            python3-dev \
    && \
# Install the latest version of PIP, Setuptools and Wheel.
    curl -L 'https://bootstrap.pypa.io/get-pip.py' | python3 && \
# Install certbot.
    pip3 install -U cffi certbot \
# And the supported extra authenticators
        $(echo $CERTBOT_DNS_AUTHENTICATORS | sed 's/\(^\| \)/\1certbot-dns-/g') \
    && \
# Remove everything that is no longer necessary.
    apt-get remove --purge -y \
            build-essential \
            cargo \
            curl \
            libffi-dev \
            libssl-dev \
            pkg-config \
            python3-dev \
    && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cache && \
    rm -rf /root/.cargo && \
# Create new directories and set correct permissions.
    mkdir -p /var/www/letsencrypt && \
    mkdir -p /etc/nginx/user_conf.d && \
    chown www-data:www-data -R /var/www \
    && \
# Make sure there are no surprise config files inside the config folder.
    rm -f /etc/nginx/conf.d/*

# Copy in our "default" Nginx server configurations, which make sure that the
# ACME challenge requests are correctly forwarded to certbot and then redirects
# everything else to HTTPS.

COPY nginx_conf.d/ /etc/nginx/conf.d/

# Copy in all our scripts and make them executable.

RUN mkdir /scripts
COPY scripts/ /scripts
RUN chmod +x -R /scripts && \
# Make so that the parent's entrypoint script is properly triggered (issue #21).
    sed -ri '/^if \[ "\$1" = "nginx" \] \|\| \[ "\$1" = "nginx-debug" \]; then$/,${s//if echo "$1" | grep -q "nginx"; then/;b};$q1' /docker-entrypoint.sh

# Create a volume to have persistent storage for the obtained certificates.
VOLUME /etc/letsencrypt

# The Nginx parent Docker image already expose port 80, so we only need to add
# port 443 here.
EXPOSE 443

# Change the container's start command to launch our Nginx and certbot
# management script.
CMD [ "/scripts/start_nginx_certbot.sh" ]
#end git stuff from guy




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

COPY index.html /usr/share/nginx/html
COPY map_process.php /usr/share/nginx/html
COPY database.php /usr/share/nginx/html
COPY .htaccess /usr/share/nginx/html


RUN mkdir /usr/share/nginx/html/js
COPY ./js/ /usr/share/nginx/html/js/

RUN mkdir /usr/share/nginx/html/icons
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
