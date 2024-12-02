FROM debian:11

RUN apt-get update
RUN apt-get install -y vim && nginx && fcgiwrap && systemctl

RUN mkdir /var/www/html/cgi-bin/
RUN mkdir /var/www/html/css/
#Insertamos la ruta al archivo de configuración fastcgi.conf

RUN echo "location /cgi-bin/ {" >> /etc/nginx/fastcgi.conf 
RUN echo   "gzip off;">> /etc/nginx/fastcgi.conf 
RUN echo    "root  /var/www;">> /etc/nginx/fastcgi.conf 
RUN echo    "fastcgi_pass  unix:/var/run/fcgiwrap.socket;">> /etc/nginx/fastcgi.conf 
RUN echo    "include /etc/nginx/fastcgi_params;">> /etc/nginx/fastcgi.conf 
RUN echo    "fastcgi_param SCRIPT_FILENAME  $document_root$fastcgi_script_name;"
RUN echo "}" >> /etc/nginx/fastcgi.conf 


RUN chmod +x /var/www/html/cgi-bin/
RUN chmod +x /var/www/html/css/
COPY html/* /var/www/html/
COPY cgi-bin/* /var/www/html/cgi-bin/
COPY html/css/* /var/www/html/css/

RUN chmod +x /var/www/html/cgi-bin/*



