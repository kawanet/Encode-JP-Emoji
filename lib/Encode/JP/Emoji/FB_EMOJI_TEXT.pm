=encoding utf-8

=head1 NAME

Encode::JP::Emoji::FB_EMOJI_TEXT - Emoji fallback functions

=head1 SYNOPSIS

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

=head1 DESCRIPTION

This module exports the following fallback functions which would be used with
C<x-sjis-e4u-none> and C<x-utf8-e4u-none> encodings which rejects any emojis.

=head2 FB_DOCOMO_TEXT()

This returns emoji name defined by DoCoMo.
Note that this accepts only DoCoMo's private emoji code points.

    Encode::from_to($html, 'x-utf8-emoji-docomo', 'x-utf8-emoji-none', FB_DOCOMO_TEXT());

=head2 FB_KDDIAPP_TEXT()

This returns emoji name defined by KDDI.
Note that this accepts only KDDI's private emoji code points.

    Encode::from_to($html, 'x-sjis-emoji-kddiapp', 'x-sjis-emoji-none', FB_KDDIAPP_TEXT());

=head2 FB_KDDIWEB_TEXT()

This returns emoji name defined by KDDI.
Note that this accepts only B<undocumented version> of KDDI's private emoji code points.

    Encode::from_to($html, 'x-utf8-emoji-kddiweb', 'x-utf8-emoji-none', FB_KDDIWEB_TEXT());

See L<http://subtech.g.hatena.ne.jp/miyagawa/20071112/1194865208> for more detail.

=head2 FB_SOFTBANK_TEXT()

This returns emoji name defined by SoftBank.
Note that this accepts only SoftBank's private emoji code points.

    Encode::from_to($html, 'x-sjis-emoji-softbank', 'x-sjis-emoji-none', FB_SOFTBANK_TEXT());

=head2 FB_GOOGLE_TEXT()

This returns emoji name defined by emoji4unicode project on Google Code.
Note that this accepts only Google's private emoji code points.

    Encode::from_to($html, 'x-utf8-e4u-google', 'x-utf8-e4u-none', FB_GOOGLE_TEXT());

=head2 FB_UNICODE_TEXT()

This will return character name defined on the Unicode Standard.
Note that this accepts only emojis of standard code points.

    Encode::from_to($html, 'x-utf8-e4u-unicode', 'x-utf8-e4u-none', FB_UNICODE_TEXT());

=head2 FB_EMOJI_TEXT()

This accepts all emoji code points above for ease of use.

=head1 AUTHOR

Yusuke Kawasaki, L<http://www.kawa.net/>

=head1 SEE ALSO

L<Encode::JP::Emoji>

=head1 COPYRIGHT

Copyright 2009 Yusuke Kawasaki, all rights reserved.

=cut

package Encode::JP::Emoji::FB_EMOJI_TEXT;
use strict;
use warnings;
use base 'Exporter';
use Encode ();
use Encode::JP::Emoji::Mapping;

our $VERSION = '0.03';

our @EXPORT = qw(
    FB_EMOJI_TEXT FB_DOCOMO_TEXT FB_KDDIAPP_TEXT FB_KDDIWEB_TEXT FB_SOFTBANK_TEXT FB_GOOGLE_TEXT FB_UNICODE_TEXT
);

our $FB_TEXT = '[%s]';

my $hex4   = '%04X';
my $latin1 = Encode::find_encoding('latin1');

sub FB_DOCOMO_TEXT {
    my $fb = shift || Encode::FB_XMLCREF();
    sub {
        my $code = shift;
        my $hex  = sprintf $hex4 => $code;
        my $text;
        if (exists $Encode::JP::Emoji::Mapping::CharnamesEmojiDocomo{$hex}) {
            $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiDocomo{$hex};
        } else {
            return $latin1->encode(chr $code, $fb);
        }
        sprintf $FB_TEXT => $text;
    }
}

sub FB_KDDIAPP_TEXT {
    my $fb = shift || Encode::FB_XMLCREF();
    sub {
        my $code = shift;
        my $hex  = sprintf $hex4 => $code;
        my $text;
        if (exists $Encode::JP::Emoji::Mapping::CharnamesEmojiKddi{$hex}) {
            $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiKddi{$hex};
        } else {
            return $latin1->encode(chr $code, $fb);
        }
        sprintf $FB_TEXT => $text;
    };
}

sub FB_KDDIWEB_TEXT {
    my $fb = shift || Encode::FB_XMLCREF();
    sub {
        my $code = shift;
        my $hex  = sprintf $hex4 => $code;
        my $text;
        if (exists $Encode::JP::Emoji::Mapping::CharnamesEmojiKddiweb{$hex}) {
            $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiKddiweb{$hex};
        } else {
            return $latin1->encode(chr $code, $fb);
        }
        sprintf $FB_TEXT => $text;
    };
}

sub FB_SOFTBANK_TEXT {
    my $fb = shift || Encode::FB_XMLCREF();
    sub {
        my $code = shift;
        my $hex  = sprintf $hex4 => $code;
        my $text;
        if (exists $Encode::JP::Emoji::Mapping::CharnamesEmojiSoftbank{$hex}) {
            $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiSoftbank{$hex};
        } else {
            return $latin1->encode(chr $code, $fb);
        }
        sprintf $FB_TEXT => $text;
    };
}

sub FB_GOOGLE_TEXT {
    my $fb = shift || Encode::FB_XMLCREF();
    sub {
        my $code = shift;
        my $hex  = sprintf $hex4 => $code;
        my $text;
        if (exists $Encode::JP::Emoji::Mapping::CharnamesEmojiGoogle{$hex}) {
            $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiGoogle{$hex};
        } else {
            return $latin1->encode(chr $code, $fb);
        }
        sprintf $FB_TEXT => $text;
    };
}

sub FB_UNICODE_TEXT {
    my $fb = shift || Encode::FB_XMLCREF();
    sub {
        my $code = shift;
        my $hex  = sprintf $hex4 => $code;
        my $text;
        if (exists $Encode::JP::Emoji::Mapping::CharnamesEmojiUnicode{$hex}) {
            $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiUnicode{$hex};
        } else {
            return $latin1->encode(chr $code, $fb);
        }
        sprintf $FB_TEXT => $text;
    };
}

sub FB_EMOJI_TEXT {
    my $fb = shift || Encode::FB_XMLCREF();
    sub {
        my $code = shift;
        my $hex  = sprintf $hex4 => $code;
        my $text;
        if (exists $Encode::JP::Emoji::Mapping::CharnamesEmojiGoogle{$hex}) {
            $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiGoogle{$hex};
        } elsif (exists $Encode::JP::Emoji::Mapping::CharnamesEmojiDocomo{$hex}) {
            $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiDocomo{$hex};
        } elsif (exists $Encode::JP::Emoji::Mapping::CharnamesEmojiKddiweb{$hex}) {
            $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiKddiweb{$hex};
        } elsif (exists $Encode::JP::Emoji::Mapping::CharnamesEmojiSoftbank{$hex}) {
            $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiSoftbank{$hex};
        } elsif (exists $Encode::JP::Emoji::Mapping::CharnamesEmojiKddi{$hex}) {
            $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiKddi{$hex};
        } elsif (exists $Encode::JP::Emoji::Mapping::CharnamesEmojiUnicode{$hex}) {
            $text = $Encode::JP::Emoji::Mapping::CharnamesEmojiUnicode{$hex};
        } else {
            return $latin1->encode(chr $code, $fb);
        }
        sprintf $FB_TEXT => $text;
    };
}

1;
