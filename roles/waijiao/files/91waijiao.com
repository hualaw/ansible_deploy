upstream waijiao {
    server unix:/dev/shm/php.socket max_fails=5 fail_timeout=10s;
}   

server {
    listen 80;
    server_name www.91waijiao.com www2.91waijiao.com teacher.91waijiao.com api.91waijiao.com agent.91waijiao.com admin.91waijiao.com ipad.91waijiao.com www.91waijiao.cn; 

    allow all;

    root /space1/waijiao/webroot;
    
    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
    }
    
    access_log /var/log/nginx/waijiao_access.log main;
    error_log /var/log/nginx/waijiao_error.log;

    index index.html index.htm index.php;

    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ ^/information/(.*)$ {
	proxy_pass http://cms.91waijiao.com;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        #fastcgi_param   REQUEST_URI "/$domain$request_uri";
        fastcgi_intercept_errors on;
        fastcgi_read_timeout 3000;
        fastcgi_pass waijiao;
    }

}

# vim: set filet:ype=nginx tabstop=4 shiftwidth=4:
