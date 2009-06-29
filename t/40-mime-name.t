use strict;
use warnings;
use lib 't';
require 'test-util.pl';
use Test::More;
use Encode::JP::Emoji;

my @sjis_encodings = qw(
    x-sjis-emoji-docomo-pp
    x-sjis-emoji-kddi-pp
    x-sjis-emoji-softbank-pp
    x-sjis-emoji-softbank2g-pp
    x-sjis-emoji-softbank3g-pp
    x-sjis-e4u-docomo-pp
    x-sjis-e4u-kddi-pp
    x-sjis-e4u-softbank-pp
    x-sjis-e4u-softbank2g-pp
    x-sjis-e4u-softbank3g-pp
    x-sjis-e4u-none-pp
);

my @utf8_encodings = qw(
    x-utf8-e4u-docomo-pp
    x-utf8-e4u-kddi-pp
    x-utf8-e4u-softbank-pp
    x-utf8-e4u-softbank2g-pp
    x-utf8-e4u-softbank3g-pp
    x-utf8-e4u-unicode-pp
    x-utf8-e4u-none-pp
);

plan tests => 2 * (@sjis_encodings + @utf8_encodings);

for my $name (@sjis_encodings) {
    my $encoding = Encode::find_encoding($name);
    ok $encoding, "$name find_encoding";
    is $encoding->mime_name, 'Shift_JIS', "$name mime_name Shift_JIS";
}
for my $name (@utf8_encodings) {
    my $encoding = Encode::find_encoding($name);
    ok $encoding, "$name find_encoding";
    next unless ref $encoding;
    is $encoding->mime_name, 'UTF-8', "$name mime_name UTF-8";
}
