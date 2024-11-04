#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Term::ANSIColor;

print colored( sprintf("================================= Calendar =================================\n"), 'bold cyan' );

my $type = 0;
my $name = 1;
my $month = 2;
my $day = 3;
my $filename = 'calendar.dcal';
my %calendar;
my %months = ( "[01]" => "JAN",
               "[02]" => "FEB",
               "[03]" => "MAR",
               "[04]" => "APR",
               "[05]" => "MAY",
               "[06]" => "JUN",
               "[07]" => "JUL",
               "[08]" => "AUG",
               "[09]" => "SEP",
               "[10]" => "OCT",
	       "[11]" => "NOV",
               "[12]" => "DEC");
open(FH, '<', $filename) or die $!;
while(<FH>){
  my @input = (); 
  @input=($_=~/(\[.*?\])/g);
  my @bday = check_birthday(@input); 
  if(exists $calendar{$bday[$month]}){
	  my @ca = $calendar{$bday[$month]}->@*;
	  push(@ca,\@bday);
	  @ca = sort{ $a->[$day] cmp $b->[$day] } @ca;
	  $calendar{$bday[$month]}=\@ca;
  } else {
   my @month = ();	  
   push(@month,\@bday);
   $calendar{$bday[$month]}=\@month;
  }
}


foreach my $key (sort { $a cmp $b} keys %months) {
     print colored( sprintf("$months{$key}\n"), 'bold cyan' );
     generate_calendar($key,\%calendar);
}
sub check_birthday {
  
 if($_[$type] ne "[B]") { 
    return 
  }
  if($_[$name] eq  "") {
   return 
  }
  return @_;
}


sub generate_calendar {
  if($_[1]->{$_[0]}) {
  my @bdays = $_[1]->{$_[0]}->@*;
  if(ref(\$bdays[0]) eq "REF") {
   my @ref = @{$_[1]->{$_[0]}};
    for my $aref ( @ref ) {
	print colored( sprintf("@$aref\n"), 'bold yellow' );
    }
  } else {
        print colored( sprintf("@bdays\n"), 'bold yellow' );
   }
  }
}
