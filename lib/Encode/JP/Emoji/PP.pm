=head1 NAME

Encode::JP::Emoji::PP - Emoji encoding aliases

=head1 DESCRIPTION

This module provides encoding aliases without C<-pp> suffix.

    Canonical                       Alias
    --------------------------------------------------------------------
    x-sjis-emoji-docomo-pp          x-sjis-emoji-docomo
    x-sjis-emoji-kddi-pp            x-sjis-emoji-kddi
    x-sjis-emoji-softbank-pp        x-sjis-emoji-softbank
    x-sjis-emoji-softbank2g-pp      x-sjis-emoji-softbank2g
    x-sjis-emoji-softbank3g-pp      x-sjis-emoji-softbank3g
    x-sjis-e4u-docomo-pp            x-sjis-e4u-docomo
    x-sjis-e4u-kddi-pp              x-sjis-e4u-kddi
    x-sjis-e4u-softbank-pp          x-sjis-e4u-softbank
    x-sjis-e4u-softbank2g-pp        x-sjis-e4u-softbank2g
    x-sjis-e4u-softbank3g-pp        x-sjis-e4u-softbank3g
    x-sjis-e4u-none-pp              x-sjis-e4u-none
    x-utf8-e4u-docomo-pp            x-utf8-e4u-docomo
    x-utf8-e4u-kddi-pp              x-utf8-e4u-kddi
    x-utf8-e4u-softbank-pp          x-utf8-e4u-softbank
    x-utf8-e4u-softbank2g-pp        x-utf8-e4u-softbank2g
    x-utf8-e4u-softbank3g-pp        x-utf8-e4u-softbank3g
    x-utf8-e4u-unicode-pp           x-utf8-e4u-unicode
    x-utf8-e4u-none-pp              x-utf8-e4u-none
    --------------------------------------------------------------------

All encodings are implemented in L<Encode::JP::Emoji::Encodings> module.
Use L<Encode::JP::Emoji> instead of loading this module directly.

=head1 AUTHOR

Yusuke Kawasaki, L<http://www.kawa.net/>

=head1 SEE ALSO

L<Encode::JP::Emoji> and L<Encode::JP::Emoji::Encodings>.

=head1 COPYRIGHT

Copyright 2009 Yusuke Kawasaki, all rights reserved.

=cut

package Encode::JP::Emoji::PP;
use strict;
use warnings;
use Encode::JP::Emoji::Encoding;
use Encode::JP::Emoji::Fallback ();
use Encode::Alias;

our $VERSION = '0.02';

define_alias('x-sjis-emoji-docomo'   => 'x-sjis-emoji-docomo-pp');
define_alias('x-sjis-emoji-kddi'     => 'x-sjis-emoji-kddi-pp');
define_alias('x-sjis-emoji-softbank' => 'x-sjis-emoji-softbank-pp');

define_alias('x-sjis-e4u-docomo'     => 'x-sjis-e4u-docomo-pp');
define_alias('x-sjis-e4u-kddi'       => 'x-sjis-e4u-kddi-pp');
define_alias('x-sjis-e4u-softbank'   => 'x-sjis-e4u-softbank-pp');

define_alias('x-utf8-e4u-docomo'     => 'x-utf8-e4u-docomo-pp');
define_alias('x-utf8-e4u-kddi'       => 'x-utf8-e4u-kddi-pp');
define_alias('x-utf8-e4u-softbank'   => 'x-utf8-e4u-softbank-pp');
# define_alias('x-utf8-e4u-google'     => 'x-utf8-e4u-google-pp');
define_alias('x-utf8-e4u-unicode'    => 'x-utf8-e4u-unicode-pp');

define_alias('x-sjis-emoji-softbank2g' => 'x-sjis-emoji-softbank2g-pp');
define_alias('x-sjis-e4u-softbank2g'   => 'x-sjis-e4u-softbank2g-pp');
define_alias('x-utf8-e4u-softbank2g'   => 'x-utf8-e4u-softbank2g-pp');

define_alias('x-sjis-emoji-softbank3g' => 'x-sjis-emoji-softbank3g-pp');
define_alias('x-sjis-e4u-softbank3g'   => 'x-sjis-e4u-softbank3g-pp');
define_alias('x-utf8-e4u-softbank3g'   => 'x-utf8-e4u-softbank3g-pp');

define_alias('x-utf8-e4u-none'       => 'x-utf8-e4u-none-pp');
define_alias('x-sjis-e4u-none'       => 'x-sjis-e4u-none-pp');

1;
