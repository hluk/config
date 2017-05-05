#!/usr/bin/env python
import json
import urllib.request

user = "hluk"
repo = "CopyQ"
url = "https://api.github.com/repos/%(user)s/%(repo)s/releases" % {
        "user": "hluk",
        "repo": "CopyQ"
        }

response = urllib.request.urlopen(url)
data = response.read().decode('utf-8')

releases = json.loads(data)
for release in reversed(releases):
    name = release["name"] or ""
    print("CopyQ " + name)
    assets = release["assets"]
    total = 0
    for asset in assets:
        name = asset["name"]
        count = asset["download_count"]
        total += count
        print(" %(count)8d  %(name)s" % {"name": name, "count": count})
    print(" %(total)8d  (total)" % {"total": total})
