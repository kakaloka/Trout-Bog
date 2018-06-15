#!/usr/bin/perl 

use strict;
use warnings;

   my $entrada=$ARGV[0]; #file con la lista ordenada
  my $entrada_1 = $ARGV[1]; #file con la infomacion por muestra sin orden
   #my $salida = $ARGV[2]; #salida 

          open (ENTRADA,"<$entrada") || die "ERROR: No puedo abrir el fichero $entrada\n";
#          open (SALIDA,">$salida") || die "ERROR: No puedo abrir el fichero $salida\n";

                       
                     

my @phylalist;

while (my $data = <ENTRADA>)  {

    # get rid of the trailing linefeed
    chomp $data;

   push(@phylalist,$data);

}

close ENTRADA;






my $count;
my $find;
my @all_file;


open (ENTRADA_1,"<$entrada_1") || die "ERROR: No puedo abrir el fichero $entrada_1\n";

while (my $line = <ENTRADA_1>)  {

chomp $line;
push (@all_file,$line);


}

print $all_file[0];
print "\n"; 


close ENTRADA_1;

my @columns;

foreach my $element (@phylalist)


{



$find=0;




foreach my $new_element (@all_file){

@columns = split( /\s|,/, $new_element);

 if ($columns[0] =~ $element) {
      $find=1;
      print $new_element;
      print "\n";
  } 
  
 
}





}

print "\n";










                              
