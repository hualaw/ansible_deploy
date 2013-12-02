server {
        listen      80;
        server_name cms.91waijiao.com;
        charset     utf-8;
        root        /home/www/www/cms;
        access_log  /var/log/nginx/cms_access_log;
        error_log   /var/log/nginx/cms_error_log;
        location / {
                index index.html index.php;
                error_page 404 500 /404.html;

                rewrite ^/feedback /index.php?m=content&c=index&a=lists&catid=10;
                rewrite ^/$  /index.php?m=content&c=index&a=lists&catid=15;
                rewrite ^/information/list-(\d+)-(\d+)\.html$ /index.php?m=content&c=index&a=lists&catid=$1&page=$2;
                rewrite ^/information/show-(\d+)-(\d+)-(\d+)\.html$ /index.php?m=content&c=index&a=show&catid=$1&id=$2&page=$3;

                if (!-e $request_filename) {
                        return 404;
                }
        }
        location ~ \.php$ {
                fastcgi_pass unix://dev/shm/php.sock;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
        }
}
