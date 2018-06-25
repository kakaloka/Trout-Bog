#!/usr/bin/perl -w
use strict;

my $file= $ARGV[0]; # genes_ID
my $filetwo= $ARGV[1];# fasta file

my $filesalida = $ARGV[2];



open (FILE, $file) || die;


my $ID;
my $sequence;
my $pattern;

my @inter_var;

while (my $line=<FILE>){

chomp($line);
$pattern= $line;

#print $pattern;
#print "---------";

open (FILETWO, $filetwo) || die;
my $c=0;

while (my $newline=<FILETWO>){

if (($newline =~ />/) && ($c==1)){

last;

}

if ($newline =~ />/) {

$c= 0;

}


 if ($newline =~ /$pattern/) {
  
  $c= 1;
  }

if ($c==1){

push (@inter_var, $newline);
#print $newline;

}

  

}
close FILETWO;

}

close FILE;
open(FILESALIDA, '>', $filesalida) or die;

print FILESALIDA @inter_var;

close FILESALIDA;


#

#
