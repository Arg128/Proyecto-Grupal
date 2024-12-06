#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard escapeHTML);
use File::Basename;

# Ruta absoluta al directorio de datos
my $data_dir = "/var/www/html/data/";

print header(-type => 'text/html', -charset => 'UTF-8');
print start_html(-title => 'Listado de Páginas', -encoding => 'UTF-8');

print "<h1>Listado de Páginas</h1>";
opendir(my $dh, $data_dir) or die "No se puede abrir el directorio: $!";
my @files = grep { /\.md$/ } readdir($dh);
closedir($dh);

if (@files) {
    print "<ul>";
    foreach my $file (@files) {
        my $name = fileparse($file, qr/\.[^.]*/);
        my $encoded_file = url_encode($file);
        my $safe_name = escapeHTML($name);
        print "<li><a href='visualizar.pl?pagina=$encoded_file'>$safe_name</a> 
               (<a href='editor.pl?pagina=$encoded_file'>E</a>, 
                <a href='eliminar.pl?pagina=$encoded_file'>X</a>)</li>";
    }
    print "</ul>";
} else {
    print "<p>No hay páginas creadas aún.</p>";
}

# Enlaces corregidos
print "<a href='/nueva_pagina.html'>Agregar Nueva Página</a>";
print "<br><a href='/index.html'>Volver al Inicio</a>";

print end_html;

# Función para codificar URLs
sub url_encode {
    my $s = shift;
    $s =~ s/([^A-Za-z0-9_-])/sprintf("%%%02X", ord($1))/seg;
    return $s;
}
