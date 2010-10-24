#!/usr/bin/perl

use strict;
use warnings;
use Carp ();
use Encode;
use lib qw(../../Unicode-Emoji-E4U/trunk/lib);
use Unicode::Emoji::E4U;

my $INDENT = '    ';
my $CP932_SRC = [qw(docomo kddi kddiweb softbank)];
my $UTF8_SRC  = [qw(docomo kddi kddiweb softbank google unicode)];
my $RE_TESTS  = qr/[\x{FE000}\x{FE4E5}\x{FE4E6}\x{FE82E}\x{FE82F}\x{FEB44}\x{FEB63}]/;

if (scalar @ARGV == 1 && $ARGV[0] eq '-h') {
    print STDERR "Usage:\n";
    print STDERR "*** to load local data files:\n";
    print STDERR "$0 datadir ../Unicode-Emoji-E4U/trunk/data > lib/Encode/JP/Emoji/Mapping.pm\n";
    print STDERR "*** to fetch data files from google code (default):\n";
    print STDERR "$0 datadir http://emoji4unicode.googlecode.com/svn/trunk/data > lib/Encode/JP/Emoji/Mapping.pm\n";
    exit;
}

my %opt = @ARGV;
# verbose output
$opt{verbose} = 1 unless exists $opt{verbose};
# digest output for testing
$opt{digests} = 0 unless exists $opt{digests};
# more Unicode Stdard mappings
$opt{morestd} = 0 unless exists $opt{morestd};
my $e4u = Unicode::Emoji::E4U->new(%opt);

sub main {
    print encode utf8 => &make_mapping_pm;
}

sub make_mapping_pm {
    my $out  = [];
    
    my($day, $mon, $year) = (localtime)[3..5];
    my $date = sprintf('%04d%02d%02d', $year+1900, $mon+1, $day);

    push @$out, <DATA>;
    push @$out, "\n";
    push @$out, "our \$VERSION = '$Unicode::Emoji::E4U::VERSION.$date';\n";
    push @$out, "\n";
    push @$out, &make_property;
    push @$out, &make_converter_carrier_cp932;
    push @$out, &make_converter_carrier_unicode;
    push @$out, &make_converter_unicode_unicode if $opt{morestd};
    push @$out, &make_converter_google_unicode;
    push @$out, &make_mixed_encoding;
    push @$out, &make_charnames_var('google', 'google');
    push @$out, "1;\n";

    join '' => @$out;
}

# InEmojiDocomoUnicode
# InEmojiKddiUnicode
# InEmojiKddiwebUnicode
# InEmojiSoftbankUnicode
# InEmojiGoogleUnicode
# InEmojiUnicodeUnicode

sub make_property {
    my $out  = [];
    foreach my $carrier (@$UTF8_SRC) {
        my $basemap = ($carrier eq 'unicode') ? 'google' : $carrier;
        push @$out, &make_property_sub($basemap, $carrier, 'Unicode');
    }
    print STDERR (scalar @$out), " properties\n";
    @$out;
}

# docomo_cp932_to_docomo_unicode
# docomo_unicode_to_docomo_cp932
# kddi_cp932_to_kddi_unicode
# kddi_unicode_to_kddi_cp932
# kddiweb_cp932_to_kddiweb_unicode
# kddiweb_unicode_to_kddiweb_cp932
# softbank_cp932_to_softbank_unicode
# softbank_unicode_to_softbank_cp932

sub make_converter_carrier_cp932 {
    my $out  = [];
    foreach my $carrier (@$CP932_SRC) {
        push @$out, &make_converter_sub($carrier, $carrier, 'cp932',   $carrier, 'unicode');
        push @$out, &make_converter_sub($carrier, $carrier, 'unicode', $carrier, 'cp932');
    }
    print STDERR (scalar @$out), " converters\n";
    @$out;
}

