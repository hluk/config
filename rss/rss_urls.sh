#!/bin/sh
if [ -z "$1" ]
then
	exit 1
fi

xmllint --format --nocdata "$1" | sed -n '
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

