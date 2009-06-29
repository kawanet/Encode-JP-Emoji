use strict;
use warnings;
use lib 't';
require 'test-util.pl';
use Test::More;
use Encode;
use Encode::JP::Emoji;
use Encode::JP::Emoji::Fallback;

plan tests => 9;

my $text;

$text = encode 'x-utf8-e4u-none-pp' => "\x{E63E}", FB_DOCOMO_HTML();
like $text, qr[docomo_ne_jp/000], 'SUN FB_DOCOMO_HTML';
$text = encode 'x-utf8-e4u-none-pp' => "\x{E488}", FB_KDDI_HTML();
like $text, qr[ezweb_ne_jp/000], 'SUN FB_KDDI_HTML';
$text = encode 'x-utf8-e4u-none-pp' => "\x{E04A}", FB_SOFTBANK_HTML();
like $text, qr[softbank_ne_jp/000], 'SUN FB_SOFTBANK_HTML';

$text = encode 'x-utf8-e4u-none-pp' => "\x{E6B7}", FB_DOCOMO_HTML();
like $text, qr[docomo_ne_jp/018], 'SOON FB_DOCOMO_HTML';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE018}", FB_GOOGLE_HTML();
like $text, qr[google_com/018], 'SOON FB_GOOGLE_HTML';

$text = encode 'x-utf8-e4u-none-pp' => "\x{E48A}", FB_KDDI_HTML();
like $text, qr[ezweb_ne_jp/00E], 'SNOWFLAKE FB_KDDI_HTML';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE00E}", FB_GOOGLE_HTML();
like $text, qr[google_com/00E], 'SNOWFLAKE FB_GOOGLE_HTML';

$text = encode 'x-utf8-e4u-none-pp' => "\x{E15A}", FB_SOFTBANK_HTML();
like $text, qr[softbank_ne_jp/7EF], 'TAXI FB_SOFTBANK_HTML';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE7EF}", FB_GOOGLE_HTML();
like $text, qr[google_com/7EF], 'TAXI FB_GOOGLE_HTML';

