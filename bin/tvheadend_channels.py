#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
File: tvchannels.py
Author: Lukas Holecek (hluk@email.cz)
Description:
    Parse M3U playlist and create tvheadend channels.
'''

import sys
import os
import re

playlist = "/home/hts/netbox.m3u8"
home_path = "/home/hts/.hts/tvheadend/"

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
        'ČT24': 'ct24',
        'ČT 4 SPORT': 'ct4',
        'DISCOVERY HD': 'Discovery HD' ,
        'DISCOVERY': 'discovery',
        'DISCOVERY WORLD': 'discoveryworld',
        'DISCOVERY SCIENCE': 'discoveryscience',
        'DISCOVERY ID INVESTIGATION': 'discoveryinvestigation',
        'Disney Channel': 'disneychannel',
        'STV2': 'disneychannel',
        'STV1': 'dvojka',
        'ESPN CLASSIC': 'jednotka',
        'Eurosport': 'eurosport1',
        'Eurosport 2': 'eurosport2',
        'EUROSPORT HD': 'eurosport1',
        'X EXTREME SPORT': 'extremesports',
        'FILMBOX': 'filmbox',
        'FILMBOX EXTRA': 'filmboxextra',
        'Film +': 'filmplus',
        'HBO': 'hbo',
        'HBO HD': 'hbo',
        'HBO 2': 'hbo2',
        'HBO COMEDY': 'hbocomedy',
        'JIM JAM': 'jimjam',
        'JOJ': 'joj',
        'JOJ Plus': 'jojplus',
        'Markíza': 'markiza',
        'MGM': 'mgm',
        'MINIMAX/ANIMAX': 'minimax',
        'MTV': 'mtv',
        'NATIONAL GEOGRAPHIC': 'nationalgeographic',
        'NATIONAL GEOGRAPHIC WILD': 'nationalgeographicwild',
        'Nova': 'nova',
        'Nova HD': 'nova',
        'Nova Cinema': 'novacinema',
        'Nova Sport': 'novasport',
        'Nova Sport HD': 'novasport',
        'ÓČKO': 'ocko',
        'ORF Eins': 'orf1',
        'ORF 2': 'orf2',
        'Prima': 'prima',
        'Prima HD': 'prima',
        'Prima Cool': 'primacool',
        'Prima Love': 'primalove',
        'PRO 7': 'pro7',
        'RTL': 'rtl',
        'SAT 1': 'sat1',
        'SPECTRUM': 'spektrum',
        'SPORT 1': 'sport1',
        'SPORT 5': 'sport5',
        'TA3': 'ta3',
        'FISHING & HUNTING': 'thefishingandhunting',
        'History Channel': 'thehistorychannel',
        'HISTORY': 'thehistorychannel',
        'HISTORY HD': 'thehistorychannelhd',
        'TRAVEL': 'travelchannelhd',
        'TRAVEL & LIVING': 'travelchannelhd',
        'TV Barrandov': 'tvbarrandov',
        'NOE': 'tvnoe',
        'PAPRIKA': 'tvpaprika',
        'Universal Channel': 'universalchannel',
        'VIASAT EXPLORER': 'viasatexplorer',
        'VIASAT HISTORY': 'viasathistory',
        'VOX': 'vox',
        'Zone Reality': 'zonereality',
        'ZONE ROMANTICA': 'zoneromantica'
        }

re_label = re.compile('^#EXTINF:\s*([0-9]+)\s*,\s*(.*)')
re_group = re.compile('^<-+ (.+) -+>|^()$')
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

def get_group(name):
    m = re_group.match(name)
    return m and m.group(1) or None

def get_channels(f):
    ''' M3U playlist lexer '''
    tag = ""
    index = None
    name = None
    for line in f:
        if name:
            t = get_group(name)
            if t != None:
                tag = t
            else:
                yield {
                        'name': name,
                        'url': line,
                        'tags': [tag],
                        'xmltv': xmltv.get(name, None)
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

    #os.makedirs(path)
    #for directory in ( "channeltags", "channels", "iptvservices" ):
    #    os.mkdir(path + "/" + directory)

    for tag in tags:
        tag_id+=1
        with open( "%s/channeltags/%d" % (path, tag_id), 'w' ) as group_f:
            group_f.write( fmt_tag % (tag, tag_id) )
            t = channels[tag_id]
            for ch in t:
                channel_id += 1
                with open( "%s/iptvtransports/iptv_%d" % (path, channel_id), 'w' ) as iptv_f:
                    with open( "%s/channels/%d" % (path, channel_id), 'w' ) as chan_f:
                        iptv_f.write( fmt_iptv % (ch['name'], channel_id, ch['ip'], ch['port']) )
                        chan_f.write( fmt_chan % (ch['name'], channel_id, tag_id, ch['xmltv'] or "") )

def main():
    with open(playlist, 'r') as in_f:
        tags = []
        chans = {}
        for channel in get_channels(in_f):
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
        #print(chans)
        write_channels(home_path, chans, tags)

if __name__ == '__main__':
    main()

