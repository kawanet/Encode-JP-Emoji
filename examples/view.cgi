#!/usr/bin/perl

use strict;
use warnings;
use lib qw(../../../Encode-JP-Emoji/trunk/lib);
use lib qw(../../../Encode-JP-Emoji-FB_EMOJI_TYPECAST/trunk/lib);
use lib qw(../../../Encode-JP-Emoji-FB_EMOJI_GMAIL/trunk/lib);

use CGI qw(-oldstyle_urls);
use Encode;
use Encode::JP::Emoji;
use Encode::JP::Emoji::FB_EMOJI_TEXT;

eval "use Encode::JP::Emoji::FB_EMOJI_GMAIL;";      # optional
eval "use Encode::JP::Emoji::FB_EMOJI_TYPECAST;";   # optional

sub main {
    my $path = ($0 =~ m#([^/]+)$#)[0];
    my $cgi = CGI->new();

    my $carrier = 'docomo';
    $carrier = 'kddiweb' if ($ENV{HTTP_USER_AGENT} =~ m#^(UP.Browser|KDDI-)#i);
    $carrier = 'softbank3g' if ($ENV{HTTP_USER_AGENT} =~ m#^(J-PHONE|Vodafone|SoftBank|Semulator)/#i);

    my $src = $cgi->param('src') || $carrier;
    my $dst = $cgi->param('dst') || $carrier;
    my $oe  = $cgi->param('oe')  || 'UTF-8';
    my $filter = $cgi->param('filter') || '0';

    $oe = 'UTF-8' if ($dst eq 'google' || $dst eq 'unicode');
    my $oeshort = ($oe =~ /^utf-?8/i ? 'utf8' : 'sjis');
    my $dstenc  = "x-$oeshort-e4u-$dst";

    my $srcenc;
    my $srclist;
    if ($src eq 'docomo') {
        $srcenc = 'x-utf8-e4u-docomo';
        $srclist = [0xE63E ... 0xE757];
    } elsif ($src eq 'kddiapp') {
        $srcenc = 'x-utf8-e4u-kddiapp';
        $srclist = [0xE468 ... 0xE5DF, 0xEA80 ... 0xEB8E]
    } elsif ($src eq 'kddiweb') {
        $srcenc = 'x-utf8-e4u-kddiweb';
        $srclist = [0xEC40 ... 0xEC7E, 0xEC80 ... 0xECFC, 0xED40 ... 0xED7E, 
                    0xED80 ... 0xED93, 0xEF40 ... 0xEF7E, 0xEF80 ... 0xEFFC, 
                    0xF040 ... 0xF07E, 0xF080 ... 0xF0FC, ]
    } elsif ($src eq 'softbank3g') {
        $srcenc = 'x-utf8-e4u-softbank3g';
        $srclist = [0xE001 ... 0xE05A, 0xE101 ... 0xE15A, 0xE201 ... 0xE25A, 
                    0xE301 ... 0xE34D, 0xE401 ... 0xE44C, 0xE501 ... 0xE53E];
    } else {
        die "Invalid src: $src\n";
    }

    my $body = [];

    my $var = $cgi->Vars;
    $var = { %$var };       # copy
    $var->{t}   = int(rand(9000)+1000);
    $var->{cgi} = ($0 =~ m#([^/]+)$#)[0];
    $var->{pc}  = ($ENV{HTTP_USER_AGENT} =~ m#^Mozilla/#);
    $var->{gmail_ok}    = $var->{pc} && $Encode::JP::Emoji::FB_EMOJI_GMAIL::VERSION;
    $var->{typecast_ok} = $var->{pc} && $Encode::JP::Emoji::FB_EMOJI_TYPECAST::VERSION;
    $var->{oe}  = $oe;
    my $type = $var->{type} || 'html';
    $var->{xhtml} = ($type eq 'xhtml');
    $var->{html}  = ($type eq 'html');
    push @$body, read_form($var);

    my $prevline = -1;
    my $prevcode = 0;
    foreach my $code (@$srclist) {
        my $line = $code - $code % 16;
        if ($line != $prevline) {
            push @$body, "<br/>\n";
            my $hex = sprintf '%04X' => $line;
            push @$body, "U+$hex ";
            $prevline = $line;
            $prevcode = $line - 1;
        }
        if ($prevcode + 1 != $code) {
            push @$body, "\x{3000}" x ($code - $prevcode - 1);
        }
        $prevcode = $code;
        my $utf8 = encode(utf8 => chr $code);
        my $char = decode($srcenc => $utf8);
        push @$body, $char;
    }
    push @$body, "\n";
    push @$body, "</body>\n";
    push @$body, "</html>\n";

    my $string = join '' => splice @$body;
    my $check = FB_EMOJI_TEXT();
    my $octets = encode($dstenc, $string, $check);

    if ($filter) {
        my $postcheck;
        if ($filter == 1) {
            $postcheck = Encode::FB_XMLCREF();
        } elsif ($filter == 2) {
            $postcheck = FB_EMOJI_TEXT();
        } elsif ($filter == 3) {
            $postcheck = FB_EMOJI_GMAIL();
        } elsif ($filter == 4) {
            $postcheck = FB_EMOJI_TYPECAST();
        } else {
            die "Invalid filter: $filter\n";
        }
        my $workenc = "x-$oeshort-emoji-$dst";
        $workenc = 'utf8' if ($dst eq 'google' || $dst eq 'unicode');
        my $noneenc = "x-$oeshort-e4u-none";
        Encode::from_to($octets, $workenc, $noneenc, $postcheck);
    }

    print "Content-Type: text/html; charset=$oe\n" unless $var->{xhtml};
    print "Content-Type: application/xhtml+xml\n" if $var->{xhtml};
    print "Content-Length: ", (length $octets), "\n";
    print "\n";
    print $octets;
}

sub read_form {
    my $var  = shift;
    my $form = join '' => <DATA>;
    $form =~ s{
        <!--\[\[(\w+)\]\[-->(.*?)<!--\]\[(\w+)\]\]-->
    }{
        $var->{$1} ? $2 : ""
    }gexs;
    $form =~ s{
        \[\[([\w\-]+)\]\]
    }{
        $var->{$1};
    }gexm;
    $form =~ s{
        \[\[([\w\-]+)(\!?=)([\w\-]+)\?([\w\-]+(?:="[\w\-]*")?)\]\]
    }[
        my ($key, $op, $val, $out) = ($1, $2, $3, $4);
        ! defined $var->{$key} ? "" :
        ((($op eq '=') xor ($var->{$key} eq $val)) ? "" : $out);
    ]gexm;
    $form;
}

main();

__DATA__
<!--[[xhtml][--><?xml version="1.0" encoding="[[oe]]"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.0//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--][xhtml]]-->
<!--[[html][-->
<html>
<!--][html]]-->
<head>
<!--[[html][-->
<meta http-equiv="Content-Type" content="text/html; charset=[[oe]]" />
<!--][html]]-->
</head>
<body>
<form action="[[cgi]]" method="GET">
<select name="src">
<option value="docomo" [[src=docomo?selected="selected"]]>src: docomo</option>
<option value="kddiapp" [[src=kddiapp?selected="selected"]]>src: kddiapp</option>
<option value="kddiweb" [[src=kddiweb?selected="selected"]]>src: kddiweb</option>
<option value="softbank3g" [[src=softbank3g?selected="selected"]]>src: softbank3g</option>
</select><br/>
<select name="dst">
<option value="docomo" [[dst=docomo?selected="selected"]]>dst: docomo</option>
<option value="kddiapp" [[dst=kddiapp?selected="selected"]]>dst: kddiapp</option>
<option value="kddiweb" [[dst=kddiweb?selected="selected"]]>dst: kddiweb</option>
<option value="softbank2g" [[dst=softbank2g?selected="selected"]]>dst: softbank2g</option>
<option value="softbank3g" [[dst=softbank3g?selected="selected"]]>dst: softbank3g</option>
<!--[[pc][-->
<option value="google" [[dst=google?selected="selected"]]>dst: google</option>
<option value="unicode" [[dst=unicode?selected="selected"]]>dst: unicode</option>
<!--][pc]]-->
</select><br/>
<select name="oe">
<option value="Shift_JIS" [[oe=Shift_JIS?selected="selected"]]>oe: Shift_JIS</option>
<option value="UTF-8" [[oe=UTF-8?selected="selected"]]>oe: UTF-8</option>
</select><br/>
<select name="filter">
<option value="0" [[filter=0?selected="selected"]]>filter: binary</option>
<option value="1" [[filter=1?selected="selected"]]>filter: xmlcref</option>
<option value="2" [[filter=2?selected="selected"]]>filter: text</option>
<!--[[gmail_ok][-->
<option value="3" [[filter=3?selected="selected"]]>filter: gmail</option>
<!--][gmail_ok]]-->
<!--[[typecast_ok][-->
<option value="4" [[filter=4?selected="selected"]]>filter: typecast</option>
<!--][typecast_ok]]-->
</select><br/>
<select name="type">
<option value="html" [[type=html?selected="selected"]]>type: html</option>
<option value="xhtml" [[type=xhtml?selected="selected"]]>type: xhtml</option>
</select><br/>
<input type="hidden" name="t" value="[[t]]"/>
<input type="submit" value="update"/>
</form>
