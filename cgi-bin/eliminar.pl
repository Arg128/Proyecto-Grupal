#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

# Ruta absoluta al directorio de datos
my $data_dir = "/var/www/html/data/";

my $pagina = param('pagina');
my $mensaje = '';  # Variable para almacenar el mensaje

print header(-type => 'text/html', -charset => 'UTF-8');

if ($pagina && $pagina =~ /^[a-zA-Z0-9_.-]+\.md$/) {
    my $file_path = $data_dir . $pagina;
    if (-e $file_path) {
        unlink($file_path) or die "No se pudo eliminar la página: $!";
        $mensaje = "La página '$pagina' ha sido eliminada correctamente.";  # Mensaje de éxito       
    } else {
        $mensaje = "Error: Página no encontrada.";  # Mensaje de error si no se encuentra el archivo
    }
} else {
    $mensaje = "Error: Parámetro inválido.";  # Mensaje de error si el parámetro no es válido
}

# Mostrar la página HTML con el mensaje y el enlace
print start_html('Resultado de la operación');
print "<h1>$mensaje</h1>";
print "<a href='listado.pl'>Volver al Listado</a>";
print end_html;
