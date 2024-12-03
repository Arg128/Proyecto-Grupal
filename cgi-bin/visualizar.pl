#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard escapeHTML);
use File::Slurp;

# Ruta absoluta al directorio de datos
my $data_dir = "/var/www/html/data/";

my $pagina = param('pagina');

# Verificar y sanitizar el parámetro 'pagina'
if ($pagina && $pagina =~ /^[a-zA-Z0-9_.-]+\.md$/) {
    my $file_path = $data_dir . $pagina;
    if (-e $file_path) {
        my $contenido = read_file($file_path);

        # Convertir el contenido de Markdown a HTML utilizando expresiones regulares
        my $html_content = convertir_markdown($contenido);

        # Extraer el nombre de la página sin la extensión '.md'
        my $page_name = $pagina;
        $page_name =~ s/\.md$//;
        $page_name = escapeHTML($page_name);

        # Imprimir las cabeceras y el inicio del HTML con el título de la página
        print header(-type => 'text/html', -charset => 'UTF-8');
        print start_html(-title => $page_name, -encoding => 'UTF-8');

        # Mostrar el nombre de la página como título
        print "<h1>$page_name</h1>";
        print "<div>$html_content</div>";
        print "<br><a href='listado.pl'>Volver al Listado</a>";
        print end_html;
    } else {
        # Manejo de error si la página no existe
        print header(-type => 'text/html', -charset => 'UTF-8');
        print start_html('Error');
        print "<h1>Error: Página no encontrada</h1>";
        print "<a href='listado.pl'>Volver al Listado</a>";
        print end_html;
    }
} else {
    # Manejo de error si el parámetro es inválido
    print header(-type => 'text/html', -charset => 'UTF-8');
    print start_html('Error');
    print "<h1>Error: Parámetro inválido</h1>";
    print "<a href='listado.pl'>Volver al Listado</a>";
    print end_html;
}

# Función para convertir Markdown a HTML utilizando expresiones regulares
sub convertir_markdown {
    my ($texto) = @_;

    # Escapar caracteres HTML
    $texto = escapeHTML($texto);

    # Manejar bloques de código con tres comillas invertidas
    $texto =~ s/```(.*?)```/convertir_bloque_codigo($1)/gse;

    # Manejar enlaces [texto](URL)
    $texto =~ s/\[([^\]]+)\]\(([^)]+)\)/<a href="$2">$1<\/a>/g;

    # Manejar encabezados (#)
    $texto =~ s/^######\s*(.+)$/<h6>$1<\/h6>/gm;
    $texto =~ s/^#####\s*(.+)$/<h5>$1<\/h5>/gm;
    $texto =~ s/^####\s*(.+)$/<h4>$1<\/h4>/gm;
    $texto =~ s/^###\s*(.+)$/<h3>$1<\/h3>/gm;
    $texto =~ s/^##\s*(.+)$/<h2>$1<\/h2>/gm;
    $texto =~ s/^#\s*(.+)$/<h1>$1<\/h1>/gm;

    # Manejar texto en negrita (**texto**)
    $texto =~ s/\*\*(.+?)\*\*/<strong>$1<\/strong>/g;

    # Manejar texto en cursiva (*texto*)
    $texto =~ s/\*(.+?)\*/<em>$1<\/em>/g;

    # Manejar saltos de línea
    $texto =~ s/\n/<br>\n/g;

    return $texto;
}

# Función auxiliar para convertir bloques de código
sub convertir_bloque_codigo {
    my ($codigo) = @_;
    # Reemplazar saltos de línea por <br> y envolver en <pre><code>
    $codigo =~ s/\n/<br>\n/g;
    return "<pre><code>$codigo<\/code><\/pre>";
}