# docomo_cp932_to_google_unicode
# google_unicode_to_docomo_cp932
# kddi_cp932_to_google_unicode
# google_unicode_to_kddi_cp932
# kddiweb_cp932_to_google_unicode
# google_unicode_to_kddiweb_cp932
# softbank_cp932_to_google_unicode
# google_unicode_to_softbank_cp932
    
sub make_converter_carrier_unicode {
    my $out  = [];
    foreach my $carrier (@$CP932_SRC) {
        push @$out, &make_converter_sub('google', $carrier, 'cp932',   'google', 'unicode');
        push @$out, &make_converter_sub('google', 'google', 'unicode', $carrier, 'cp932');
    }
    print STDERR (scalar @$out), " converters\n";
    @$out;
}

# docomo_unicode_to_unicode_unicode
# unicode_unicode_to_docomo_unicode
# kddi_unicode_to_unicode_unicode
# unicode_unicode_to_kddi_unicode
# kddiweb_unicode_to_unicode_unicode
# unicode_unicode_to_kddiweb_unicode
# softbank_unicode_to_unicode_unicode
# unicode_unicode_to_softbank_unicode

sub make_converter_unicode_unicode {
    my $out  = [];
    foreach my $carrier (@$UTF8_SRC) {
        next if ($carrier eq 'google');     # skip google to unicode converter
        next if ($carrier eq 'unicode');    # skip unicode to unicode converter
        push @$out, &make_converter_sub('google', $carrier, 'unicode', 'unicode', 'unicode');
        push @$out, &make_converter_sub('google', 'unicode', 'unicode', $carrier, 'unicode');
    }
    print STDERR (scalar @$out), " converters\n";
    @$out;
}

# docomo_unicode_to_google_unicode
# google_unicode_to_docomo_unicode
# kddi_unicode_to_google_unicode
# google_unicode_to_kddi_unicode
# kddiweb_unicode_to_google_unicode
# google_unicode_to_kddiweb_unicode
# softbank_unicode_to_google_unicode
# google_unicode_to_softbank_unicode
# unicode_unicode_to_google_unicode
# google_unicode_to_unicode_unicode

sub make_converter_google_unicode {
    my $out  = [];
    foreach my $carrier (@$UTF8_SRC) {
        next if ($carrier eq 'google');     # skip google to google converter
        push @$out, &make_converter_sub('google', $carrier, 'unicode', 'google', 'unicode');
        push @$out, &make_converter_sub('google', 'google', 'unicode', $carrier, 'unicode');
    }    
    print STDERR (scalar @$out), " converters\n";
    @$out;
}

sub make_property_sub {
    my $basemap = shift;
    my $srccarr = shift;
    my $suffix  = shift;

    my $srcx = $srccarr.'_emoji';
    my $srcs = (lc $suffix).'_string';
    my $list = $e4u->$basemap->list;

    # source exists
    $list = [grep {defined $_->$srcx} @$list];
    $list = [grep {defined $_->$srcx->$srcs} @$list];
    $list = [grep {! $_->$srcx->is_alt} @$list];

    # only sun (for test use)
    if ($opt{digests} && $basemap eq 'google') {
        $list = [grep {$_->google_emoji && $_->google_emoji->unicode_string =~ $RE_TESTS} @$list];
    }
    
    # U+1F1E6 REGIONAL INDICATOR SYMBOL LETTER A etc.
    if ($basemap eq 'google') {
        $list = [grep {$_->google_emoji} @$list];
    }
    
    my $srclist = [map {$_->$srcx->$srcs} @$list];
    my $out     = [];
    push @$out, get_regexp_sub($srccarr, $suffix, $srclist);
    join_escape_nonascii(@$out);
}

