#!perl 
#Parra Arroyo Fernando Marcos
use warnings;
use strict;
use 5.014;
use IO::Handle;

=pod

=head1 BUSCADOR DE IPS, URLS, DOMINIOS Y CORREOS


=head1 NOMBRE
		Parra Arroyo Fernando Marcos 


=head1 DESCRIPCION 
	   	El script recibe como parametro el nombre del archivo que va ser analizado 
		en caso de no ser asi mostrara un error y la sintaxis correcta de ejecucion.

		Como salida mostrara en pantalla los resultados obtenidos en cuanto al 
		total de correos,ips,dominios y urls encontradas.

		Ademas generara dos archivos, uno llamado error.log que contenga los posibles 
		errores que se presenten durante la ejecucion del programa y otro llamado 
		salida.txt que contendra los correos,ips,dominios y urls encontradas 
		con el siguiente formato.
		
		
		TOTAL | IP     
        
 		50   | 1.2.3.4 
 		34   | 4.5.6.7
        19   | 1.9.2.0
 		1    | 9.8.3.9


		Entrada:	
			perl 02fparra.pl datos.txt

		Salida:
		
			Analizando archivo datos.txt espere un momento...

			RESULTADOS: 

			Total Correos : 182108  Correos diferentes: 43198
			Total IPs : 55947  IPs diferentes: 21630
			Total URLs : 190461  URLs diferentes: 98479
			Total Dominios : 371713  Dominios diferentes: 24518


			Para más detalles consulte el archivo salida.txt

		Archivos de salida:

			salida.txt
			error.log

=cut

my $archivo = $ARGV[0]; #se guarda el primer argumento en el escalar longitud
my $argc = @ARGV; # número de argumentos
my $totalCorreos=0; 
my $totalIPS=0;
my $totalDominios=0;
my $totalURLS=0;
my $difCorreos=0;
my $difIPS=0;
my $difDominios=0;
my $difURLS=0; 
my %correos=();#hash para correos
my %ips=();#hash para ips
my %dominios=();#hash para dominios
my %urls=();#hash para urls
my $lineaDominio; #Variable para hacer sustituciones en el caso de dominios

open(my $flog ,">",'error.log') or die "ERROR!!  \n";
open(STDERR,">>&=",$flog); #la salida de error estandar se redirige al archivo log.txt
$flog->autoflush(1);

if (not defined $archivo or $argc != 1) #se verifca que se haya recibido un parametro entero mayor a cero
{	print "ERROR Se necesita el nombre del archivo como parámetro\n USO: perl 02fparra.pl archivo\n ";
	die $flog, "ERROR Se necesita el nombre del archivo como parámetro\n USO: perl 02fparra.pl archivo\n ";
}


if(!open(FH,"<",$archivo))
{
	print "ERROR NO SE PUEDE ABRIR el archivo ",$archivo,"\n";
	die $flog ,"ERROR NO SE PUEDE ABRIR el archivo ",$archivo,"\n";
}

if(!open(FHS, ">", 'salida.txt'))
{	
	print	"ERROR no se pudo abrir el archivo salida.txt!!  \n";
  	die $flog, "ERROR no se pudo abrir el archivo salida.txt!!  \n";
}

print "Analizando archivo ",$archivo," espere un momento...\n\n";
while(<FH>) # se lee el archivo
{
	chomp;

		if($_=~ /\w+(\.\w+)*\@[\w-]+([\.\w-]+)*(\.[a-z]{2,6})/)#Expresion regular para correos
		{
			if(not defined $correos{$&}) # si no existe en el hash se inserta con valor = 1
			{
				$correos{$&}=1;
				$difCorreos++;
			}
			# de lo contrario se actualiza su valor sumando uno, lo que significa que huno más coincidencias
			else {$correos{$&}++;}
			$totalCorreos++;
		}
		if($_=~ /(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})/ && (($1<=255 && $2<=255 && $3<=255 && $4<=255)))
		{
			if(not defined $ips{$&})
			{
				$ips{$&}=1;
				$difIPS++;
			}
			else{$ips{$&}++;}
			$totalIPS++;
		}

		if($_=~ /(@|https?:\/\/|www\.)[\w-]+([\.\w-]+)*(\.[a-z]{2,6})/) #expresion regular para dominios
		{
			#eliminamos las partes que no corresponden al dominio
			$lineaDominio=$&;
			$lineaDominio=~ s/www\.//g;
			$lineaDominio=~ s/@//g;
			$lineaDominio=~ s/https:\/\///g;
			$lineaDominio=~ s/http:\/\///g;
			if(not defined $dominios{$lineaDominio})
			{
				$dominios{$lineaDominio}=1;
				$difDominios++;
			}
			else{$dominios{$lineaDominio}++;}
			$totalDominios++;
		}

		if($_=~ /(https?:\/\/)([\w-]+\.)+[\w-]+(\/[-\w ;,.\[\]\/?%&=+#]*)?/)#expresión regular para urls
		{
			if(not defined $urls{$&})
			{
				$urls{$&}=1;
				$difURLS++;
			}
			else{$urls{$&}++;}
			$totalURLS++;
		}
}

print "RESULTADOS: \n\n";

print FHS "------------CORREOS----------------\n";
print FHS "Total Correos : ", $totalCorreos,"  Correos diferentes: ",$difCorreos,"\n";
print FHS "\n\nTOTAL | CORREO\n";
# se ordenan de forma descendente
foreach my $reps (sort {$correos{$b} <=> $correos{$a}} keys %correos) { print FHS $correos{$reps}," | ",$reps ,"\n";}

print FHS "\n\n------------IPS----------------\n";
print FHS "Total IPs : ", $totalIPS,"  IPs diferentes: ",$difIPS,"\n";
print FHS "\n\nTOTAL | IP\n";
foreach my $reps (sort {$ips{$b} <=> $ips{$a}} keys %ips) {print FHS $ips{$reps}," | ",$reps ,"\n";}

print FHS "\n\n------------URLS----------------\n";
print FHS "Total URLs : ", $totalURLS,"  URLs diferentes: ",$difURLS,"\n";
print FHS "\n\nTOTAL | URL\n";
foreach my $reps (sort {$urls{$b} <=> $urls{$a}} keys %urls) {print FHS $urls{$reps}," | ",$reps ,"\n";}

print FHS "\n\n------------Dominios----------------\n";
print FHS "Total Dominios : ", $totalDominios,"  Dominios diferentes: ",$difDominios,"\n";
print FHS "\n\nTOTAL | DOMINIO\n";
foreach my $reps (sort {$dominios{$b} <=> $dominios{$a}} keys %dominios) {print FHS $dominios{$reps}," | ",$reps ,"\n";}

print "Total Correos : ", $totalCorreos,"  Correos diferentes: ",$difCorreos,"\n";
print "Total IPs : ", $totalIPS,"  IPs diferentes: ",$difIPS,"\n";
print "Total URLs : ", $totalURLS,"  URLs diferentes: ",$difURLS,"\n";
print "Total Dominios : ", $totalDominios,"  Dominios diferentes: ",$difDominios,"\n";

print "\n\nPara más detalles consulte el archivo salida.txt\n\n";

#se cierran los archivos
close $flog;
close FHS;
close FH;