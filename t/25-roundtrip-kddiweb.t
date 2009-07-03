use strict;
use warnings;
use lib 't';
require 'test-util.pl';
use Test::More;
use Encode;
use Encode::JP::Emoji;

my $encode1 = 'x-sjis-emoji-kddiweb-pp';
my $encode2 = 'x-sjis-e4u-kddiweb-pp';
my $encode3 = 'x-utf8-e4u-kddiweb-pp';
my $table = read_tsv('t/kddi-table.tsv');
my @keys = sort {$a cmp $b} keys %$table;

plan tests => scalar @keys;

foreach my $sjisH (@keys) {
    my $octS  = pack 'H*' => $sjisH;
    my $strA  = decode($encode2, $octS);
    my $octB  = encode($encode2, $strA);
	is(shex($octB), shex($octS), "$encode2 roundtrip $sjisH");
}
