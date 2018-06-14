#!/usr/bin/perl 

use strict;
use warnings;

   my $entrada=$ARGV[0]; #file con la lista
  my $entrada_1 = $ARGV[1]; #file con la infomacion por muestra
   #my $salida = $ARGV[2]; #salida 

          open (ENTRADA,"<$entrada") || die "ERROR: No puedo abrir el fichero $entrada\n";
#          open (SALIDA,">$salida") || die "ERROR: No puedo abrir el fichero $salida\n";
#               my @subLine;
#              print ("Read\t"."Clasification\t"."Presence");
#              print ("\n");
#              while (my $line=<ENTRADA>){
#              my $c=0;
#              my $t=0;
#              my $suma=0;
              
#                       print $line;
#                               print "--------------------------------";
#                               chomp $line;
#                       my @newline = split("\t", $line);
                       #$hash{$newline[0]} = $newline[1];
	       
                       
                     

my @phylalist;

while (my $data = <ENTRADA>)  {

    # get rid of the trailing linefeed
    chomp $data;

   push(@phylalist,$data);

}

close ENTRADA;

foreach my $element (@phylalist)
{
print "$element"." ";
} 
print "\n"; 

open (ENTRADA_1,"<$entrada_1") || die "ERROR: No puedo abrir el fichero $entrada_1\n";



my $count;
my $find;
my @all_file;


open (ENTRADA_1,"<$entrada_1") || die "ERROR: No puedo abrir el fichero $entrada_1\n";

while (my $line = <ENTRADA_1>)  {

chomp $line;
push (@all_file,$line);


}




close ENTRADA_1;

my @columns;

foreach my $element (@phylalist)


{



$find=0;




foreach my $new_element (@all_file){

@columns = split( /\s|,/, $new_element);

 if ($columns[$#columns] =~ $element) {
      $find=1; 
      print $columns[$#columns-1]." ";
  } 
  
 
}



if ($find==0){

print "0"." ";

  
}

}

print "\n";










#foreach my $key (keys %hash)
#{
#  print SALIDA "$key --------------> $hash{$key}\n";

#}  
                              
                             close ENTRADA_1;
  #                            close SALIDA;
                              
                 
             
                     