sub get_regexp_sub {
    my $srccarr = shift;
    my $suffix  = shift;
    my $srclist = shift;
    
    # sort by source
    $srclist = [sort {$a cmp $b} @$srclist];
    # 1 character
    my $shortlist = [grep {1 == length} @$srclist];
    # 2 or more characters
    my $longlist  = [grep {1 <  length} @$srclist];

    my $out = [];
    my $invar = sprintf 'InEmoji%s%s' => ucfirst $srccarr, $suffix;
    my $insub = sprintf 'InEmoji%s%s' => ucfirst $srccarr, $suffix;
    my $revar = sprintf 'ReEmoji%s%s' => ucfirst $srccarr, $suffix;

    # in
    {
        my @insrc = map {ord $_} @$shortlist;
        my $first = $insrc[0];
        my $prev = $first - 1;
        my $inlist = [];
        foreach my $c (@insrc,0) {
            if ($prev + 1 != $c) {
                my $fmt = ($first == $prev) ? "%04X" : "%04X\\t%04X";
                push @$inlist, sprintf($fmt, $first, $prev);
                $first = $c;
            }
            $prev = $c;
        }
        my $injoin = join '\n' => @$inlist;
        push @$out, 'our $', $invar, ' = "', $injoin, '";';
        push @$out, "\n";
    }

    # sub
    print STDERR $insub, "\n";
    push @$out, "sub ", $insub, ' { $', $invar, "; }\n";

    # re
    {
        my $relist = [];
        push @$relist, '\p{'.$insub.'}';
        my $hash2nd = {map {(/^.(.*)$/)[0] => 1} @$longlist};
        my $list2nd = [sort keys %$hash2nd];
        foreach my $chr2nd (@$list2nd) {
            my $listmat = [grep {/\Q$chr2nd\E$/} @$longlist];
            $chr2nd =~ s/([\x00-\x7F])/sprintf('\x%02X' => ord $1)/e;
            if (scalar @$listmat < 3) {
                push @$relist, @$listmat;
            } else {
                my $list1st = [map {(/^(.)/)[0]} @$listmat];
                s/([\x00-\x7F])/sprintf('\x%02X' => ord $1)/e foreach @$list1st;
                my $join1st = join '' => @$list1st;
                push @$relist, '['.$join1st.']'.$chr2nd;
            }
        }
        my $rejoin = join '|' => @$relist;
        push @$out, 'our $', $revar, ' = qr/(?:', $rejoin, ')/mo;';
        push @$out, "\n";
    }

    push @$out, "\n";
    @$out;
}

# google_unicode_to_mixed_unicode
# mixed_unicode_to_google_unicode

