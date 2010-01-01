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

my @string_results = (
    [ 'result: $foo', 'result: %s', ' "$foo"' ],
    [ 'result: $foo,$bar', 'result: %s,%s', ' "$foo" "$bar"' ],
    [ 'result: \$foo', 'result: \$foo', '' ],
    [ 'result: \$foo,$bar', 'result: \$foo,%s', ' "$bar"' ],
    [ 'result: ${foo}', 'result: %s', ' "${foo}"', '' ],
    [ 'result: ${foo##*/}', 'result: %s', ' "${foo##*/}"' ],
    [ 'result: ${foo%%*/}', 'result: %s', ' "${foo%%*/}"' ],
    [ 'result: ${foo#*/}', 'result: %s', ' "${foo#*/}"' ],
    [ 'result: ${foo%*/}', 'result: %s', ' "${foo%*/}"' ]
);
my @start_results = (
    [ 'echo "result: $foo"', 'gprintf "', '\n"' ],
    [ '# echo "result: $foo"', '# gprintf "', '\n"' ],
    [ 'echo -n "result: $foo"', 'gprintf "', '"' ],
    [ 'echo -e "result: $foo"', 'gprintf "', '\n"' ],
);

my @line_results = (
    [ 
        'echo "result: $foo"' . "\n",
        'gprintf "result: %s\n" "$foo"' . "\n"
    ],
    [ 
        'echo "result: \"$foo\""' . "\n",
        'gprintf "result: \"%s\"\n" "$foo"' . "\n"
    ],
    [
        'test "$foo" != "AB"',
        'test "$foo" != "AB"',
    ]
);

plan tests =>
    4 + (@string_results * 2) + (@start_results * 2) + (@line_results);

# test loading
ok(require("gprintify"), "loading file OK");

# test string function
foreach my $result (@string_results) {
    my ($new_string, $variables) = process_string($result->[0]);
    is($new_string, $result->[1], "new string OK");
    is($variables, $result->[2], "variable OK");
}

# test start function
foreach my $result (@start_results) {
    my ($new_start, $string_end) = process_start($result->[0]);
    is($new_start, $result->[1], "new start OK");
    is($string_end, $result->[2], "string end OK");
}

# test line function
foreach my $result (@line_results) {
    my ($new_line) = process_line($result->[0]);
    is($new_line, $result->[1], "new line OK");
}

# test the script itself
my ($buildroot, $script, $before, $after);

($buildroot, $script) = setup(<<'EOF');
echo "Usage: $0 {start|stop|status}"
EOF

$before = get_md5($script);
run($buildroot);
$after = get_md5($script);

is(
    $before,
    $after,
    'service not sourcing /etc/init.d/functions should not be modified'
);

($buildroot, $script) = setup(<<'EOF');
. /etc/init.d/functions
echo "Usage: $0 {start|stop|status}"
EOF

$before = get_md5($script);
run($buildroot);
$after = get_md5($script);

isnt(
    $before,
    $after,
    'service sourcing /etc/init.d/functions should be modified'
);

($buildroot, $script) = setup(<<'EOF');
. /etc/init.d/functions
echo "Usage: $0 {start|stop|status}"
EOF

$before = get_md5($script);
$ENV{EXCLUDE_FROM_GPRINTIFICATION} = 'test';
run($buildroot);
$after = get_md5($script);

is(
    $before,
    $after,
    'EXCLUDE_FROM_GPRINTIFICATION should prevent service modification'
);

sub setup {
    my ($content) = @_;

    my $buildroot = tempdir(CLEANUP => ($ENV{TEST_DEBUG} ? 0 : 1));

    my $initrddir = $buildroot . '/etc/rc.d/init.d';
    my $script = $initrddir . '/test';

    make_path($initrddir);
    open(my $out, '>', $script) or die "can't write to $script: $!";
    print $out $content;
    close($out);

    return ($buildroot, $script);
}

sub run {
    my ($buildroot) = @_;

    $ENV{RPM_BUILD_ROOT} = $buildroot;
    system("$Bin/../gprintify");
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
