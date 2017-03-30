################### Rewrite www from http and https to https
server {
	server_name www.example.com;
	listen 80;
	listen 443 ssl;
	ssl_certificate /etc/nginx/ssl/example.com.crt;
	ssl_certificate_key /etc/nginx/ssl/example.com.key;
	ssl_trusted_certificate /etc/nginx/ssl/example.com.ca;
	return 301 https://example.com$request_uri;
}

################### Rewrite http:// to https://

server {
	server_name example.com;
	listen 80;
	rewrite ^ https://$http_host$request_uri? permanent;
}

################### Main config for site

server {
	server_name example.com;
	listen 443 ssl;
	ssl_certificate /etc/nginx/ssl/example.com.crt;
	ssl_certificate_key /etc/nginx/ssl/example.com.key;
	ssl_trusted_certificate /etc/nginx/ssl/example.com.ca;

	root /sites/example.com;
	index index.php;
	allow all;
	charset utf-8;
	error_log   /var/log/nginx/error_example.com.log;
	fastcgi_buffers 8 16k;
	fastcgi_buffer_size 32k;

	gzip on;
	gzip_disable "msie6";
	gzip_comp_level 6;
	gzip_min_length 1100;
	gzip_buffers 16 8k;
	gzip_proxied any;
	gzip_types text/plain application/xml application/javascript text/css text/js text/xml application/x-javascript text/javascript application/json application/xml+rss;

	client_max_body_size 512m;
	client_body_buffer_size 128k;
	client_header_timeout 3m;
	client_body_timeout 3m;
	send_timeout 3m;
	client_header_buffer_size 1k;
	large_client_header_buffers 4 16k;

	location / {
		root /sites/example.com;
		index  index.php index.html;
		try_files $uri $uri/ @fallback;
	}

	location @fallback {
		rewrite  ^(.*)$ /index.php?$args last;
	}

	location ~* \.(jpeg|ico|jpg|gif|png|css|js|pdf|txt|tar|gz|wof|csv|zip|xml|yml) {
		access_log off;
		try_files $uri @statics;
		expires 14d;
		add_header Access-Control-Allow-Origin *;
		add_header Cache-Control public;
		root /sites/example.com;
	}

	location @statics {
		rewrite ^/(\w+)/(.*)$ /$2 break;
		access_log off;
		rewrite_log off;
		expires 14d;
		add_header Cache-Control public;
		add_header Access-Control-Allow-Origin *;
		root /sites/example.com;
	}

	location ~ \.php$ {
		root /sites/example.com;
		proxy_read_timeout 61;
		fastcgi_read_timeout 61;
		try_files $uri $uri/ =404;
		fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		include fastcgi_params;
	}

	location /.well-known/acme-challenge {
		root /sites/example.com/.well-known/acme-challenge;
		allow all;
		autoindex on;
	}

	location ~ /\.ht {
		deny all;
	}

}


