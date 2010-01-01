#!/usr/bin/perl
# $Id: gprintify 257533 2009-05-23 12:45:15Z guillomovitch $

use strict;
use warnings;
use Utils qw/run get_md5/;
use Test::More;
use File::Temp qw/tempdir/;
use File::Path qw/make_path/;

plan tests => 2;

# test the script itself
my ($buildroot, $test, $before, $after);

($buildroot, $test) = setup(<<EOF);
foo\r
EOF
$before = get_md5($test);
run($buildroot, 'fix_eol');
$after = get_md5($test);

isnt(
    $before,
    $after,
    'script should be modified'
);

($buildroot, $test) = setup(<<EOF);
foo\r
EOF
$before = get_md5($test);
$ENV{EXCLUDE_FROM_EOL_CONVERSION} = 'test';
run($buildroot, 'fix_eol');
$after = get_md5($test);

is(
    $before,
    $after,
    'EXCLUDE_FROM_EOL_CONVERSION should prevent end-of-line conversion'
);

sub setup {
    my ($content) = @_;

    my $buildroot = tempdir(CLEANUP => ($ENV{TEST_DEBUG} ? 0 : 1));

    my $initrddir = $buildroot . '/etc/rc.d/init.d';
    my $datadir   = $buildroot . '/usr/share';
    my $test = $datadir . '/test';

    make_path($datadir);
    open(my $out, '>', $test) or die "can't write to $test: $!";
    print $out $content;
    close($out);

    return ($buildroot, $test);
}
