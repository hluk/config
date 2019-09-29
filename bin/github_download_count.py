#!/usr/bin/env python3
import json
import urllib.request

user = 'hluk'
repo = 'CopyQ'
url = 'https://api.github.com/repos/{user}/{repo}/releases'.format(user=user, repo=repo)

response = urllib.request.urlopen(url)
data = response.read().decode('utf-8')

releases = json.loads(data)
for release in reversed(releases):
    release_name = release.get('name', '')
    print('{} {}'.format(repo, release_name))
    assets = release['assets']
    total = 0
    for asset in assets:
        asset_name = asset['name']
        count = asset['download_count']
        total += count
        print(' {:>8}  {}'.format(count, asset_name))
    print(' {:>8}  (total)'.format(total))
