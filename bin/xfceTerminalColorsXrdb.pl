#!/usr/bin/perl
# Parses "xrdb -query" or .Xresources on input and outputs xfce4-terminal (~/.config/xfce4/terminal/terminalrc)
use strict;
use warnings;

my @colors = (1 .. 8);

while (<>) {
    if (/^Rxvt.(?<id>[a-z]*)(?<n>\d*)\s*:\s*rgb:(?<r>..)\/(?<g>..)\/(?<b>..)/) {
        my $r = hex($+{r});
        my $g = hex($+{g});
        my $b = hex($+{b});

        my $color = sprintf("#%2x%2x%2x", $r, $g, $b);

        if ($+{id} =~ /foreground/i) {
            print "ColorForeground=".$color."\n";
        } elsif ($+{id} =~ /background/i) {
            print "ColorBackground=".$color."\n";
        } elsif ($+{n} !~ "") {
            @colors[$+{n}] = $color;
        }
    }
}

print "ColorPalette=".join(";", @colors)."\n";

