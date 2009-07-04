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
    use Encode::JP::Emoji::FB_EMOJI_TEXT;

    # DoCoMo Shift_JIS <SJIS+F89F> octets to fallback to DoCoMo name "[晴れ]"
    my $sun = "\xF8\x9F";
    Encode::from_to($sun, 'x-sjis-emoji-docomo', 'x-sjis-e4u-none', FB_DOCOMO_TEXT());

    # KDDI UTF-8 <U+E598> octets to fallback to Google name "[霧]"
    my $fog = "\xEE\x96\x98";
    Encode::from_to($fog, 'x-utf8-e4u-kddiapp', 'x-utf8-e4u-none', FB_GOOGLE_TEXT());

    # SoftBank UTF-8 <U+E524> string to fallback to SoftBank name "[ハムスター]"
    my $hamster = "\x{E524}";
    my $softbank = Encode::encode('x-sjis-e4u-none', $hamster, FB_SOFTBANK_TEXT());

    # Google UTF-8 <U+FE1C1> octets to fallback to Google name "[クマ]"
    my $bear = "\xF3\xBE\x87\x81";
    my $google = Encode::decode('x-utf8-e4u-none', $bear, FB_GOOGLE_TEXT());
# ------------------------------------------------------------------------

my $exp1 = encode Shift_JIS => decode_utf8 '[晴れ]';
my $exp2 = '[霧]';
my $exp3 = encode Shift_JIS => decode_utf8 '[ハムスター]';
my $exp4 = '[クマ]';

is(($sun), $exp1, 'sun - docomo sjis - sjis');
is(($fog), $exp2, 'fog - kddi utf8 - utf8');
is(($softbank), $exp3, 'hamster - softbank utf8 - sjis');
is(encode_utf8($google), $exp4, 'bear - google utf8 - utf8');