sub make_mixed_encoding {
    my $basemap = shift;

    my $docomo2google   = {};
    my $kddi2google     = {};
    my $kddiweb2google  = {};
    my $softbank2google = {};
    my $unicode2google  = {};

    my $google2docomo   = {};
    my $google2kddi     = {};
    my $google2kddiweb  = {};
    my $google2softbank = {};
    my $google2unicode  = {};

    my $list = $e4u->google->list;
    foreach my $e (@$list) {
        next unless $e->google_emoji;
        my $google = $e->google_emoji->unicode_string;
        # only sun (for test use)
        if ($opt{digests}) {
            next unless ($google =~ $RE_TESTS);
        }
        my $g_alt = $e->google_emoji->is_alt;
        if ($e->unicode_emoji && ! $e->unicode_emoji->is_alt) {
            my $unicode = $e->unicode_emoji->unicode_string;
            if (defined $unicode) {
                $unicode2google->{$unicode} = $google;
                $google2unicode->{$google}  = $unicode unless $g_alt;
            }
        }
        if ($e->kddi_emoji && ! $e->kddi_emoji->is_alt) {
            my $kddi = $e->kddi_emoji->unicode_string;
            if (defined $kddi) {
                $kddi2google->{$kddi}   = $google;
                $google2kddi->{$google} = $kddi unless $g_alt;
            }
        }
        if ($e->kddiweb_emoji && ! $e->kddiweb_emoji->is_alt) {
            my $kddiweb = $e->kddiweb_emoji->unicode_string;
            if (defined $kddiweb) {
                $kddiweb2google->{$kddiweb} = $google;
                $google2kddiweb->{$google}  = $kddiweb unless $g_alt;
            }
        }
        if ($e->softbank_emoji && ! $e->softbank_emoji->is_alt) {
            my $softbank = $e->softbank_emoji->unicode_string;
            if (defined $softbank) {
                $softbank2google->{$softbank} = $google;
                $google2softbank->{$google}   = $softbank unless $g_alt;
            }
        }
        if ($e->docomo_emoji && ! $e->docomo_emoji->is_alt) {
            my $docomo = $e->docomo_emoji->unicode_string;
            if (defined $docomo) {
                $docomo2google->{$docomo} = $google;
                $google2docomo->{$google} = $docomo unless $g_alt;
            }
        }
    }

    my $out = [];

    my $mixed2google  = {%$kddi2google, %$softbank2google, %$kddiweb2google, %$docomo2google};
    my $google2mixed  = {%$google2kddi, %$google2softbank, %$google2kddiweb, %$google2docomo};

    my $mixedlist = [keys %$mixed2google];
    push @$out, get_regexp_sub('mixed', 'Unicode', $mixedlist);

    push @$out, get_mapping_sub('google',  'google_unicode_to_mixed_unicode',  $google2mixed);
    push @$out, get_mapping_sub('mixed',   'mixed_unicode_to_google_unicode',  $mixed2google);
    
    if ($opt{morestd}) {
        # EMOJI COMPATIBILITY SYMBOLs are missing unfortunately
        my $mixed2unilist = [grep {$google2unicode->{$mixed2google->{$_}}} keys %$mixed2google];
        my $mixed2unicode = {map {$_ => $google2unicode->{$mixed2google->{$_}}} @$mixed2unilist};
        my $uni2mixedlist = [grep {$google2unicode->{$_}} keys %$google2mixed];
        my $unicode2mixed = {map {$google2unicode->{$_} => $google2mixed->{$_}} @$uni2mixedlist};
        
        push @$out, get_mapping_sub('unicode', 'unicode_unicode_to_mixed_unicode', $unicode2mixed);
        push @$out, get_mapping_sub('mixed',   'mixed_unicode_to_unicode_unicode', $mixed2unicode);
    }

    join_escape_nonascii(@$out);
}

sub get_tr_list {
    my $list = shift;
    my $work = [map {+[$_, ord $_]} @$list];
    foreach my $i (1 .. $#$work-1) {
        my $prev = $work->[$i-1];
        my $this = $work->[$i];
        my $next = $work->[$i+1];
        if ($prev->[1] + 1 == $this->[1] && $this->[1] + 1 == $next->[1]) {
            $this->[2] = '-';       # contiguous
        }
    }
    my $join = join '' => map {$_->[2] || $_->[0]} @$work;
    $join =~ s/--+/-/g;
    $join;
}

sub make_converter_sub {
    my $basemap = shift;
    my $srccarr = shift;
    my $srccode = shift;
    my $dstcarr = shift;
    my $dstcode = shift;

    my $srcx = $srccarr.'_emoji';
    my $dstx = $dstcarr.'_emoji';
    my $srcs = $srccode.'_string';
    my $dsts = $dstcode.'_string';

    my $list = $e4u->$basemap->list;

    # source exists
    $list = [grep {defined $_->$srcx} @$list];
    $list = [grep {defined $_->$srcx->$srcs} @$list];
    $list = [grep {! $_->$srcx->is_alt} @$list];

    # dest exists
    $list = [grep {defined $_->$dstx} @$list];
    $list = [grep {defined $_->$dstx->$dsts} @$list];

    # only sun (for test use)
    if ($opt{digests}) {
        if ($basemap eq 'google') {
            $list = [grep {$_->google_emoji->unicode_string =~ $RE_TESTS} @$list];
        } else {
            my $name = $srccarr;
            $name = 'kddi' if ($srccarr eq 'kddiweb');
            $list = [grep {$e4u->google->find($name => $_->unicode)->google_emoji->unicode_string =~ $RE_TESTS} @$list];
        }
    }

    # sort by source
    $list = [sort {$a->$srcx->$srcs cmp $b->$srcx->$srcs} @$list];

    # skip through
    $list = [grep {$_->$srcx->$srcs ne $_->$dstx->$dsts} @$list];
    
    my $subname = join '_' => $srccarr, $srccode, 'to', $dstcarr, $dstcode;
    my $maphash = {map {$_->$srcx->$srcs => $_->$dstx->$dsts} @$list};
    my $out     = [];
    push @$out, get_mapping_sub($srccarr, $subname, $maphash);
    join_escape_nonascii(@$out);
}

