=encoding utf-8

=head1 NAME

Encode::JP::Emoji::FB_EMOJI_TEXT - Emoji fallback functions

=head1 SYNOPSIS

    use Encode;
    use Encode::JP::Emoji;
    use Encode::JP::Emoji::FB_EMOJI_TEXT;

    # DoCoMo Shift_JIS <SJIS+F95B> octets fallback to "[SOON]"
    my $soon = "\xF9\x5B";
    Encode::from_to($soon, 'x-sjis-e4u-docomo', 'x-sjis-e4u-kddiweb', FB_EMOJI_TEXT());

    # KDDI Shift_JIS <SJIS+F7B5> octets fallback to "[霧]"
    my $fog = "\xF7\xB5";
    Encode::from_to($fog, 'x-sjis-e4u-kddiweb', 'x-sjis-e4u-softbank3g', FB_EMOJI_TEXT());

    # SoftBank UTF-8 <U+E524> string fallback to "[ハムスター]"
    my $hamster = "\x{E524}";
    my $softbank = Encode::encode('x-sjis-e4u-none', $hamster, FB_EMOJI_TEXT());

    # Google UTF-8 <U+FE1C1> octets fallback to "[クマ]"
    my $bear = "\xF3\xBE\x87\x81";
    my $google = Encode::decode('x-utf8-e4u-none', $bear, FB_EMOJI_TEXT());

=head1 DESCRIPTION

This module exports the following fallback function.

=head2 FB_EMOJI_TEXT()

This returns emoji character name.
Having conflicts with SoftBank encoding, KDDI(app) encoding is B<NOT> recommended.

=head1 BUGS

C<Encode.pm> 2.22 or less would face a problem with fallback function.
Use latest version of C<Encode.pm>, or use with C<EncodeUpdate.pm>
in C<t> test directory of the package.

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
use Encode::JP::Emoji::Property;

our $VERSION = '0.04';

our @EXPORT = qw(
    FB_EMOJI_TEXT
);

our $TEXT_FORMAT = '[%s]';

my $latin1 = Encode::find_encoding('latin1');
my $utf8   = Encode::find_encoding('utf8');
my $mixed  = Encode::find_encoding('x-utf8-e4u-mixed');

sub FB_EMOJI_TEXT {
    my $fb = shift || Encode::FB_XMLCREF();
    sub {
        my $code = shift;
        my $chr  = chr $code;
        if ($chr =~ /\p{InEmojiGoogle}/) {
            # google emoji
        } elsif ($chr =~ /\p{InEmojiAny}/) {
            # others emoji
            my $str = $mixed->decode($utf8->encode($chr));
            $code = ord $str if (1 == length $str);
        }
        my $hex = sprintf '%04X' => $code;
        unless (exists $Encode::JP::Emoji::Mapping::CharnamesEmojiGoogle{$hex}) {
            return $latin1->encode($chr, $fb);
        }
        my $name = $Encode::JP::Emoji::Mapping::CharnamesEmojiGoogle{$hex};
        sprintf $TEXT_FORMAT => $name;
    };
}

1;
