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
    /\p{InEmojiAnyUnicode}/;

=head1 DESCRIPTION

This exports the following named unicode character properties:

=head2 \p{InEmojiDocomoUnicode}

This matches DoCoMo's private emoji code points: C<U+E63E> ... C<U+E757>.

=head2 \p{InEmojiKddiUnicode}

This matches KDDI's private emoji code points: C<U+E468> ... C<U+EB8E>.

=head2 \p{InEmojiSoftbankUnicode}

This matches SoftBank's private emoji code points: C<U+E001> ... C<U+E53E>.

=head2 \p{InEmojiGoogleUnicode}

This matches Google's private emoji code points: C<U+FE000> ... C<U+FEEA0>.

=head2 \p{InEmojiUnicodeUnicode}

This matches emoji code points which will be defined in the Unicode Standard.

=head2 \p{InEmojiAnyUnicode}

This matches any emoji code points above.

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

our $VERSION = '0.02';

our @EXPORT = qw(
    InEmojiDocomoUnicode
    InEmojiKddiUnicode
    InEmojiSoftbankUnicode
    InEmojiUnicodeUnicode
    InEmojiGoogleUnicode
    InEmojiAnyUnicode
);

*InEmojiDocomoUnicode   = \&Encode::JP::Emoji::Mapping::InEmojiDocomoUnicode;
*InEmojiKddiUnicode     = \&Encode::JP::Emoji::Mapping::InEmojiKddiUnicode;
*InEmojiSoftbankUnicode = \&Encode::JP::Emoji::Mapping::InEmojiSoftbankUnicode;
*InEmojiUnicodeUnicode  = \&Encode::JP::Emoji::Mapping::InEmojiUnicodeUnicode;
*InEmojiGoogleUnicode   = \&Encode::JP::Emoji::Mapping::InEmojiGoogleUnicode;

sub InEmojiAnyUnicode { return <<"EOT"; }
+Encode::JP::Emoji::Property::InEmojiDocomoUnicode
+Encode::JP::Emoji::Property::InEmojiKddiUnicode
+Encode::JP::Emoji::Property::InEmojiSoftbankUnicode
+Encode::JP::Emoji::Property::InEmojiUnicodeUnicode
+Encode::JP::Emoji::Property::InEmojiGoogleUnicode
EOT

1;
