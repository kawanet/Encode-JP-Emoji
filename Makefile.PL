use strict;
require 5.008001;
use ExtUtils::MakeMaker;

my $opt = {
    NAME                =>  'Encode::JP::Emoji',
    VERSION_FROM        =>  'lib/Encode/JP/Emoji.pm',
    LICENSE             =>  'apache',
    PREREQ_PM           =>  {
        'Test::More'        =>  '0',
        'Test::Harness'     =>  '3.04',
        'Encode'            =>  '0',    # 2.13 or later recommended
    },
};

WriteMakefile( %$opt );
