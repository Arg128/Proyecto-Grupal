FROM debian:latest

# Instalar Nginx, fcgiwrap y spawn-fcgi
RUN apt-get update && apt-get install -y nginx fcgiwrap spawn-fcgi

# Crear directorio para el socket si no existe
RUN mkdir -p /var/run

# Copiar archivos de configuración de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar scripts CGI
COPY cgi-bin /usr/lib/cgi-bin

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar fcgiwrap y Nginx
CMD spawn-fcgi -s /var/run/fcgiwrap.socket -M 766 /usr/sbin/fcgiwrap && nginx -g "daemon off;"
