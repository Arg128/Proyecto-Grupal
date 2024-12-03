#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard escapeHTML);
use File::Slurp;

# Ruta absoluta al directorio de datos
my $data_dir = "/var/www/html/data/";

my $pagina = param('pagina');

print header(-type => 'text/html', -charset => 'UTF-8');
print start_html(-title => 'Editar Página', -encoding => 'UTF-8');

if ($pagina && $pagina =~ /^[a-zA-Z0-9_.-]+\.md$/) {
    my $file_path = $data_dir . $pagina;
    if (-e $file_path) {
        my $contenido = read_file($file_path);
        my $name = $pagina;
        $name =~ s/\.md$//;

        print "<h1>Editar Página</h1>";
        print "<form action='actualizar_pagina.pl' method='post'>";
        print "<input type='hidden' name='nombre' value='" . escapeHTML($name) . "'>";
        print "<label for='contenido'>Contenido (Markdown):</label><br>";
        print "<textarea id='contenido' name='contenido' rows='10' cols='30'>" . escapeHTML($contenido) . "</textarea><br><br>";
        print "<button type='submit'>Guardar Cambios</button>";
        print "</form>";
        print "<a href='listado.pl'>Volver al Listado</a>";
    } else {
        print "<h1>Error: Página no encontrada</h1>";
        print "<a href='listado.pl'>Volver al Listado</a>";
    }
} else {
    print "<h1>Error: Parámetro inválido</h1>";
    print "<a href='listado.pl'>Volver al Listado</a>";
}

print end_html;
