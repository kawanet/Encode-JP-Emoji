=head1 NAME

Encode::JP::Emoji::Property - Emoji named unicode character properties

=head1 SYNOPSIS

    use utf8;
    use Encode::JP::Emoji::Property;

    /\p{InEmojiDocomoUnicode}/;
    /\p{InEmojiKddiUnicode}/;
    /\p{InEmojiSoftbankUnicode}/;
    /\p{InEmojiUnicodeUnicode}/;
    /\p{InEmojiGoogleUnicode}/;

=head1 DESCRIPTION

This exports the following named unicode character properties:

=head2 \p{InEmojiDocomoUnicode}

This matches emoji codepoints in Unicode PUA defined by NTT DoCoMo: U+E63E ... U+E757.

=head2 \p{InEmojiKddiUnicode}

This matches emoji codepoints in Unicode PUA defined by KDDI: U+E468 ... U+EB8E.

=head2 \p{InEmojiSoftbankUnicode}

This matches emoji codepoints in Unicode PUA defined by SoftBank Mobile: U+E001 ... U+E53E.

=head2 \p{InEmojiGoogleUnicode}

This matches emoji codepoints in Unicode PUA defined by Google: U+FE000 ... U+FEEA0.

=head2 \p{InEmojiUnicodeUnicode}

This matches emoji codepoints which will be defined in Unicode standard.

=head1 AUTHOR

Yusuke Kawasaki, L<http://www.kawa.net/>

=head1 SEE ALSO

L<Encode::JP::Emoji> and L<perlunicode>

=head1 COPYRIGHT

Copyright 2009 Yusuke Kawasaki, all rights reserved.

=cut

package Encode::JP::Emoji::Property;
use strict;
use warnings;
use Encode::JP::Emoji::Mapping;
use base 'Exporter';

our @EXPORT = qw(
    InEmojiDocomoUnicode
    InEmojiKddiUnicode
    InEmojiSoftbankUnicode
    InEmojiUnicodeUnicode
    InEmojiGoogleUnicode
);

*InEmojiDocomoUnicode   = \&Encode::JP::Emoji::Mapping::InEmojiDocomoUnicode;
*InEmojiKddiUnicode     = \&Encode::JP::Emoji::Mapping::InEmojiKddiUnicode;
*InEmojiSoftbankUnicode = \&Encode::JP::Emoji::Mapping::InEmojiSoftbankUnicode;
*InEmojiUnicodeUnicode  = \&Encode::JP::Emoji::Mapping::InEmojiUnicodeUnicode;
*InEmojiGoogleUnicode   = \&Encode::JP::Emoji::Mapping::InEmojiGoogleUnicode;

1;
