#!/usr/bin/perl

use strict;
use warnings;

print("Loading Calendar\n");

my $filename = 'calendar.dcal';
my @array = ();
open(FH, '<', $filename) or die $!;
while(<FH>){
  print "$_\n";	
  @array=($_=~/(\[.\]|\[\d\{0-2\}\]|\[\w*\])/g);
  check_
}
print "@array\n";


sub parse_birthday {}
sub parse_appointment {}
