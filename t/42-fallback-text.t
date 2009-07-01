use strict;
use warnings;
use lib 't';
require 'test-util.pl';
use Test::More;
use Encode;
use Encode::JP::Emoji;
use Encode::JP::Emoji::Fallback;
no utf8;    # utf-8 encoded but not flagged

plan tests => 9;

my $text;

$text = encode 'x-utf8-e4u-none-pp' => "\x{E63E}", FB_DOCOMO_TEXT();
is $text, '[晴れ]', 'SUN FB_DOCOMO_TEXT';
$text = encode 'x-utf8-e4u-none-pp' => "\x{E488}", FB_KDDI_TEXT();
is $text, '[太陽]', 'SUN FB_KDDI_TEXT';
$text = encode 'x-utf8-e4u-none-pp' => "\x{E04A}", FB_SOFTBANK_TEXT();
is $text, '[晴れ]', 'SUN FB_SOFTBANK_TEXT';

$text = encode 'x-utf8-e4u-none-pp' => "\x{E6B7}", FB_DOCOMO_TEXT();
is $text, '[soon]', 'SOON FB_DOCOMO_TEXT';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE018}", FB_GOOGLE_TEXT();
is $text, '[SOON]', 'SOON FB_GOOGLE_TEXT';

$text = encode 'x-utf8-e4u-none-pp' => "\x{E48A}", FB_KDDI_TEXT();
is $text, '[雪の結晶]', 'SNOWFLAKE FB_KDDI_TEXT';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE00E}", FB_GOOGLE_TEXT();
is $text, '[雪結晶]', 'SNOWFLAKE FB_GOOGLE_TEXT';

$text = encode 'x-utf8-e4u-none-pp' => "\x{E15A}", FB_SOFTBANK_TEXT();
is $text, '[タクシー]', 'TAXI FB_SOFTBANK_TEXT';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE7EF}", FB_GOOGLE_TEXT();
is $text, '[タクシー]', 'TAXI FB_GOOGLE_TEXT';

