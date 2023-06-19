#/etc/nginx/nginx.conf en server-b
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
	worker_connections 768;
}

http {


        set_real_ip_from 2001:db8:123::100;
        real_ip_header X-Forwarded-For;
        real_ip_recursive on;

	sendfile on;
	tcp_nopush on;
	types_hash_max_size 2048;


	include /etc/nginx/mime.types;
	default_type application/octet-stream;


	ssl_prefer_server_ciphers on;


	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;


	gzip on;



	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;
}
