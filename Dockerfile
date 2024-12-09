# Usar la imagen oficial de NGINX
FROM nginx:latest

# Instalar Perl, spawn-fcgi y fcgiwrap
RUN apt-get update && \
    apt-get install -y perl spawn-fcgi fcgiwrap && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crear un directorio para los scripts CGI
RUN mkdir -p /usr/src/app/cgi-bin

# Copiar los scripts Perl y la configuración de NGINX al contenedor
COPY cgi-bin /usr/src/app/cgi-bin
COPY nginx.conf /etc/nginx/nginx.conf

# Asegurarse de que los scripts Perl tengan permisos de ejecución
RUN chmod +x /usr/src/app/cgi-bin/*.pl

# Exponer el puerto 80
EXPOSE 80

# Iniciar fcgiwrap y NGINX
CMD ["sh", "-c", "spawn-fcgi -s /var/run/fcgiwrap.socket /usr/bin/fcgiwrap && nginx -g 'daemon off;'"]
