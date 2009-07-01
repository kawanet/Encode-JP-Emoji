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
    use Encode::JP::Emoji::Fallback::Gmail;

    # DoCoMo Shift_JIS <SJIS+F89F> octets
    my $sun = "\xF8\x9F";
    Encode::from_to($sun, 'x-sjis-emoji-docomo', 'x-sjis-emoji-none', FB_DOCOMO_GMAIL());

    # KDDI UTF-8 <U+E598> octets
    my $fog = "\xEE\x96\x98";
    Encode::from_to($fog, 'x-utf8-emoji-kddi', 'x-utf8-emoji-none', FB_KDDI_GMAIL());

    # SoftBank UTF-8 <U+E524> string
    my $hamster = "\x{E524}";
    my $softbank = Encode::encode('x-sjis-e4u-none', $hamster, FB_SOFTBANK_GMAIL());

    # Google UTF-8 <U+FE1C1> octets
    my $bear = "\xF3\xBE\x87\x81";
    my $google = Encode::decode('x-utf8-e4u-none', $bear, FB_GOOGLE_GMAIL());
# ------------------------------------------------------------------------

like(($sun), qr#<img .*/000#, 'sun - docomo sjis - sjis');
like(($fog), qr#<img .*/006#, 'fog - kddi utf8 - utf8');
like(($softbank), qr#<img .*/1CA#, 'hamster - softbank utf8 - sjis');
like(encode_utf8($google), qr#<img .*/1C1#, 'bear - google utf8 - utf8');
