server {
	listen      80;
	server_name data.91waijiao.com;
	charset     utf-8;
	root        /space/data;
	access_log  /var/log/nginx/data_access_log;
	error_log   /var/log/nginx/data_error_log;
	location / {
		index index.html index.php;
	#	error_page 404 500 /404.html;
	
	#	if (!-e $request_filename) {
#			return 404;
#		}
	}
	location ~ \.php$ {
		fastcgi_pass unix://dev/shm/php.socket;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		include fastcgi_params;
	}
}
