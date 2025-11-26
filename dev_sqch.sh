#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Term::ANSIColor;

# This is a Poc for another repo, to show respect we will call this PoC squanch.sh 
# but since the name squancher.sh is too long just dev_sqch.sh
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
# 

# Use as history > history.txt 
# Sanitize, remove your delicate information. 
# then run this
open(my $fh, "<", "./history.txt")
    or die "Can't open < input.txt: $!";

# Process every line in input.txt
while (my $line = readline($fh)) {

}
