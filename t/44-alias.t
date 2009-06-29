use strict;
use warnings;
use lib 't';
require 'test-util.pl';
use Test::More;
use Encode::JP::Emoji::PP;

my @sjis_encodings = qw(
    x-sjis-emoji-docomo
    x-sjis-emoji-kddi
    x-sjis-emoji-softbank
    x-sjis-emoji-softbank2g
    x-sjis-emoji-softbank3g
    x-sjis-e4u-docomo
    x-sjis-e4u-kddi
    x-sjis-e4u-softbank
    x-sjis-e4u-softbank2g
    x-sjis-e4u-softbank3g
    x-sjis-e4u-none
);

my @utf8_encodings = qw(
    x-utf8-e4u-docomo
    x-utf8-e4u-kddi
    x-utf8-e4u-softbank
    x-utf8-e4u-softbank2g
    x-utf8-e4u-softbank3g
    x-utf8-e4u-google
    x-utf8-e4u-unicode
    x-utf8-e4u-none
);

plan tests => 2 * (@sjis_encodings + @utf8_encodings);

for my $name (@sjis_encodings) {
    my $encoding = Encode::find_encoding($name);
    ok $encoding, "$name find_encoding";
    is $encoding->name, $name.'-pp', $name;
}
for my $name (@utf8_encodings) {
    my $encoding = Encode::find_encoding($name);
    ok $encoding, "$name find_encoding";
    next unless ref $encoding;
    is $encoding->name, $name.'-pp', $name;
}
