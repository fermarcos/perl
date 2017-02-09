#/usr/bin/perl
#Parra Arroyo Fernando Marcos
use strict;
use warnings;
use HTML::Template;

=pod

=head1 MOSTRAR PASSWD EN UN ARCHIVO HTML


=head1 NOMBRE
		Parra Arroyo Fernando Marcos 


=head1 DESCRIPCION 
		El script recibe como parametro el nombre del archivo con el contenido 
		de passwd y generara un archivo html que contiene la informacion del archivo 
		recibido como parametro.
		Para su ejecucion es necesario que el archivo template.tmpl se encuentre en la 
		misma carpeta que el archivo 03fparra.pl    	
	
		Entrada:	
			perl 03fparra.pl passwd.txt

		Salida:
			prueba.html

		Para visualizar el archivo se debe abrir con un navegador web
=cut

open FILEOUT,">prueba.html" or die "Error"; #se abre el archivo en modo escritura
print FILEOUT &showForm(); #se llama a la funcion showForm() la cual retorna el ccodigo html y se escribe en el archivo de salida
close FILEOUT; #se cierra el archivo creado

sub showForm{
		my $output; #variable donde se ira concatenando el codigo html
		my $template = HTML::Template->new(filename => './template.tmpl'); #abre el template html
		my $info=&pass_info; #se llama a la funcion pass_info
		my @loop_data=(); # se define un arrreglo que contendra los datos obtenidos del archivo para ser iterados en el template
		while(@{$info->[0]}){ 
				my %row_data; #se deine un hash que contendra los campos a ser desplegados
				$row_data{main}=shift @{$info->[0]};
				$row_data{user}=shift @{$info->[1]};
				$row_data{pass}=shift @{$info->[2]};
				$row_data{uid}=shift @{$info->[3]};
				$row_data{gid}=shift @{$info->[4]};
				$row_data{desc}=shift @{$info->[5]};
				$row_data{home}=shift @{$info->[6]};
				$row_data{shell}=shift @{$info->[7]};
				push(@loop_data,\%row_data); # se agrega al arreglo la referencia a los hash que contienen los campos de passwd
	
		}
		$template->param(entradas => \@loop_data);#se le pasan los parametros que seran iterados en el tmpl_loop
		$output.=$template->output(); #se van concatenando  la sustitucion de <TMPL_VAR> por el texto VALUE que ha especificado en la linea anterior
		#print $output;
		return $output;
}


sub pass_info()
{
	my %hash2;
	my $filename = $ARGV[0]; #se guarda el primer argumento en el escalar longitud
	my $argc = @ARGV; # número de argumentos


	if (not defined $filename or $argc != 1) #se verifca que se haya recibido un parametro entero mayor a cero
	{	
		die "ERROR Se necesita el nombre del archivo como parámetro\n USO: perl 02fparra.pl archivo\n ";
	}

	if(!open(FILEIN,"<",$filename))
	{
		die "ERROR NO SE PUEDE ABRIR el archivo ",$filename,"\n";
	}

	my @file=(<FILEIN>);
	for (@file){
		my %hash;
		if(m{(.*):(.*):(.*):(.*):(.*):(.*):(.*)}){ #expresion regular para obtener los campos de passwd
			$hash{"main"}=$&;
			$hash{"user"}=$1;
			$hash{"pass"}=$2;
			$hash{"uid"}=$3;
			$hash{"gid"}=$4;
			$hash{"desc"}=$5;
			$hash{"home"}=$6;			
			$hash{"shell"}=$7;
		}
		my $temp=$hash{"main"}; #cada linea del archivo passwd fungira como llave de hash2
		$hash2{$temp}=\%hash; #el valor de esas llaves sera la referencia del hash que contiene los campos de dicha linea del archivo
	}

	#arreglos para guardar los valores de los campos
	my @main = sort keys %hash2;
	my @user;
	my @pass;
	my @uid;
	my @gid;
	my @desc;
	my @home;
	my @shell;

	for my $main(sort keys %hash2)
	{
		#se optienen los valores de cada campo y se guardan en su correspondiente arreglo
		my @tmp=$hash2{$main}{user},"\n"||" "; 
		push(@user,shift @tmp);
		@tmp=$hash2{$main}{pass},"\n"||" ";
		push(@pass,shift @tmp);
		@tmp=$hash2{$main}{uid},"\n"||" ";
		push(@uid,shift @tmp);
		@tmp=$hash2{$main}{gid},"\n"||" ";
		push(@gid,shift @tmp);
		@tmp=$hash2{$main}{desc},"\n"||" ";
		push(@desc,shift @tmp);
		@tmp=$hash2{$main}{home},"\n"||" ";
		push(@home,shift @tmp);
		@tmp=$hash2{$main}{shell},"\n"||" ";
		push(@shell,shift @tmp);
	}	

	#while(@main){
	#        print "\n",shift @main;
	#        print "\n",shift @user;
	#        print "\n",shift @pass;
	#        print "\n",shift @uid;
	#       	print "\n",shift @gid;
	#	        print "\n",shift @desc;
	#	        print "\n",shift @home;
	#	        print "\n",shift @shell;
	#	}
	#	print "\n";
	my @info=(\@main,\@user,\@pass,\@uid,\@gid,\@desc,\@home,\@shell);
	return \@info;#retorna un arreglo con las referencias a los arreglos que contienen los valores de cada campo
}
close FILEIN; #se cierra el archhivo de entrada
