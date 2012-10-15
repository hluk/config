#!/usr/bin/perl
# Parses "xrdb -query" or .Xresources on input and outputs Konsole colorscheme file (~/.kde4/share/apps/konsole/)
use strict;
use warnings;
use List::Util qw[min max];

sub intense
{
    return min($_[0] + 30, 255) . ',' . min($_[2] + 30, 255) . ',' . min($_[2] + 30, 255);
}

while (<>) {
    if (/^Rxvt.(?<id>[a-z]*)(?<n>\d*)\s*:\s*rgb:(?<r>..)\/(?<g>..)\/(?<b>..)/) {
        my $r = hex($+{r});
        my $g = hex($+{g});
        my $b = hex($+{b});
        my $color="Color=$r,$g,$b\n\n";
        if ($+{id} =~ /foreground/i) {
            print "[ForegroundIntense]\nColor=".intense($r,$g,$b)."\n\n";
            print "[Foreground]\n";
        } elsif ($+{id} =~ /background/i) {
            print "[BackgroundIntense]\nColor=".intense($r,$g,$b)."\n\n";
            print "[Background]\n";
        } elsif ($+{n} !~ "") {
            if ($+{n} > 7) {
                print "[Color" . ($+{n} - 8) . "Intense]\n" . (($+{n} == 15) ? "" : "Bold=true\n");
            } else {
                print "[Color" . $+{n} . "]\n";
            }
        } else {
            print "# unknown id: " . $+{id} . $+{n} . "  ";
        }
        print $color;
    }
}

print "[General]
Description=User
Opacity=0.90
Wallpaper=

";