sub get_mapping_sub {
    my $srccarr = shift;
    my $subname = shift;
    my $maphash = shift;

    my $maplen = scalar keys %$maphash;
    my $srclen = length join '' => keys %$maphash;
    my $dstlen = length join '' => values %$maphash;

    my $out = [];
    print STDERR $subname, "\n";

    push @$out, "sub ", $subname, " {\n";
    if ($maplen == 0) {
        # no need to translate
        push @$out, $INDENT, "# through\n";
    } elsif ($maplen == $srclen && $maplen == $dstlen) {
        # 1:1 translate (tr/// would be 20-50% faster than s///)
        my $srclist  = [sort keys %$maphash];
        my $dstlist  = [map {$maphash->{$_}} @$srclist];
        my $srcjoin = get_tr_list($srclist);
        my $dstjoin = get_tr_list($dstlist);
        push @$out, $INDENT, "\$_[1] =~ tr\n";
        push @$out, $INDENT, "[$srcjoin]\n";
        push @$out, $INDENT, "[$dstjoin];\n";
    } else {
        # N:M translate
        my $revar  = sprintf 'ReEmoji%sUnicode' => ucfirst $srccarr;
        my $mapvar = 'map_'. $subname;
        my $c      = 0;
        my $work   = [];
        foreach my $src (sort keys %$maphash) {
            my $split = $c++ % 3 ? " " : "\n";
            my $txt = sprintf '%s"%s"=>"%s"' => $split, $src, $maphash->{$src};
            push @$work, $txt;
        }
        my $tmp = [];
        push @$tmp, 'our %', $mapvar, " = (";
        push @$tmp, join ',' => @$work;
        push @$tmp, "\n);\n\n";
        unshift @$out, join '' => @$tmp;

        my $insub = sprintf 'InEmoji%sUnicode' => ucfirst $srccarr;
        push @$out, $INDENT, 'my $check = $_[2] || ', "sub {''};\n";
        push @$out, $INDENT, '$_[1] =~ s{', "\n";
        push @$out, $INDENT x 2, '($', $revar, ')', "\n";
        push @$out, $INDENT, "}{\n";
        push @$out, $INDENT x 2, '$', $mapvar, '{$1} || &$check(ord $1)', "\n";
        push @$out, $INDENT, "}egomx;\n";
    }
    push @$out, "}\n\n";
    @$out;
}

# CharnamesEmojiGoogle

