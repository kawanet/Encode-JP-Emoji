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

if (scalar @ARGV == 1 && $ARGV[0] eq '-h') {
    print STDERR "Usage:\n";
    print STDERR "* to parse local data files:\n";
    print STDERR "$0 datadir ../Unicode-Emoji-E4U/trunk/data > lib/Encode/JP/Emoji/Mapping.pm\n";
    print STDERR "* to fetch data files from google code (default):\n";
    print STDERR "$0 datadir http://emoji4unicode.googlecode.com/svn/trunk/data > lib/Encode/JP/Emoji/Mapping.pm\n";
    exit;
}

my %opt = @ARGV;
$opt{verbose} = 1 unless exists $opt{verbose};
my $e4u = Unicode::Emoji::E4U->new(%opt);

sub main {
    print encode utf8 => &make_mapping_pm;
}

sub make_mapping_pm {
    my $out  = [];

    push @$out, <DATA>;
    push @$out, "\n";
    push @$out, &make_property;
    push @$out, &make_converter;
    push @$out, &make_mixed_encoding;
    push @$out, &make_charnames;
    push @$out, "1;\n";

    join '' => @$out;
}

sub make_charnames {
    my $out  = [];

    foreach my $carrier (@$UTF8_SRC) {
        my $basemap = ($carrier eq 'unicode') ? 'google' : $carrier;
        push @$out, &make_charnames_var($basemap, $carrier);
    }

    print STDERR (scalar @$out), " charnames\n";
    @$out;
}

sub make_property {
    my $out  = [];

    foreach my $carrier (@$CP932_SRC) {
        push @$out, &make_property_sub($carrier, $carrier, 'CP932');
    }

    foreach my $carrier (@$UTF8_SRC) {
        my $basemap = ($carrier eq 'unicode') ? 'google' : $carrier;
        push @$out, &make_property_sub($basemap, $carrier, 'Unicode');
    }

    print STDERR (scalar @$out), " properties\n";
    @$out;
}

