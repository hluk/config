#!/usr/bin/env python
'''
File: find_iptv.py
Author: Lukas Holecek (hluk@email.cz)
Description:
    Find IPTV channel name (using VLC finds "Digital television service"
    stream name) for given URLs.
'''

import sys
import subprocess
import re
import select

secs_wait = 10
command = '''
cvlc --no-audio --no-video -vv
--udp-caching 0 --http-caching 0 --mms-caching 0 --file-caching 0 --network-caching 0 --rtp-caching 0 --tcp-caching 0
%s vlc://quit
'''

re_channel = re.compile(r'^\[[^]]+\] ts demux debug:\s*- type=1 .*name=(.*)')

def main():
    for url in sys.argv[1:]:
        cmd = command % (url)
        name = None

        print(url, end="")
        sys.stdout.flush()

        p = subprocess.Popen(cmd.split(), stdout=None, stderr=subprocess.PIPE)
        while p.poll() is None and select.select([p.stderr], [], [], secs_wait)[0]:
            line = p.stderr.readline()
            m = re_channel.match(line.decode())
            if m:
                name = m.group(1)
                break
        if p.poll() is None:
            p.kill()

        if name:
            print(" "+name)
        else:
            print()

if __name__ == '__main__':
    main()

