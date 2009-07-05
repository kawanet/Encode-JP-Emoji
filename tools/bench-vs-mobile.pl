#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Benchmark qw(:hireswallclock);
use lib qw(lib ../lib);
use Encode::JP::Emoji;
use Encode::JP::Mobile;

my @tmp;
my $c = 0;
my $try = 1000;
my $len = 1000;
my $emoenc;
my $mobenc;

unless (@ARGV) {
    print STDERR "Usage: $0 docomo kddi softbank\n";
    exit 1;
}

sub main {
    foreach my $mycar (@ARGV){
        my $translate = {qw(docomo docomo kddi kddiweb softbank softbank3g)};
        my $emocar = $translate->{$mycar} or die "Invalid name: $mycar\n";
        $emoenc = "x-sjis-emoji-$emocar-pp";
        $mobenc = "x-sjis-$mycar";

        print "$mycar $try\n";
        foreach my $i (0 .. $try*2) {
            $tmp[$i] = join "" => map{chr int(rand(0xD7E0)+32) } 1 .. $len; 
        }

        Benchmark::cmpthese($try, {
            emoji  => \&emoji,
            mobile => \&mobile,
        });
    }
}

sub mobile {
    Encode::decode($mobenc => Encode::encode($mobenc => $tmp[$c++ % $#tmp]));
}

sub emoji {
    Encode::decode($emoenc => Encode::encode($emoenc => $tmp[$c++ % $#tmp]));
}

main();
