#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Benchmark qw(:hireswallclock);
use lib qw(lib);
use Encode::JP::Emoji;
use Encode::JP::Mobile;

my @tmp;
my $c = 0;
my $try = 1000;
my $len = 1000;
my $car;

sub main {
 foreach my $mycar (@ARGV){
  $car = $mycar;
  print "$car $try\n";
  foreach my $i (0 .. $try*2) {
    $tmp[$i] = join "" => map{chr int(rand(0xD7E0)+32) } 1 .. $len; 
  }

  Benchmark::cmpthese($try, {
    mobile => \&mobile,
    emoji  => \&emoji,
  });
 }
}

sub mobile {
  Encode::decode "x-sjis-$car" => 
	Encode::encode( "x-sjis-$car", $tmp[$c++ % $#tmp] );
}

sub emoji {
  Encode::decode "x-sjis-emoji-$car-pp" => 
	Encode::encode( "x-sjis-emoji-$car-pp", $tmp[$c++ % $#tmp] );
}

main();
