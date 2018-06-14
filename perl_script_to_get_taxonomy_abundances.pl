#!/usr/bin/perl -w

use strict;
use warnings;

   my $entrada=$ARGV[0]; #classification file 
   my $entrada_1 = $ARGV[1]; #sample information
   my $salida = $ARGV[2]; #file with the information per sample 

          open (ENTRADA,"<$entrada") || die "ERROR: No puedo abrir el fichero $entrada\n";
          open (SALIDA,">$salida") || die "ERROR: No puedo abrir el fichero $salida\n";
              my %hash;
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
	       
                       
                     



while (my $data = <ENTRADA>)  {

    # get rid of the trailing linefeed
    chomp $data;

    # split the line into an array
    my @columns = split(/\t/, $data);

    # make the first column the key, and the second the value
    my $key = $columns[0];
    my $value = $columns[1];

    # add the key-value pair to the hash
    $hash{$key} = $value;

}

close ENTRADA;

open (ENTRADA_1,"<$entrada_1") || die "ERROR: No puedo abrir el fichero $entrada_1\n";

while (my $data = <ENTRADA_1>)  {
my @columns;
chomp $data;

@columns = split(/\t/, $data);

print "$columns[6]\n";

foreach my $key (keys %hash)
{
print "$key\n";
 if ($key eq $columns[6]) {
        print SALIDA "$hash{$key}\n";
    } 
  
 

}

print "End_______________________________\n";

}










#foreach my $key (keys %hash)
#{
#  print SALIDA "$key --------------> $hash{$key}\n";

#}  
                              
                              close ENTRADA_1;
                              close SALIDA;
                              
                 
             
                     





