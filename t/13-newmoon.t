use strict;
use warnings;
use lib 't';
require 'test-util.pl';
use Test::More;
use Encode;
use Encode::JP::Emoji;

plan tests => 24;

{
    my $sjis_docomo   = pack 'H*', 'F940';
    my $sjis_kddi     = pack 'H*', 'F767';
    my $sjis_softbank = pack 'H*', 'F7BA';
    my $strg_docomo   = chr hex 'E69C';
    my $strg_kddi     = chr hex 'E54B';
    my $strg_softbank = chr hex 'E21A';
    my $goog_docomo   = chr hex 'FE011';
    my $goog_kddi     = chr hex 'FEB64';
    my $goog_softbank = chr hex 'FEB64';
    my $utf8_docomo   = encode 'utf8' => $strg_docomo;
    my $utf8_kddi     = encode 'utf8' => $strg_kddi;
    my $utf8_softbank = encode 'utf8' => $strg_softbank;

    is(ohex($sjis_docomo),   '\xF9\x40',  'octets docomo sjis');
    is(ohex($sjis_kddi),     '\xF7\x67',  'octets kddi sjis');
    is(ohex($sjis_softbank), '\xF7\xBA',  'octets softbank sjis');
    is(shex($goog_docomo),    '\x{FE011}', 'string docomo google utf8');
    is(shex($goog_kddi),      '\x{FEB64}', 'string kddi google utf8');
    is(shex($goog_softbank),  '\x{FEB64}', 'string softbank google utf8');

    is(ohex(encode('x-sjis-emoji-docomo-pp', $strg_docomo)), ohex($sjis_docomo), 'encode docomo sjis - docomo utf8');
    is(shex(decode('x-sjis-emoji-docomo-pp', $sjis_docomo)), shex($strg_docomo), 'decode docomo sjis - docomo utf8');
    is(ohex(encode('x-sjis-e4u-docomo-pp', $goog_docomo)), ohex($sjis_docomo), 'encode docomo sjis - google utf8');
    is(shex(decode('x-sjis-e4u-docomo-pp', $sjis_docomo)), shex($goog_docomo), 'decode docomo sjis - google utf8');
    is(ohex(encode('x-utf8-e4u-docomo-pp', $goog_docomo)), ohex($utf8_docomo), 'encode docomo utf8 - google utf8');
    is(shex(decode('x-utf8-e4u-docomo-pp', $utf8_docomo)), shex($goog_docomo), 'decode docomo utf8 - google utf8');

    is(ohex(encode('x-sjis-emoji-kddi-pp', $strg_kddi)), ohex($sjis_kddi), 'encode kddi sjis - kddi utf8');
    is(shex(decode('x-sjis-emoji-kddi-pp', $sjis_kddi)), shex($strg_kddi), 'decode kddi sjis - kddi utf8');
    is(ohex(encode('x-sjis-e4u-kddi-pp', $goog_kddi)), ohex($sjis_kddi), 'encode kddi sjis - google utf8');
    is(shex(decode('x-sjis-e4u-kddi-pp', $sjis_kddi)), shex($goog_kddi), 'decode kddi sjis - google utf8');
    is(ohex(encode('x-utf8-e4u-kddi-pp', $goog_kddi)), ohex($utf8_kddi), 'encode kddi utf8 - google utf8');
    is(shex(decode('x-utf8-e4u-kddi-pp', $utf8_kddi)), shex($goog_kddi), 'decode kddi utf8 - google utf8');

    is(ohex(encode('x-sjis-emoji-softbank-pp', $strg_softbank)), ohex($sjis_softbank), 'encode softbank sjis - softbank utf8');
    is(shex(decode('x-sjis-emoji-softbank-pp', $sjis_softbank)), shex($strg_softbank), 'decode softbank sjis - softbank utf8');
    is(ohex(encode('x-sjis-e4u-softbank-pp', $goog_softbank)), ohex($sjis_softbank), 'encode softbank sjis - google utf8');
    is(shex(decode('x-sjis-e4u-softbank-pp', $sjis_softbank)), shex($goog_softbank), 'decode softbank sjis - google utf8');
    is(ohex(encode('x-utf8-e4u-softbank-pp', $goog_softbank)), ohex($utf8_softbank), 'encode softbank utf8 - google utf8');
    is(shex(decode('x-utf8-e4u-softbank-pp', $utf8_softbank)), shex($goog_softbank), 'decode softbank utf8 - google utf8');
}
