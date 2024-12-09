# Usar la imagen oficial de Lighttpd
FROM lighttpd:latest

# Instalar Perl
RUN apt-get update && \
    apt-get install -y perl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crear un directorio para los scripts CGI
RUN mkdir -p /var/www/cgi-bin

# Copiar los scripts Perl al directorio cgi-bin
COPY app /var/www/cgi-bin

# Asegurarse de que los scripts Perl tengan permisos de ejecución
RUN chmod +x /var/www/cgi-bin/*.pl

# Copiar la configuración de Lighttpd al contenedor
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar Lighttpd
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
