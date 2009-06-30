=head1 NAME

Encode::JP::Emoji::Fallback - Emoji fallback functions

=head1 SYNOPSIS

    use Encode;
    use Encode::JP::Emoji;
    use Encode::JP::Emoji::Fallback;

    # DoCoMo Shift_JIS <SJIS+F89F> octets to DoCoMo fallback text "晴れ"
    my $sun = "\xF8\x9F";
    Encode::from_to($sun, 'x-sjis-emoji-docomo', 'x-sjis-e4u-none', FB_DOCOMO_TEXT());

    # KDDI UTF-8 <U+E598> octets to KDDI fallback text "霧"
    my $fog = "\xEE\x96\x98";
    Encode::from_to($fog, 'x-utf8-e4u-kddi', 'x-utf8-e4u-none', FB_GOOGLE_TEXT());

    # SoftBank UTF-8 <U+E524> string to Google fallback text "ハムスター" on encoding
    my $hamster = "\x{E524}";
    my $softbank = Encode::encode('x-sjis-e4u-none', $hamster, FB_SOFTBANK_TEXT());

    # Google UTF-8 <U+FE1C1> octets to Google fallback text "クマ" on decoding
    my $bear = "\xF3\xBE\x87\x81";
    my $google = Encode::decode('x-utf8-e4u-none', $bear, FB_GOOGLE_TEXT());

=head1 DESCRIPTION

This module exports the following fallback functions which are used with
C<x-sjis-e4u-none> and C<x-utf8-e4u-none> encodings which rejects any emojis.

=head2 FB_DOCOMO_TEXT()

This returns emoji name defined by DoCoMo.
Note that this works only for DoCoMo's private emoji code points: U+E63E ... U+E757.

=head2 FB_KDDI_TEXT()

This returns emoji name defined by KDDI.
Note that this works only for KDDI's private emoji code points: U+E468 ... U+EB8E.

=head2 FB_SOFTBANK_TEXT()

This returns emoji name defined by SoftBank.
Note that this works only for SoftBank's private emoji code points: U+E001 ... U+E53E.

=head2 FB_GOOGLE_TEXT()

This returns emoji name defined by emoji4unicode project on Google Code.
Note that this works only for Google's private emoji code points: U+FE000 ... U+FEEA0.

=head2 FB_UNICODE_TEXT()

This will return character name defined on the Unicode Standard.
Note that this works only for emojis which has a standard code point.

=head2 FB_DOCOMO_HTML($format)

These return HTML string which has an C<img> element instead of emoji name.
You need to specify formatting string for C<sprintf()>.
Note that this works only for DoCoMo's private emoji code points
but provides Google's private code point for C<sprintf()>'s first argument.

=head2 FB_KDDI_HTML($format)

This works only for KDDI's private emoji code points
but provides Google's private code point for C<sprintf()>.

=head2 FB_SOFTBANK_HTML($format)

This works only for SoftBank's private emoji code points
but provides Google's private code point for C<sprintf()>.

=head2 FB_GOOGLE_HTML($format)

This works only for Google's private emoji code points.

=head2 FB_UNICODE_HTML($format)

This works only for emojis which has a standard code point.

=head1 AUTHOR

Yusuke Kawasaki, L<http://www.kawa.net/>

=head1 SEE ALSO

L<Encode::JP::Emoji>

=head1 COPYRIGHT

Copyright 2009 Yusuke Kawasaki, all rights reserved.

=cut

package Encode::JP::Emoji::Fallback;
use strict;
use warnings;
use base 'Exporter';

our $VERSION = '0.02';

our @EXPORT = qw(
    FB_DOCOMO_TEXT FB_KDDI_TEXT FB_SOFTBANK_TEXT FB_GOOGLE_TEXT FB_UNICODE_TEXT
    FB_DOCOMO_HTML FB_KDDI_HTML FB_SOFTBANK_HTML FB_GOOGLE_HTML FB_UNICODE_HTML
);

our $HEX_FORMAT      = '%04X';
our $XMLCREF_FORMAT  = '&#x%04X;';
our $DOCOMO_FORMAT   = '<img src="http://mail.google.com/mail/e/docomo_ne_jp/%03X" class="e" />';
our $KDDI_FORMAT     = '<img src="http://mail.google.com/mail/e/ezweb_ne_jp/%03X" class="e" />';
our $SOFTBANK_FORMAT = '<img src="http://mail.google.com/mail/e/softbank_ne_jp/%03X" class="e" />';
our $GOOGLE_FORMAT   = '<img src="http://mail.google.com/mail/e/google_com/%03X" class="e" />';
our $UNICODE_FORMAT  = '<img src="http://mail.google.com/mail/e/google_com/%03X" class="e" />';

