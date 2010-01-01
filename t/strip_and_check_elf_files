#!/usr/bin/perl
# $Id: gprintify 257533 2009-05-23 12:45:15Z guillomovitch $

use strict;
use warnings;
use Test::More;
use File::Temp qw/tempdir/;
use File::Path qw/make_path/;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Digest::MD5;

plan tests => 2;

# test the script itself
my ($buildroot, $binary, $before, $after);

($buildroot, $binary) = setup();

$before = get_md5($binary);
run($buildroot);
$after = get_md5($binary);

isnt(
    $before,
    $after,
    'binary should be modified'
);

($buildroot, $binary) = setup();

$before = get_md5($binary);
$ENV{EXCLUDE_FROM_STRIP} = 'test';
run($buildroot);
$after = get_md5($binary);

is(
    $before,
    $after,
    'EXCLUDE_FROM_STRIP should prevent binary stripping'
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
    my $binary = $bindir . '/test';
    make_path($bindir);

    system('gcc', '-o', $binary, $source);

    return ($buildroot, $binary);
}

sub run {
    my ($buildroot) = @_;

    $ENV{RPM_BUILD_ROOT} = $buildroot;
    system("$Bin/../strip_and_check_elf_files");
}

sub get_md5 {
    my ($file) = @_;
    open(my $in, '<', $file) or die "can't read $file: $!";
    binmode($in);
    my $md5 = Digest::MD5->new();
    $md5->addfile($in);
    close($in);
    return $md5->hexdigest();
}
