#!/bin/sh
if [ -z "$1" ]
then
	exit 1
fi

# use wget to fetch RSS - xmllint doesn't escape '[' and ']' characters in URL
wget -O - "$1" | xmllint --format --nocdata --recover - | sed -n '
	/^<rss[ >]/,/^<\/rss>/ {
		/^    <item[ >]/,/^    <\/item>/ {
			s_^      <link>\(.*\)</link>_\1_p
		}
	}
	/^<feed[ >]/,/^<\/feed>/ {
		/^  <entry[ >]/,/^  <\/entry>/ {
			s_^    <link href="\([^"]*\).*rel="alternate".*_\1_p
		}
	}
	/^<rdf:RDF[ >]/,/^<\/rdf:RDF/ {
		/^  <item[ >]/,/^    <\/item>/ {
			s_^    <link>\(.*\)</link>_\1_p
		}
	}'
exit $?

