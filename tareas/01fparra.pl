#!perl 
use warnings;
use strict;


=pod

=head1 GENERADOR DE CONTRASENAS


=head1 TAREA 1
		Parra Arroyo Fernando Marcos 


=head1 DESCRIPCION 
	   	El script recibe un parametro. La longitud de la contrasena que debera ser 
		un numero entero mayor a cero. Como salida mostrara en pantalla la contrasena 
		generada.

		Entrada:	
			perl 01fparra.pl 8

		Salida:
			Contrasena: 3,5%dV83

=cut


my $longitud = $ARGV[0]; #se guarda el primer argumento en el escalar longitud
my @letras = ('a'..'z','A'..'Z'); #arreglo con letras mayúsculas y minúsculas
my @numeros = (0..9);#arrgelo de números
my @simbolos = ('#','_','-',',','+','$','%','/','@'); # arreglo de símbolos
my @contrasena = (); #arreglo que guardará la contraseña
my $rand; #escalar para guardar número aleatorio

#se verifca que se haya recibido un parametro entero mayor a cero
if (not defined $longitud or not int $longitud or $longitud <= 0)
{
	die "ERROR Se necesita un entero mayor a cero como parámetro\n USO: perl 01fparra.pl longitud\n longitud int\n";
}

for(1..$longitud)
{	
	$rand= int(rand(12)); # se genera un número aleatorio de 0 a 12
	if ($rand>=0 and $rand<=3 ) { #si el número aleatorio está entre 0 y 3 añade una letra
		push @contrasena, $letras[int(rand(100))%@letras];
	} elsif ($rand>=4 and $rand<=7) { #si el número aleatorio está entre 4 y 7 añade una letra
		push @contrasena, $numeros[int(rand(100))%@numeros];
	} else { #en otro caso se añade un símbolo
		push @contrasena, $simbolos[int(rand(100))%@simbolos];
	}
	

};
print "Contraseña: ",@contrasena,"\n\n\n";


print "PRAGMA:\n";
print "Un pragma es modulo que modifica el comportamiento \nen la fase  compilación o ejecución de un programa\n";
print "Funcionan sólo cuando son llamados por \"use\" o \"no\"\n";
