#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Term::ANSIColor;


# This is a Poc for another repo, to show respect we will call this PoC squanch.sh 
# but since the name squancher.sh is too long just dev_sqch.sh
#
# Squanch your code but do not squanch at parties!
#
# Create nodes: {"ref","command","edges"}
# Create edges: {"ref","from","to","weight"} 
# Example:
# curl https://localhost.com:8080
# apache start 
# apcahe stad  
# apache start
# apache stop
# apache start
# apache stop
#
# result should be
# [
#  { "n0" , "apache start"},
#  { "n1" , "apache stad" },
#  { "n2" , "apache stop" },
# ]
# [ 
#  {"e0" , "n0", "n1" , "1"},
#  {"e1" , "n1", "n0" , "1"},
#  {"e2" , "n0", "n2" , "2"} 
# ] 
#
# Only collect the ones you do type the most... 
# Examples:
# apache start -2-> apache stop is preserved


# Use as history > history.txt 
# Sanitize, remove your delicate information. 
# then run this
open(my $fh, "<", "./hist.txt")
    or die "Can't open < hist.txt: $!";

my $before=0;
my %coms;
my %edges;

my $n_count = 0;
my $e_count = 0;
# Process every line in input.txt
while (my $line = readline($fh)) {
 chomp $line;
 if(exists $coms{$line}) {
 }
 else { 
   my $id   = "n$n_count";
   $coms{$line} = "$id $line";
   $n_count = $n_count + 1;
 }
  my $id = $e_count;
  my $pid  = "p$before";

  $edges{$id}  = "$id $line";
  $e_count = $e_count + 1; 
}


for(keys %coms) {
	print("$coms{$_}\n");
}
print("\n");

foreach my $key (sort { $a <=> $b} keys %edges) {
    print $edges{$key} . "\n";
}


