use strict;
use warnings;
use lib 't';
require 'test-util.pl';
use Test::More;
use Encode::JP::Emoji;

my @encodings = qw(
    x-sjis-emoji-docomo
    x-sjis-emoji-kddi
    x-sjis-emoji-kddiweb
    x-sjis-emoji-softbank
    x-sjis-emoji-softbank2g
    x-sjis-emoji-softbank3g
    x-utf8-emoji-docomo
    x-utf8-emoji-kddi
    x-utf8-emoji-kddiweb
    x-utf8-emoji-softbank
    x-utf8-emoji-softbank2g
    x-utf8-emoji-softbank3g
    x-utf8-emoji-google
    x-utf8-emoji-unicode
    x-sjis-e4u-docomo
    x-sjis-e4u-kddi
    x-sjis-e4u-kddiweb
    x-sjis-e4u-softbank
    x-sjis-e4u-softbank2g
    x-sjis-e4u-softbank3g
    x-utf8-e4u-docomo
    x-utf8-e4u-kddi
    x-utf8-e4u-kddiweb
    x-utf8-e4u-softbank
    x-utf8-e4u-softbank2g
    x-utf8-e4u-softbank3g
    x-utf8-e4u-google
    x-utf8-e4u-unicode
    x-sjis-emoji-none
    x-utf8-emoji-none
    x-sjis-e4u-none
    x-utf8-e4u-none
);

plan tests => 4 * @encodings;

for my $name (@encodings) {
	my $base = ($name =~ /^x-sjis-/ ? 'Shift_JIS' : 'UTF-8');

    my $encoding = Encode::find_encoding($name);
    ok $encoding, "$name find_encoding";
    is $encoding->mime_name, $base, "$name mime_name $base";

	$name .= '-pp';
    $encoding = Encode::find_encoding($name);
    ok $encoding, "$name find_encoding";
    is $encoding->mime_name, $base, "$name mime_name $base";
}
