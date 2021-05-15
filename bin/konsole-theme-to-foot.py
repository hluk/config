#!/usr/bin/env python3
"""
Converts Konsole terminal theme (usually installed in ~/.local/share/konsole)
to Foot terminal ("[colors]" section in ~/.config/foot/foot.ini).
"""

import configparser
import sys

COLOR_MAP = (
    ('Background', 'background'),
    ('Foreground', 'foreground'),
    ('Color0', 'regular0'),
    ('Color1', 'regular1'),
    ('Color2', 'regular2'),
    ('Color3', 'regular3'),
    ('Color4', 'regular4'),
    ('Color5', 'regular5'),
    ('Color6', 'regular6'),
    ('Color7', 'regular7'),
    ('Color0Intense', 'bright0'),
    ('Color1Intense', 'bright1'),
    ('Color2Intense', 'bright2'),
    ('Color3Intense', 'bright3'),
    ('Color4Intense', 'bright4'),
    ('Color5Intense', 'bright5'),
    ('Color6Intense', 'bright6'),
    ('Color7Intense', 'bright7'),
)


def convert_color_to_foot(konsole_color):
    return ''.join(
        f'{int(x):02x}'
        for x in konsole_color.split(',')
    )


konsole_theme_file = sys.argv[1]
config = configparser.ConfigParser()
config.read(konsole_theme_file)
print('[colors]')
for konsole_color_key, foot_color_key in COLOR_MAP:
    konsole_color = config[konsole_color_key]['Color']
    foot_color = convert_color_to_foot(konsole_color)
    print(f'{foot_color_key}={foot_color}')
