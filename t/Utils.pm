package Utils;

use strict;
use warnings;
use base qw(Exporter);
use FindBin qw/$Bin/;
use Digest::MD5;

our @EXPORT_OK = qw(run get_md5);


sub run {
    my ($buildroot, $program) = @_;

    $ENV{RPM_BUILD_ROOT} = $buildroot;
    system("$Bin/../$program");
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

1;
