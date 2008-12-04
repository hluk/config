#!/bin/sh
if [ -z "$1" ]
then
	exit 1
fi

(wget -q -O - "$1" || (echo "$1" | sed 's_^file:/__' | xargs cat)) | xml_parser - | sed -n '
	/^ *> rss 2\b/,/^ *< rss 2\b/ {
		/^ *> item\b/,/^ *< item\b/ {
			/^ *> link\b/,+1 {s_\[pcdata\[\([^]]*\)\]\] [45]$_\1_p};
		}
	}
	/^ *> feed 2\b/,/^ *< feed 2\b/ {
		/^ *> entry\b/,/^ *< entry\b/ {
			/^ *> id\b/,+1 {s_\[pcdata\[\([^]]*\)\]\] [45]$_\1_p};
		}
	}
	/^ *> rdf:RDF 2\b/,/^ *< rdf:RDF 2\b/ {
		/^ *> item\b/,/^ *< item\b/ {
			/^ *> link\b/,+1 {s_\[pcdata\[\([^]]*\)\]\] [45]$_\1_p};
		}
	}'
exit $?

