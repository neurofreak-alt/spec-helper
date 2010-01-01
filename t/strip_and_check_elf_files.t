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

($buildroot, $test) = setup();

$before = get_md5($test);
run($buildroot, 'strip_and_check_elf_files');
$after = get_md5($test);

isnt(
    $before,
    $after,
    'test should be modified'
);

($buildroot, $test) = setup();

$before = get_md5($test);
$ENV{EXCLUDE_FROM_STRIP} = 'test';
run($buildroot, 'strip_and_check_elf_files');
$after = get_md5($test);

is(
    $before,
    $after,
    'EXCLUDE_FROM_STRIP should prevent test stripping'
);

sub setup {

    my $source = File::Temp->new(UNLINK => 1, SUFFIX => '.c');
    print $source <<'EOF';
#include <stdio.h>
 
int main()
{
    printf("Hello world!\n");
    return 0;
}
EOF
    close($source);

    my $buildroot = tempdir(CLEANUP => ($ENV{TEST_DEBUG} ? 0 : 1));
    my $bindir = $buildroot . '/usr/bin';
    my $test = $bindir . '/test';
    make_path($bindir);

    system('gcc', '-o', $test, $source);

    return ($buildroot, $test);
}
