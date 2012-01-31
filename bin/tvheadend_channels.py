#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
File: tvchannels.py
Author: Lukas Holecek (hluk@email.cz)
Description:
    Parse M3U playlist from netbox.cz and create
    tvheadend channels.
'''

import sys
import os
import re

playlist = "/home/hts/netbox.m3u8"
home_path = "/home/hts/.hts/tvheadend/"
#playlist = "/home/lukas/netbox.m3u8"
#home_path = "/home/lukas/.hts/tvheadend/"

xmltv = {
        'ANIMAL PLANET': 'animalplanet',
        'AXN': 'axn',
        'AXN CRIME': 'axncrime',
        'AXN SCIFI': 'axnscifi',
        'CARTOON NETWORK + TCM': 'cartnet',
        'CINEMAX': 'cinemax',
        'CINEMAX 2': 'cinemax2',
        'CS FILM': 'csfilm',
        'ČT 1': 'ct1',
        'ČT 2': 'ct2',
        'ČT 24': 'ct24',
        'ČT 4 SPORT': 'ct4',
        'DISCOVERY HD': 'discoveryhd' ,
        'DISCOVERY': 'discovery',
        'DISCOVERY WORLD': 'discoveryworld',
        'DISCOVERY SCIENCE': 'discoveryscience',
        'DISCOVERY ID INVESTIGATION': 'discoveryinvestigation',
        'DISNEY CHANNEL': 'disneychannel',
        'STV2': 'disneychannel',
        'STV1': 'dvojka',
        'ESPN CLASSIC': 'jednotka',
        'EUROSPORT': 'eurosport1',
        'EUROSPORT 2': 'eurosport2',
        'EUROSPORT HD': 'eurosport1',
        'X EXTREME SPORT': 'extremesports',
        'FILMBOX': 'filmbox',
        'FILMBOX EXTRA': 'filmboxextra',
        'FILM +': 'filmplus',
        'HBO': 'hbo',
        'HBO HD': 'hbo',
        'HBO 2': 'hbo2',
        'HBO COMEDY': 'hbocomedy',
        'JIM JAM': 'jimjam',
        'JOJ': 'joj',
        'JOJ PLUS': 'jojplus',
        'MARKíZA': 'markiza',
        'MGM': 'mgm',
        'MINIMAX/ANIMAX': 'minimax',
        'MTV': 'mtv',
        'NATIONAL GEOGRAPHIC CHANNEL': 'nationalgeographic',
        'NATIONAL GEOGRAPHIC WILD': 'nationalgeographicwild',
        'NOVA': 'nova',
        'NOVA HD': 'nova',
        'NOVA CINEMA': 'novacinema',
        'NOVA SPORT': 'novasport',
        'NOVA SPORT HD': 'novasport',
        'ÓČKO': 'ocko',
        'ORF EINS': 'orf1',
        'ORF 2': 'orf2',
        'PRIMA': 'prima',
        'PRIMA HD': 'prima',
        'PRIMA COOL': 'primacool',
        'PRIMA LOVE': 'primalove',
        'PRO 7': 'pro7',
        'RTL': 'rtl',
        'SAT 1': 'sat1',
        'SPECTRUM': 'spektrum',
        'SPORT 1': 'sport1',
        'SPORT 5': 'sport5',
        'TA3': 'ta3',
        'FISHING & HUNTING': 'thefishingandhunting',
        'HISTORY CHANNEL': 'thehistorychannel',
        'HISTORY': 'thehistorychannel',
        'HISTORY HD': 'thehistorychannelhd',
        'TRAVEL': 'travelchannelhd',
        'TRAVEL & LIVING': 'travelchannelhd',
        'TV BARRANDOV': 'tvbarrandov',
        'NOE': 'tvnoe',
        'PAPRIKA': 'tvpaprika',
        'UNIVERSAL CHANNEL': 'universalchannel',
        'VIASAT EXPLORER': 'viasatexplorer',
        'VIASAT HISTORY': 'viasathistory',
        'VOX': 'vox',
        'ZONE REALITY': 'zonereality',
        'ZONE ROMANTICA': 'zoneromantica'
        }

re_label = re.compile('^#EXTINF:\s*([0-9]+)\s*,\s*(.*)')
re_tag = re.compile('^<-+ (.+) -+>|^()$')
re_url = re.compile('^udp://@([^:]+):([0-9]+)')

fmt_tag = """{
        "enabled": 1,
        "internal": 0,
        "titledIcon": 0,
        "name": "%s",
        "comment": "",
        "icon": "",
        "id": %d
}
"""
fmt_iptv  = """{
        "interface": "eth0",
        "channelname": "%s",
        "mapped": %s,
        "group": "%s",
        "port": %s,
        "pmt": 0,
        "pcr": 0,
        "disabled": 0
}
"""
fmt_chan = """{
        "name": "%s",
        "channel_number": %d,
        "tags": [
            %d
        ],
        "xmltv-channel": "%s",
        "dvr_extra_time_pre": 0,
        "dvr_extra_time_post": 0
}
"""

def get_label(line):
    m = re_label.match(line)
    if m:
        return m.group(1), m.group(2)
    else:
        return None, None

def get_tag(name):
    m = re_tag.match(name)
    return m and m.group(1) or None

def get_channels(f):
    ''' M3U playlist lexer '''
    tag = ""
    index = None
    name = None
    for line in f:
        if name:
            t = get_tag(name)
            if t != None:
                tag = t
            else:
                yield {
                        'name': name,
                        'url': line,
                        'tags': [tag],
                        'xmltv': xmltv.get(name.upper(), None)
                      }
            name = index = None
        else:
            index, name = get_label(line)

def write_channels(path, channels, tags):
    """
    Write directory structure for tvheadend.
    """
    tag_id = 0
    channel_id = 0

    if not os.path.isdir(path):
        os.makedirs(path)
    for directory in ( "channeltags", "channels", "iptvservices" ):
        d = path + "/" + directory
        if not os.path.isdir(d):
           os.mkdir(d)

    for tag in tags:
        tag_id+=1
        with open( "%s/channeltags/%d" % (path, tag_id), 'w' ) as tag_f:
            tag_f.write( fmt_tag % (tag, tag_id) )
            t = channels[tag_id]
            for ch in t:
                channel_id += 1
                with open( "%s/iptvtransports/iptv_%d" % (path, channel_id), 'w' ) as iptv_f:
                    with open( "%s/channels/%d" % (path, channel_id), 'w' ) as chan_f:
                        iptv_f.write( fmt_iptv % (ch['name'], channel_id, ch['ip'], ch['port']) )
                        chan_f.write( fmt_chan % (ch['name'], channel_id, tag_id, ch['xmltv'] or "") )

    tag_id+=1
    while os.path.exists( "%s/channeltags/%d" % (path, tag_id) ):
        os.unlink( "%s/channeltags/%d" % (path, tag_id) )
        tag_id+=1

    channel_id+=1
    while os.path.exists( "%s/channels/%d" % (path, channel_id) ):
        os.unlink( "%s/channels/%d" % (path, channel_id) )
        if os.path.exists( "%s/iptvtransports/iptv_%d" % (path, channel_id) ):
            os.unlink( "%s/iptvtransports/%d" % (path, channel_id) )
        channel_id+=1

def main():
    if not os.path.isdir(home_path+'/xmltv'):
        sys.stderr.write("Pred spustenim skriptu je vhodne nastavit XMLTV v Tvheadend!\n")
        exit(1)

    with open(playlist, 'r') as in_f:
        tags = []
        chans = {}
        names = {} # pouzita jmena kanalu
        for channel in get_channels(in_f):
            if channel['name'] in names:
                sys.stderr.write(
                        "Kanal s nazvem \"%s\" jiz existuje (predchozi URL je %s). Nepridavam! (KANAL: %s; URL: %s)\n" % 
                        (channel['name'], names[channel['name']], channel['name'], channel['url'])
                        )
            else:
                url = channel.pop('url')
                m = re_url.match(url)
                if m:
                    tag = channel.pop('tags')[0]
                    if tag not in tags:
                        tags.append(tag)
                    tag_id = len(tags)
                    channel['ip'] = m.group(1)
                    channel['port'] = m.group(2)
                    chans.setdefault(tag_id, []).append(channel)
                    names[channel['name']] = url
                else:
                    sys.stderr.write("Nejedna se o multicastovou URL. Preskakuji! (KANAL: %s; URL: %s)\n" % (channel['name'], url))
        #print(chans)
        write_channels(home_path, chans, tags)

if __name__ == '__main__':
    main()