sub make_converter {
    my $out  = [];

    foreach my $carrier (@$CP932_SRC) {
        push @$out, &make_converter_sub($carrier, $carrier, 'cp932',   $carrier, 'unicode');
        push @$out, &make_converter_sub($carrier, $carrier, 'unicode', $carrier, 'cp932');
    }
    foreach my $carrier (@$CP932_SRC) {
        push @$out, &make_converter_sub('google', $carrier, 'cp932',   'google', 'unicode');
        push @$out, &make_converter_sub('google', 'google', 'unicode', $carrier, 'cp932');
    }
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

    # single char or more chars
    my $longlist = [grep {length $_->$srcx->$srcs > 1} @$list];
    $list = [grep {length $_->$srcx->$srcs == 1} @$list];

    # sort by source
    $list = [sort {$a->$srcx->$srcs cmp $b->$srcx->$srcs} @$list];

    my $out = [];
    my $invar = sprintf 'InEmoji%s%s' => ucfirst $srccarr, $suffix;
    my $insub = sprintf 'InEmoji%s%s' => ucfirst $srccarr, $suffix;
    my $revar = sprintf 'ReEmoji%s%s' => ucfirst $srccarr, $suffix;

    # in
    {
        my @insrc = map {ord $_->$srcx->$srcs} @$list;
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
        my $longchar = [map {$_->$srcx->$srcs} @$longlist];
        my $list2nd = {map {(/^.(.*)$/)[0] => 1} @$longchar};
        if (keys %$list2nd == 1) {
            # first characters
            my $list1st = [map {(/^(.)/)[0]} @$longchar];
            s/([\x00-\x7F])/sprintf '\x%02X' => ord $1/e foreach @$list1st;
            my $join1st = join '' => @$list1st;

            # second character
            my $chr2nd = (keys %$list2nd)[0];
            $chr2nd =~ s/([\x00-\x7F])/sprintf '\x%02X' => ord $1/e;

            push @$relist, '['.$join1st.']'.$chr2nd;
        } else {
            push @$relist, $_->$srcx->$srcs foreach @$longlist;
        }
        my $rejoin = join '|' => @$relist;
        push @$out, 'our $', $revar, ' = qr/(?:', $rejoin, ')/mo;';
        push @$out, "\n";
    }

    push @$out, "\n";
    join_escape_nonascii(@$out);
}

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
        my $g_alt = $e->google_emoji->is_alt;
        if ($e->unicode_emoji && ! $e->unicode_emoji->is_alt) {
            my $unicode = $e->unicode_emoji->unicode_string;
            if (defined $unicode && 1 == length $unicode) {
                $unicode2google->{$unicode} = $google;
                $google2unicode->{$google}  = $unicode unless $g_alt;
            }
        }
        if ($e->kddi_emoji && ! $e->kddi_emoji->is_alt) {
            my $kddi = $e->kddi_emoji->unicode_string;
            if (defined $kddi && 1 == length $kddi) {
                $kddi2google->{$kddi}   = $google;
                $google2kddi->{$google} = $kddi unless $g_alt;
            }
        }
        if ($e->kddiweb_emoji && ! $e->kddiweb_emoji->is_alt) {
            my $kddiweb = $e->kddiweb_emoji->unicode_string;
            if (defined $kddiweb && 1 == length $kddiweb) {
                $kddiweb2google->{$kddiweb} = $google;
                $google2kddiweb->{$google}  = $kddiweb unless $g_alt;
            }
        }
        if ($e->softbank_emoji && ! $e->softbank_emoji->is_alt) {
            my $softbank = $e->softbank_emoji->unicode_string;
            if (defined $softbank && 1 == length $softbank) {
                $softbank2google->{$softbank} = $google;
                $google2softbank->{$google}   = $softbank unless $g_alt;
            }
        }
        if ($e->docomo_emoji && ! $e->docomo_emoji->is_alt) {
            my $docomo = $e->docomo_emoji->unicode_string;
            if (defined $docomo && 1 == length $docomo) {
                $docomo2google->{$docomo} = $google;
                $google2docomo->{$google} = $docomo unless $g_alt;
            }
        }
    }

    my $mixed2google = {%$unicode2google, %$kddi2google, 
        %$softbank2google, %$kddiweb2google, %$docomo2google};
    my $google2mixed = {%$google2unicode, %$google2kddi, 
        %$google2softbank, %$google2kddiweb, %$google2docomo};

    my $g2msrclist = [sort {$a cmp $b} keys %$google2mixed];
    my $m2gsrclist = [sort {$a cmp $b} keys %$mixed2google];
    my $g2mdstlist = [map {$google2mixed->{$_}} @$g2msrclist];
    my $m2gdstlist = [map {$mixed2google->{$_}} @$m2gsrclist];

    my $g2msrcjoin = get_tr_list($g2msrclist);
    my $g2mdstjoin = join '' => @$g2mdstlist;
    my $m2gsrcjoin = get_tr_list($m2gsrclist);
    my $m2gdstjoin = join '' => @$m2gdstlist;

    my $out = [];
    
	print STDERR "google_unicode_to_mixed_unicode\n";
    push @$out, "sub google_unicode_to_mixed_unicode {\n";
    push @$out, $INDENT, "\$_[1] =~ tr\n";
    push @$out, $INDENT, "[$g2msrcjoin]\n";
    push @$out, $INDENT, "[$g2mdstjoin];\n";
    push @$out, "}\n\n";

	print STDERR "mixed_unicode_to_google_unicode\n";
    push @$out, "sub mixed_unicode_to_google_unicode {\n";
    push @$out, $INDENT, "\$_[1] =~ tr\n";
    push @$out, $INDENT, "[$m2gsrcjoin]\n";
    push @$out, $INDENT, "[$m2gdstjoin];\n";
    push @$out, "}\n\n";

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
##  $list = [grep {$_->$srcx->$srcs eq "\x{FE000}" || $_->$dstx->$dsts eq "\x{FE000}"} @$list];

    # sort by source
    $list = [sort {$a->$srcx->$srcs cmp $b->$srcx->$srcs} @$list];

    my $changed = [grep {$_->$srcx->$srcs ne $_->$dstx->$dsts} @$list];
    my $srcjoin = join '' => map {$_->$srcx->$srcs} @$changed;
    my $dstjoin = join '' => map {$_->$dstx->$dsts} @$changed;

    my $maplen = scalar @$changed;
    my $srclen = length $srcjoin;
    my $dstlen = length $dstjoin;

    my $out = [];
    my $subname = join '_' => $srccarr, $srccode, 'to', $dstcarr, $dstcode;
	print STDERR $subname, "\n";

    push @$out, "sub ", $subname, " {\n";
    if ($maplen == 0) {
        # no need to translate
        push @$out, $INDENT, "# through\n";
    } elsif ($maplen == $srclen && $maplen == $dstlen) {
        # join contiguous characters
        my $srclist  = [map {$_->$srcx->$srcs} @$changed];
        my $dstlist  = [map {$_->$dstx->$dsts} @$changed];
        $srcjoin = get_tr_list($srclist);
        $dstjoin = get_tr_list($dstlist);
        # 1:1 translate (tr/// would be 20-50% faster than s///)
        push @$out, $INDENT, "\$_[1] =~ tr\n";
        push @$out, $INDENT, "[$srcjoin]\n";
        push @$out, $INDENT, "[$dstjoin];\n";
    } else {
        # N:M translate
        my $revar  = sprintf 'ReEmoji%sUnicode' => ucfirst $srccarr;
        my $mapvar = 'map_'. $subname;
        my $tmp = [];
        push @$tmp, 'our %', $mapvar, " = (\n";
        push @$tmp, $INDENT, join ', ' => map {sprintf '"%s"=>"%s"' => $_->$srcx->$srcs, $_->$dstx->$dsts} @$list;
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
    join_escape_nonascii(@$out);
}

sub make_charnames_var {
    my $basemap = shift;
    my $srccarr = shift;

    my $srcx = $srccarr.'_emoji';
    my $srcs = 'unicode_string';
    my $list  = $e4u->$basemap->list;
    $list = [grep {$_->$srcx && defined $_->$srcx->$srcs} @$list];
    $list = [sort {$a->$srcx->$srcs cmp $b->$srcx->$srcs} @$list];

    my $map = [];
    foreach my $e (@$list) {
        my $str = $e->$srcx->$srcs;
        next if (length $str > 1);
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
        my $txt = sprintf '"%s"=>"%s"' => $hex, $name;
        push @$map, $txt;
    }

    my $out = [];
    my $cnvar = sprintf 'CharnamesEmoji%s' => ucfirst $srccarr;
	print STDERR $cnvar, "\n";
    push @$out, 'our %', $cnvar, " = (\n";
    push @$out, $INDENT, join ', ' => @$map;
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
