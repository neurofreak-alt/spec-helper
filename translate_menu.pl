#!/usr/bin/perl -w
#---------------------------------------------------------------
# Project         : Mandrake Linux
# Module          : spec-helper
# File            : translate_menu.pl
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Mon Jan 26 13:37:49 2004
# Purpose         : change the menu sections
#---------------------------------------------------------------

my @nested = (["Configuration", "System/Configuration"],

	   ["Applications/Monitoring", "System/Monitoring"],
	   ["Applications/Publishing", "Office/Publishing"],
	   ["Applications/File tools", "System/File tools"],
	   ["Applications/Text tools", "System/Text tools"],
	   ["Applications/Archiving", "System/Archiving"],
	   ["Applications", "More applications"],

	   ["Terminals", "System/Terminals"],
	   
	   ["Documentation", "More applications/Documentation"],
	   
           ["Office/PDA", "Office/Communications/PDA"],

	   ["Networking/IRC", "Internet/Chat"],
	   ["Networking/WWW", "Internet/Web browsers"],
	   ["Networking", "Internet"],
	   
	   ["Amusement", "More applications/Games"],
	   ["Session/Windowmanagers", "System/Session/Windowmanagers"],
	   );

sub translate {
    my ($str) = @_;

    foreach my $t (@nested) {
	if ($str =~ /(.*)$t->[0](.*)/ && $str !~ /$t->[1]/) {
	    print "$str => $1$t->[1]$2\n";
	    return "$1$t->[1]$2";
	}
    }
    return $str;
}

# process each file passed on cli:
foreach my $file (@ARGV) {
    open(my $FILE, "<$file");
    my @lines = <$FILE>;
    close($FILE);
    open($FILE, ">$file");
    foreach my $l (@lines) {
	chomp($l);
	if ($l =~ /(.*section=)"([^"]+)"(\s+.*)/ || $l =~ /(.*section=)([^"].+?)((\s|\\)+.*)/) {
	    my ($beg, $section, $end) = ($1, $2, $3);
            $section = translate($section);
            $l = qq($beg"$section"$end);
	}
	print $FILE "$l\n";
    }
    close($FILE);
}

# translate_menu.pl ends here
