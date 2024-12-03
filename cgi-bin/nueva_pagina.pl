#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use File::Basename;

# Ruta absoluta al directorio de datos
my $data_dir = "/var/www/html/data/";

my $nombre = param('nombre');
my $contenido = param('contenido');

if ($nombre && $contenido) {
    # Validar y sanitizar el nombre de la página
    if ($nombre =~ /^[a-zA-Z0-9_-]+$/) {
        my $file_path = $data_dir . $nombre . '.md';
        
        # Verificar si el archivo ya existe
        if (-e $file_path) {
            print header(-type => 'text/html', -charset => 'UTF-8');
            print start_html('Error');
            print "<h1>Error: La página ya existe.</h1>";
            print "<a href='/nueva_pagina.html'>Volver</a>";
            print end_html;
        } else {
            # Intentar crear el archivo
            open(my $fh, '>', $file_path) or do {
                print header(-type => 'text/html', -charset => 'UTF-8');
                print start_html('Error');
                print "<h1>Error: No se pudo escribir el archivo.</h1>";
                print "<p>$!</p>";
                print "<a href='/nueva_pagina.html'>Volver</a>";
                print end_html;
                exit;
            };
            print $fh $contenido;
            close($fh);
            chmod 0644, $file_path;
            print redirect('/cgi-bin/listado.pl');
        }
    } else {
        # Nombre de página inválido
        print header(-type => 'text/html', -charset => 'UTF-8');
        print start_html('Error');
        print "<h1>Error: Nombre de página inválido.</h1>";
        print "<a href='/nueva_pagina.html'>Volver</a>";
        print end_html;
    }
} else {
    # Falta información
    print header(-type => 'text/html', -charset => 'UTF-8');
    print start_html('Error');
    print "<h1>Error: Falta información.</h1>";
    print "<a href='/nueva_pagina.html'>Volver</a>";
    print end_html;
}