sub make_charnames_var {
    my $basemap = shift;
    my $srccarr = shift;

    my $srcx = $srccarr.'_emoji';
    my $srcs = 'unicode_string';
    my $list  = $e4u->$basemap->list;
    $list = [grep {$_->$srcx && defined $_->$srcx->$srcs} @$list];
    $list = [sort {$a->$srcx->$srcs cmp $b->$srcx->$srcs} @$list];

    my $c   = 0;
    my $map = [];
    foreach my $e (@$list) {
        my $str = $e->$srcx->$srcs;
        next if (length $str > 1);
        # only sun (for test use)
        if ($opt{digests}) {
            next unless ($str =~ $RE_TESTS);
        }
        my $hex = sprintf '%04X' => ord $str;
        my $name;
        if ($srccarr eq 'unicode') {
            # english name
            $name = $e->name;
        } elsif ($srccarr eq 'google') {
            # fallback
            $name = &find_name_ja(google => $hex);
        } else {
            # carrier name_ja
            $name = $e->name_ja;
#           $name = $e4u->$basemap->find(unicode => $hex)->name_ja;
        }
        next unless defined $name;
        $name =~ s/([\'\"\$\@\%\&\*\\])/\\$1/g;
        my $split = $c++ % 4 ? " " : "\n";
        my $txt = sprintf '%s"%s"=>"%s"' => $split, $hex, $name;
        push @$map, $txt;
    }

    my $out = [];
    my $cnvar = sprintf 'CharnamesEmoji%s' => ucfirst $srccarr;
    print STDERR $cnvar, "\n";
    push @$out, 'our %', $cnvar, " = (";
    push @$out, join ', ' => @$map;
    push @$out, "\n);\n\n";
    join_escape_pua(@$out);
}

sub find_name_ja {
    my $text = &_find_name_ja(@_);
    return unless defined $text;
    $text =~ s/^\[?//s;
    $text =~ s/\]?$//s;
    return if ($text eq '');
    $text;
}

sub _find_name_ja {
    my $egoogle = $e4u->google->find(@_) or return;
    my $text    = $egoogle->text_fallback;
    return $text if $text;

    my $docomo = $egoogle->docomo;
    if ($docomo && ! $egoogle->docomo_emoji->is_alt) {
        my $edocomo = $e4u->docomo->find(unicode => $docomo);
        $text = $edocomo->name_ja if $edocomo;
        return $text if $text;
    }

    my $kddi = $egoogle->kddi;
    if ($kddi && ! $egoogle->kddi_emoji->is_alt) {
        my $ekddi = $e4u->kddi->find(unicode => $kddi);
        $text = $ekddi->name_ja if $ekddi;
        return $text if $text;
    }

    my $softbank = $egoogle->softbank;
    if ($softbank && ! $egoogle->softbank_emoji->is_alt) {
        my $esoftbank = $e4u->softbank->find(unicode => $softbank);
        $text = $esoftbank->name_ja if $esoftbank;
        return $text if $text;
    }

    # otherwise, check alternative emoji name
    if ($docomo) {
        $docomo =~ s/^>//;
        my $edocomo = $e4u->docomo->find(unicode => $docomo);
        $text = $edocomo->name_ja if $edocomo;
        return $text if $text;
    }
    if ($kddi) {
        $kddi =~ s/^>//;
        my $ekddi = $e4u->kddi->find(unicode => $kddi);
        $text = $ekddi->name_ja if $ekddi;
        return $text if $text;
    }
    if ($softbank) {
        $softbank =~ s/^>//;
        my $esoftbank = $e4u->softbank->find(unicode => $softbank);
        $text = $esoftbank->name_ja if $esoftbank;
        return $text if $text;
    }

    undef;
}

sub join_escape_pua {
    my $text = join '' => @_;
    $text =~ s/(\p{PrivateUse})/sprintf("\\x{%04X}",ord($1))/ge;
    $text;
}

sub join_escape_nonascii {
    my $text = join '' => @_;
    $text =~ s/([^\x00-\x7e])/sprintf("\\x{%04X}",ord($1))/ge;
    $text;
}

&main();

__DATA__
=head1 NAME

Encode::JP::Emoji::Mapping - Emoji mappings

=head1 SYNOPSIS

    $ perl tools/make-mapping-pm.pl > lib/Encode/JP/Emoji/Mapping.pm

=head1 DESCRIPTION

B<DO NOT> edit this file but generate it as above.

=head1 SEE ALSO

L<Encode::JP::Emoji>

=cut

package Encode::JP::Emoji::Mapping;
use strict;
use warnings;
use utf8;