sub FB_DOCOMO_TEXT {
    sub {
        my $code = shift;
        my $hex  = sprintf $HEX_FORMAT => $code;
        return sprintf $XMLCREF_FORMAT => $code unless exists $Encode::JP::Emoji::Mapping::CharnamesEmojiDocomo{$hex};
        $Encode::JP::Emoji::Mapping::CharnamesEmojiDocomo{$hex};
    }
}

sub FB_KDDI_TEXT {
    sub {
        my $code = shift;
        my $hex  = sprintf $HEX_FORMAT => $code;
        return sprintf $XMLCREF_FORMAT => $code unless exists $Encode::JP::Emoji::Mapping::CharnamesEmojiKddi{$hex};
        $Encode::JP::Emoji::Mapping::CharnamesEmojiKddi{$hex};
    };
}

sub FB_SOFTBANK_TEXT {
    sub {
        my $code = shift;
        my $hex  = sprintf $HEX_FORMAT => $code;
        return sprintf $XMLCREF_FORMAT => $code unless exists $Encode::JP::Emoji::Mapping::CharnamesEmojiSoftbank{$hex};
        $Encode::JP::Emoji::Mapping::CharnamesEmojiSoftbank{$hex};
    };
}

sub FB_GOOGLE_TEXT {
    sub {
        my $code = shift;
        my $hex  = sprintf $HEX_FORMAT => $code;
        return sprintf $XMLCREF_FORMAT => $code unless exists $Encode::JP::Emoji::Mapping::CharnamesEmojiGoogle{$hex};
        $Encode::JP::Emoji::Mapping::CharnamesEmojiGoogle{$hex};
    };
}

sub FB_UNICODE_TEXT {
    sub {
        my $code = shift;
        my $hex  = sprintf $HEX_FORMAT => $code;
        return sprintf $XMLCREF_FORMAT => $code unless exists $Encode::JP::Emoji::Mapping::CharnamesEmojiUnicode{$hex};
        $Encode::JP::Emoji::Mapping::CharnamesEmojiUnicode{$hex};
    };
}

my $utf8     = Encode::find_encoding('utf8');
my $docomo   = Encode::find_encoding('x-utf8-e4u-docomo-pp');
my $kddi     = Encode::find_encoding('x-utf8-e4u-kddi-pp');
my $softbank = Encode::find_encoding('x-utf8-e4u-softbank-pp');
my $unicode  = Encode::find_encoding('x-utf8-e4u-unicode-pp');

sub FB_DOCOMO_HTML {
    my $format = shift || $DOCOMO_FORMAT;
    sub {
        my $code = shift;
        my $google = ord $docomo->decode($utf8->encode(chr $code));
        return sprintf $XMLCREF_FORMAT => $code if ($google < 0xFE000);
        sprintf $format => ($google & 0x07FF);
    }
}

sub FB_KDDI_HTML {
    my $format = shift || $KDDI_FORMAT;
    sub {
        my $code = shift;
        my $google = ord $kddi->decode($utf8->encode(chr $code));
        return sprintf $XMLCREF_FORMAT => $code if ($google < 0xFE000);
        sprintf $format => ($google & 0x07FF);
    }
}

sub FB_SOFTBANK_HTML {
    my $format = shift || $SOFTBANK_FORMAT;
    sub {
        my $code = shift;
        my $google = ord $softbank->decode($utf8->encode(chr $code));
        return sprintf $XMLCREF_FORMAT => $code if ($google < 0xFE000);
        sprintf $format => ($google & 0x07FF);
    }
}

sub FB_GOOGLE_HTML {
    my $format = shift || $GOOGLE_FORMAT;
    sub {
        my $code = shift;
        return sprintf $XMLCREF_FORMAT => $code if ($code < 0xFE000);
        sprintf $format => ($code & 0x07FF);
    };
}

sub FB_UNICODE_HTML {
    my $format = shift || $UNICODE_FORMAT;
    sub {
        my $code = shift;
        my $google = ord $unicode->decode($utf8->encode(chr $code));
        return sprintf $XMLCREF_FORMAT => $code if ($google < 0xFE000);
        sprintf $format => ($google & 0x07FF);
    };
}

1;
