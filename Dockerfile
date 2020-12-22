FROM debian:buster


RUN	apt-get update
RUN	apt-get upgrade -y
RUN	apt-get install -y vim
RUN	apt-get install -y wget
RUN	apt-get install -y nginx
RUN	apt-get install -y php7.3-fpm php7.3-common php7.3-mysql php7.3-curl
RUN	apt-get -y install mariadb-server
#RUN	apt-get -y install php-fpm php-mysql

RUN	mkdir /var/www/cveeta && mkdir /etc/nginx/ssl && mkdir /var/www/cveeta/phpmyadmin && mkdir /var/www/cveeta/wordpress

RUN	chown -R www-data /var/www/*
RUN	chmod -R 755 /var/www/*

#добавить ключ
RUN	openssl req -newkey rsa:2048 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/cveeta.pem -keyout /etc/nginx/ssl/cveeta.key -subj "/C=RU/ST=Kazan/L= Kazan/O=21 School/OU=cveeta/CN= cveeta"

RUN	ln -s /etc/nginx/sites-available/ng_conf /etc/nginx/sites-enabled/ng_conf

#скопировать всё в контейнер
COPY	./src/init.sh /var
COPY	./src/ng_conf /etc/nginx/sites-available
RUN	rm -rf /etc/nginx/sites-enabled/default
COPY	./src/phpMyAdmin-4.9.0.1-all-languages /var/www/cveeta/phpmyadmin
COPY	./src/wordpress /var/www/cveeta/wordpress
EXPOSE 80 443

CMD	bash var/init.sh
