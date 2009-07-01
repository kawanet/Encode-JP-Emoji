use strict;
use warnings;
use lib 't';
require 'test-util.pl';
use Test::More;
use Encode::JP::Emoji::PP;

my @outer   = qw(sjis utf8);
my @inner   = qw(emoji e4u);
my @carrier = qw(docomo kddi softbank softbank2g softbank3g google unicode none);

plan tests => 4 * @outer * @inner * @carrier;

for my $o (@outer) {
	for my $i (@inner) {
		for my $c (@carrier) {
			my $name = "x-$o-$i-$c";
		    my $encoding = Encode::find_encoding($name);
		    ok $encoding, "$name find_encoding";
		    ok $encoding->name, $name;
		}
	}
}

for my $o (@outer) {
	for my $i (@inner) {
		for my $c (@carrier) {
			my $name = "x-$o-$i-$c-pp";
		    my $encoding = Encode::find_encoding($name);
		    ok $encoding, "$name find_encoding";
		    ok $encoding->name, $name;
		}
	}
}
