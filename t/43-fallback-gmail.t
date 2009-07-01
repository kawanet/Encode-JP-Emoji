use strict;
use warnings;
use lib 't';
require 'test-util.pl';
use Test::More;
use Encode;
use Encode::JP::Emoji;
use Encode::JP::Emoji::Fallback::Gmail;

plan tests => 9;

my $text;

$text = encode 'x-utf8-e4u-none-pp' => "\x{E63E}", FB_DOCOMO_GMAIL();
like $text, qr[/mail/e/docomo_ne_jp/000], 'SUN FB_DOCOMO_GMAIL';
$text = encode 'x-utf8-e4u-none-pp' => "\x{E488}", FB_KDDI_GMAIL();
like $text, qr[/mail/e/ezweb_ne_jp/000], 'SUN FB_KDDI_GMAIL';
$text = encode 'x-utf8-e4u-none-pp' => "\x{E04A}", FB_SOFTBANK_GMAIL();
like $text, qr[/mail/e/softbank_ne_jp/000], 'SUN FB_SOFTBANK_GMAIL';

$text = encode 'x-utf8-e4u-none-pp' => "\x{E6B7}", FB_DOCOMO_GMAIL();
like $text, qr[/mail/e/docomo_ne_jp/018], 'SOON FB_DOCOMO_GMAIL';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE018}", FB_GOOGLE_GMAIL();
like $text, qr[/mail/e/018], 'SOON FB_GOOGLE_GMAIL';

$text = encode 'x-utf8-e4u-none-pp' => "\x{E48A}", FB_KDDI_GMAIL();
like $text, qr[/mail/e/ezweb_ne_jp/00E], 'SNOWFLAKE FB_KDDI_GMAIL';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE00E}", FB_GOOGLE_GMAIL();
like $text, qr[/mail/e/00E], 'SNOWFLAKE FB_GOOGLE_GMAIL';

$text = encode 'x-utf8-e4u-none-pp' => "\x{E15A}", FB_SOFTBANK_GMAIL();
like $text, qr[/mail/e/softbank_ne_jp/7EF], 'TAXI FB_SOFTBANK_GMAIL';
$text = encode 'x-utf8-e4u-none-pp' => "\x{FE7EF}", FB_GOOGLE_GMAIL();
like $text, qr[/mail/e/7EF], 'TAXI FB_GOOGLE_GMAIL';

