=encoding utf-8

=head1 NAME

Encode::JP::Emoji::Fallback - Emoji fallback functions

=head1 SYNOPSIS

    use Encode;
    use Encode::JP::Emoji;
    use Encode::JP::Emoji::Fallback;

    # DoCoMo Shift_JIS <SJIS+F89F> octets to fallback to DoCoMo name "[晴れ]"
    my $sun = "\xF8\x9F";
    Encode::from_to($sun, 'x-sjis-emoji-docomo', 'x-sjis-e4u-none', FB_DOCOMO_TEXT());

    # KDDI UTF-8 <U+E598> octets to fallback to Google name "[霧]"
    my $fog = "\xEE\x96\x98";
    Encode::from_to($fog, 'x-utf8-e4u-kddi', 'x-utf8-e4u-none', FB_GOOGLE_TEXT());

    # SoftBank UTF-8 <U+E524> string to fallback to SoftBank name "[ハムスター]"
    my $hamster = "\x{E524}";
    my $softbank = Encode::encode('x-sjis-e4u-none', $hamster, FB_SOFTBANK_TEXT());

    # Google UTF-8 <U+FE1C1> octets to fallback to Google name "[クマ]"
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
Note that this works only for emojis of standard code points.

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
use Encode ();

our $VERSION = '0.03';

our @EXPORT = qw(
    FB_DOCOMO_TEXT FB_KDDI_TEXT FB_SOFTBANK_TEXT FB_GOOGLE_TEXT FB_UNICODE_TEXT
);

our $FB_TEXT = '[%s]';

my $hex4   = '%04X';
my $latin1 = Encode::find_encoding('latin1');

sub FB_DOCOMO_TEXT {
    my $fb = shift || Encode::FB_XMLCREF();
    sub {
        my $code = shift;
        my $hex  = sprintf $hex4 => $code;
        return $latin1->encode(chr $code, $fb) unless exists $Encode::JP::Emoji::Mapping::CharnamesEmojiDocomo{$hex};
        my $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiDocomo{$hex};
        sprintf $FB_TEXT => $text;
    }
}

sub FB_KDDI_TEXT {
    my $fb = shift || Encode::FB_XMLCREF();
    sub {
        my $code = shift;
        my $hex  = sprintf $hex4 => $code;
        return $latin1->encode(chr $code, $fb) unless exists $Encode::JP::Emoji::Mapping::CharnamesEmojiKddi{$hex};
        my $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiKddi{$hex};
        sprintf $FB_TEXT => $text;
    };
}

sub FB_SOFTBANK_TEXT {
    my $fb = shift || Encode::FB_XMLCREF();
    sub {
        my $code = shift;
        my $hex  = sprintf $hex4 => $code;
        return $latin1->encode(chr $code, $fb) unless exists $Encode::JP::Emoji::Mapping::CharnamesEmojiSoftbank{$hex};
        my $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiSoftbank{$hex};
        sprintf $FB_TEXT => $text;
    };
}

sub FB_GOOGLE_TEXT {
    my $fb = shift || Encode::FB_XMLCREF();
    sub {
        my $code = shift;
        my $hex  = sprintf $hex4 => $code;
        return $latin1->encode(chr $code, $fb) unless exists $Encode::JP::Emoji::Mapping::CharnamesEmojiGoogle{$hex};
        my $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiGoogle{$hex};
        sprintf $FB_TEXT => $text;
    };
}

sub FB_UNICODE_TEXT {
    my $fb = shift || Encode::FB_XMLCREF();
    sub {
        my $code = shift;
        my $hex  = sprintf $hex4 => $code;
        return $latin1->encode(chr $code, $fb) unless exists $Encode::JP::Emoji::Mapping::CharnamesEmojiUnicode{$hex};
        my $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiUnicode{$hex};
        sprintf $FB_TEXT => $text;
    };
}

1;
