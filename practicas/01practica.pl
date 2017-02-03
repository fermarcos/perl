#!perl 
#Parra Arroyo Fernando Marcos
use warnings;
use strict;

my @num=(1..10);
my @pares=();

for(@num)
{ 
	if($_ %2 ==0)
	{
		push @pares,$_;
	}
};
print @pares,"\n";
