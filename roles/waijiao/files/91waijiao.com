upstream waijiao {
    server unix:/dev/shm/php.socket max_fails=5 fail_timeout=10s;
}   

server {
    listen 80;
    server_name *.91waijiao.com 121.124.41.101 *.91peilian.com;

    allow all;

    root /space/waijiao/webroot;

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

    #set $domain 'www';
    #if ( $host ~* "^(.*)\.91waijiao\.com$") {
    #   set $domain $1;
    #}

        if (!-e $request_filename) {
        rewrite ^/(.*)$ /index.php/$1 last;
            break;
        }

    location ~ \.php$ {
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
        #fastcgi_param   REQUEST_URI "/$domain$request_uri";
        fastcgi_intercept_errors on;
        fastcgi_read_timeout 3000;
        fastcgi_pass waijiao;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
    }
}

server{
    listen 80;
    server_name img.91waijiao.com;
    
    allow all;
    
    root /space/waijiao/static;
    
    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }
    
    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
    }
}

# vim: set filet:ype=nginx tabstop=4 shiftwidth=4:
