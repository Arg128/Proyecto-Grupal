#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

# Ruta absoluta al directorio de datos
my $data_dir = "/var/www/html/data/";

my $nombre = param('nombre');
my $contenido = param('contenido');

if ($nombre && $contenido) {
    # Validar y sanitizar el nombre de la página
    if ($nombre =~ /^[a-zA-Z0-9_-]+$/) {
        my $file_path = $data_dir . $nombre . '.md';
        
        if (-e $file_path) {
            open(my $fh, '>', $file_path) or die "No se pudo escribir el archivo: $!";
            print $fh $contenido;
            close($fh);
            chmod 0644, $file_path;
            print redirect('listado.pl');
        } else {
            print header(-type => 'text/html', -charset => 'UTF-8');
            print start_html('Error');
            print "<h1>Error: La página no existe.</h1>";
            print "<a href='listado.pl'>Volver al Listado</a>";
            print end_html;
        }
    } else {
        print header(-type => 'text/html', -charset => 'UTF-8');
        print start_html('Error');
        print "<h1>Error: Nombre de página inválido.</h1>";
        print "<a href='listado.pl'>Volver al Listado</a>";
        print end_html;
    }
} else {
    print header(-type => 'text/html', -charset => 'UTF-8');
    print start_html('Error');
    print "<h1>Error: Falta información.</h1>";
    print "<a href='listado.pl'>Volver al Listado</a>";
    print end_html;
}
