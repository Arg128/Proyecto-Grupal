#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

# Ruta absoluta al directorio de datos
my $data_dir = "/var/www/html/data/";

my $pagina = param('pagina');

print header(-type => 'text/html', -charset => 'UTF-8');

if ($pagina && $pagina =~ /^[a-zA-Z0-9_.-]+\.md$/) {
    my $file_path = $data_dir . $pagina;
    if (-e $file_path) {
        unlink($file_path) or die "No se pudo eliminar la página: $!";
     ##   print redirect('listado.pl');
    } else {
        print start_html('Error');
        print "<h1>Error: Página no encontrada.</h1>";
        print "<a href='listado.pl'>Volver al Listado</a>";
        print end_html;
    }
} else {
    print start_html('Error');
    print "<h1>Error: Parámetro inválido.</h1>";
    print "<a href='listado.pl'>Volver al Listado</a>";
    print end_html;
}
