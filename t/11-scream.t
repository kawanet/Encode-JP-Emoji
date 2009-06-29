use strict;
use warnings;
use lib 't';
require 'test-util.pl';
use Test::More;
use Encode;
use Encode::JP::Emoji;

plan tests => 22;

{
    my $sjis_docomo   = pack 'H*', 'F9FC';
    my $sjis_kddi     = pack 'H*', 'F7F5';
    my $sjis_softbank = pack 'H*', 'F747';
    my $strg_docomo   = chr hex 'E757';
    my $strg_kddi     = chr hex 'E5C5';
    my $strg_softbank = chr hex 'E107';
    my $strg_google   = chr hex 'FE341';
    my $utf8_docomo   = encode 'utf8' => $strg_docomo;
    my $utf8_kddi     = encode 'utf8' => $strg_kddi;
    my $utf8_softbank = encode 'utf8' => $strg_softbank;

    is(ohex($sjis_docomo),   '\xF9\xFC',  'octets docomo sjis');
    is(ohex($sjis_kddi),     '\xF7\xF5',  'octets kddi sjis');
    is(ohex($sjis_softbank), '\xF7\x47',  'octets softbank sjis');
    is(shex($strg_google),   '\x{FE341}', 'string google utf8');

    is(ohex(encode('x-sjis-emoji-docomo-pp', $strg_docomo)), ohex($sjis_docomo), 'encode docomo sjis - docomo utf8');
    is(shex(decode('x-sjis-emoji-docomo-pp', $sjis_docomo)), shex($strg_docomo), 'decode docomo sjis - docomo utf8');
    is(ohex(encode('x-sjis-e4u-docomo-pp', $strg_google)), ohex($sjis_docomo), 'encode docomo sjis - google utf8');
    is(shex(decode('x-sjis-e4u-docomo-pp', $sjis_docomo)), shex($strg_google), 'decode docomo sjis - google utf8');
    is(ohex(encode('x-utf8-e4u-docomo-pp', $strg_google)), ohex($utf8_docomo), 'encode docomo utf8 - google utf8');
    is(shex(decode('x-utf8-e4u-docomo-pp', $utf8_docomo)), shex($strg_google), 'decode docomo utf8 - google utf8');

    is(ohex(encode('x-sjis-emoji-kddi-pp', $strg_kddi)), ohex($sjis_kddi), 'encode kddi sjis - kddi utf8');
    is(shex(decode('x-sjis-emoji-kddi-pp', $sjis_kddi)), shex($strg_kddi), 'decode kddi sjis - kddi utf8');
    is(ohex(encode('x-sjis-e4u-kddi-pp', $strg_google)), ohex($sjis_kddi), 'encode kddi sjis - google utf8');
    is(shex(decode('x-sjis-e4u-kddi-pp', $sjis_kddi)), shex($strg_google), 'decode kddi sjis - google utf8');
    is(ohex(encode('x-utf8-e4u-kddi-pp', $strg_google)), ohex($utf8_kddi), 'encode kddi utf8 - google utf8');
    is(shex(decode('x-utf8-e4u-kddi-pp', $utf8_kddi)), shex($strg_google), 'decode kddi utf8 - google utf8');

    is(ohex(encode('x-sjis-emoji-softbank-pp', $strg_softbank)), ohex($sjis_softbank), 'encode softbank sjis - softbank utf8');
    is(shex(decode('x-sjis-emoji-softbank-pp', $sjis_softbank)), shex($strg_softbank), 'decode softbank sjis - softbank utf8');
    is(ohex(encode('x-sjis-e4u-softbank-pp', $strg_google)), ohex($sjis_softbank), 'encode softbank sjis - google utf8');
    is(shex(decode('x-sjis-e4u-softbank-pp', $sjis_softbank)), shex($strg_google), 'decode softbank sjis - google utf8');
    is(ohex(encode('x-utf8-e4u-softbank-pp', $strg_google)), ohex($utf8_softbank), 'encode softbank utf8 - google utf8');
    is(shex(decode('x-utf8-e4u-softbank-pp', $utf8_softbank)), shex($strg_google), 'decode softbank utf8 - google utf8');
}
