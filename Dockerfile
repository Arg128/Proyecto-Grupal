FROM debian:latest

# Actualizar los repositorios y instalar Apache, Perl y módulos necesarios
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-perl2 perl cpanminus && \
    cpanm CGI File::Slurp File::Basename Text::Markdown && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Habilitar el módulo CGI y configurar Apache
RUN a2enmod cgid

# Configurar el ServerName para suprimir la advertencia
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Configurar el directorio cgi-bin
RUN sed -i 's|ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/|ScriptAlias /cgi-bin/ /var/www/cgi-bin/|' /etc/apache2/conf-available/serve-cgi-bin.conf
RUN sed -i 's|/usr/lib/cgi-bin|/var/www/cgi-bin|' /etc/apache2/sites-enabled/000-default.conf

# Crear el directorio cgi-bin en /var/www/
RUN mkdir -p /var/www/cgi-bin

# Copiar los archivos del proyecto
COPY ./cgi-bin/ /var/www/cgi-bin/
COPY ./html/ /var/www/html/
COPY ./css/ /var/www/html/css/
RUN mkdir -p /var/www/html/data/
COPY ./data/ /var/www/html/data/

# Asegurarse de que los scripts CGI sean ejecutables
RUN chmod +x /var/www/cgi-bin/*.pl

# Establecer los permisos adecuados
RUN chown -R www-data:www-data /var/www/html /var/www/cgi-bin

# Exponer el puerto 80
EXPOSE 80

# Iniciar Apache en primer plano
CMD ["apachectl", "-D", "FOREGROUND"]
