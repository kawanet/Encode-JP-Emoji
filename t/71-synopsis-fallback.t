use strict;
use warnings;
use lib 't';
require 'test-util.pl';
use Test::More;
no utf8;

plan tests => 4;

# ------------------------------------------------------------------------
    use Encode;
    use Encode::JP::Emoji;
    use Encode::JP::Emoji::Fallback;

    # DoCoMo Shift_JIS <SJIS+F89F> octets to DoCoMo fallback text "晴れ"
    my $sun = "\xF8\x9F";
    Encode::from_to($sun, 'x-sjis-emoji-docomo', 'x-sjis-e4u-none', FB_DOCOMO_TEXT());

    # KDDI UTF-8 <U+E598> octets to Google fallback text "霧"
    my $fog = "\xEE\x96\x98";
    Encode::from_to($fog, 'x-utf8-e4u-kddi', 'x-utf8-e4u-none', FB_GOOGLE_TEXT());

    # SoftBank UTF-8 <U+E524> string to SoftBank fallback text "ハムスター" on encoding
    my $hamster = "\x{E524}";
    my $softbank = Encode::encode('x-sjis-e4u-none', $hamster, FB_SOFTBANK_TEXT());

    # Google UTF-8 <U+FE1C1> octets to Google fallback text "クマ" on decoding
    my $bear = "\xF3\xBE\x87\x81";
    my $google = Encode::decode('x-utf8-e4u-none', $bear, FB_GOOGLE_TEXT());
# ------------------------------------------------------------------------

my $sjis1 = encode Shift_JIS => decode_utf8 '晴れ';
my $sjis2 = encode Shift_JIS => decode_utf8 'ハムスター';

is(($sun), ($sjis1), 'sun - docomo sjis - sjis');
is(($fog), ('霧'), 'fog - kddi utf8 - utf8');
is(($softbank), ($sjis2), 'hamster - softbank utf8 - sjis');
is(encode_utf8($google), ('クマ'), 'bear - google utf8 - utf8');
