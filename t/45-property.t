use strict;
use warnings;
use lib 't';
require 'test-util.pl';
use Test::More;
use Encode::JP::Emoji;
use Encode::JP::Emoji::Property;

plan tests => 24;

ok( "a" =~ /\p{ASCII}/,                  "ASCII ASCII" );
ok( "a" =~ /\P{InCJKUnifiedIdeographs}/, "ASCII InCJKUnifiedIdeographs" );
ok( "a" =~ /\P{InEmojiDocomoUnicode}/,   "ASCII InEmojiDocomoUnicode" );
ok( "a" =~ /\P{InEmojiKddiUnicode}/,     "ASCII InEmojiKddiUnicode" );
ok( "a" =~ /\P{InEmojiSoftbankUnicode}/, "ASCII InEmojiSoftbankUnicode" );
ok( "a" =~ /\P{InEmojiUnicodeUnicode}/,  "ASCII InEmojiUnicodeUnicode" );
ok( "a" =~ /\P{InEmojiGoogleUnicode}/,   "ASCII InEmojiGoogleUnicode" );
ok( "a" =~ /\P{InEmojiAnyUnicode}/,      "ASCII InEmojiAnyUnicode" );

ok( "\x{6F22}" =~ /\P{ASCII}/,                  "Kanji ASCII" );
ok( "\x{6F22}" =~ /\p{InCJKUnifiedIdeographs}/, "Kanji InCJKUnifiedIdeographs" );
ok( "\x{6F22}" =~ /\P{InEmojiDocomoUnicode}/,   "Kanji InEmojiDocomoUnicode" );
ok( "\x{6F22}" =~ /\P{InEmojiKddiUnicode}/,     "Kanji InEmojiKddiUnicode" );
ok( "\x{6F22}" =~ /\P{InEmojiSoftbankUnicode}/, "Kanji InEmojiSoftbankUnicode" );
ok( "\x{6F22}" =~ /\P{InEmojiUnicodeUnicode}/,  "Kanji InEmojiUnicodeUnicode" );
ok( "\x{6F22}" =~ /\P{InEmojiGoogleUnicode}/,   "Kanji InEmojiGoogleUnicode" );
ok( "\x{6F22}" =~ /\P{InEmojiAnyUnicode}/,      "Kanji InEmojiAnyUnicode" );

ok( "\x{FE000}" =~ /\P{ASCII}/,                  "Sun ASCII" );
ok( "\x{FE000}" =~ /\P{InCJKUnifiedIdeographs}/, "Sun InCJKUnifiedIdeographs" );
ok( "\x{E63E}"  =~ /\p{InEmojiDocomoUnicode}/,   "Sun InEmojiDocomoUnicode" );
ok( "\x{E488}"  =~ /\p{InEmojiKddiUnicode}/,     "Sun InEmojiKddiUnicode" );
ok( "\x{E04A}"  =~ /\p{InEmojiSoftbankUnicode}/, "Sun InEmojiSoftbankUnicode" );
ok( "\x{2600}"  =~ /\p{InEmojiUnicodeUnicode}/,  "Sun InEmojiUnicodeUnicode" );
ok( "\x{FE000}" =~ /\p{InEmojiGoogleUnicode}/,   "Sun InEmojiGoogleUnicode" );
ok( "\x{FE000}" =~ /\p{InEmojiAnyUnicode}/,      "Sun InEmojiAnyUnicode" );
