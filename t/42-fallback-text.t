use strict;
use warnings;
use lib 't';
require 'test-util.pl';
use Test::More;
use Encode;
use Encode::JP::Emoji;
use Encode::JP::Emoji::FB_EMOJI_TEXT;
no utf8;    # utf-8 encoded but not flagged

plan tests => 24;

my $text;

$text = encode 'x-utf8-e4u-none-pp' => "\x{E63E}", FB_DOCOMO_TEXT();
is $text, '[晴れ]', 'SUN FB_DOCOMO_TEXT';
$text = encode 'x-utf8-e4u-none-pp' => "\x{E488}", FB_KDDIAPP_TEXT();
is $text, '[太陽]', 'SUN FB_KDDIAPP_TEXT';
$text = encode 'x-utf8-e4u-none-pp' => "\x{EF60}", FB_KDDIWEB_TEXT();
is $text, '[太陽]', 'SUN FB_KDDIWEB_TEXT';
$text = encode 'x-utf8-e4u-none-pp' => "\x{E04A}", FB_SOFTBANK_TEXT();
is $text, '[晴れ]', 'SUN FB_SOFTBANK_TEXT';

$text = encode 'x-utf8-e4u-none-pp' => "\x{E6B7}", FB_DOCOMO_TEXT();
is $text, '[soon]', 'SOON FB_DOCOMO_TEXT';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE018}", FB_GOOGLE_TEXT();
is $text, '[SOON]', 'SOON FB_GOOGLE_TEXT';

$text = encode 'x-utf8-e4u-none-pp' => "\x{E48A}", FB_KDDIAPP_TEXT();
is $text, '[雪の結晶]', 'SNOWFLAKE FB_KDDIAPP_TEXT';
$text = encode 'x-utf8-e4u-none-pp' => "\x{EF62}", FB_KDDIWEB_TEXT();
is $text, '[雪の結晶]', 'SNOWFLAKE FB_KDDIWEB_TEXT';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE00E}", FB_GOOGLE_TEXT();
is $text, '[雪結晶]', 'SNOWFLAKE FB_GOOGLE_TEXT';

$text = encode 'x-utf8-e4u-none-pp' => "\x{E15A}", FB_SOFTBANK_TEXT();
is $text, '[タクシー]', 'TAXI FB_SOFTBANK_TEXT';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE7EF}", FB_GOOGLE_TEXT();
is $text, '[タクシー]', 'TAXI FB_GOOGLE_TEXT';

$text = encode 'x-utf8-e4u-none-pp' => "\x{26FA}", FB_UNICODE_TEXT();
is $text, '[TENT]', 'TENT FB_UNICODE_TEXT';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE7FB}", FB_GOOGLE_TEXT();
is $text, '[キャンプ]', 'TENT FB_GOOGLE_TEXT';

####

$text = encode 'x-utf8-e4u-none-pp' => "\x{E63E}", FB_EMOJI_TEXT();
is $text, '[晴れ]', 'SUN FB_EMOJI_TEXT DOCOMO';
$text = encode 'x-utf8-e4u-none-pp' => "\x{EF60}", FB_EMOJI_TEXT();
is $text, '[太陽]', 'SUN FB_EMOJI_TEXT KDDIWEB';
$text = encode 'x-utf8-e4u-none-pp' => "\x{E04A}", FB_EMOJI_TEXT();
is $text, '[晴れ]', 'SUN FB_EMOJI_TEXT SOFTBANK';

$text = encode 'x-utf8-e4u-none-pp' => "\x{E6B7}", FB_EMOJI_TEXT();
is $text, '[soon]', 'SOON FB_EMOJI_TEXT DOCOMO';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE018}", FB_EMOJI_TEXT();
is $text, '[SOON]', 'SOON FB_EMOJI_TEXT GOOGLE';

$text = encode 'x-utf8-e4u-none-pp' => "\x{EF62}", FB_EMOJI_TEXT();
is $text, '[雪の結晶]', 'SNOWFLAKE FB_EMOJI_TEXT KDDIWEB';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE00E}", FB_EMOJI_TEXT();
is $text, '[雪結晶]', 'SNOWFLAKE FB_EMOJI_TEXT GOOGLE';

$text = encode 'x-utf8-e4u-none-pp' => "\x{E15A}", FB_EMOJI_TEXT();
is $text, '[タクシー]', 'TAXI FB_EMOJI_TEXT SOFTBANK';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE7EF}", FB_EMOJI_TEXT();
is $text, '[タクシー]', 'TAXI FB_EMOJI_TEXT GOOGLE';

$text = encode 'x-utf8-e4u-none-pp' => "\x{26FA}", FB_EMOJI_TEXT();
is $text, '[TENT]', 'TENT FB_UNICODE_TEXT';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE7FB}", FB_EMOJI_TEXT();
is $text, '[キャンプ]', 'TENT FB_GOOGLE_TEXT';
