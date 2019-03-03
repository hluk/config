#!/usr/bin/env python3
import argparse
import logging
import metallum
import re
import subprocess

logger = logging.getLogger(__name__)


def run(*cmd):
    with subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as p:
        out, err = p.communicate()
        if err:
            logger.warning('Non-empty stderr "%s": %s', ' '.join(cmd), err)
        if p.returncode != 0:
            raise RuntimeError('Non-zero exit code "{}": {}'.format(' '.join(cmd), p.returncode))
        return out.decode('utf-8').strip()


def currently_playing():
    playing = run('quodlibet', '--print-playing')
    match = re.match(r'(.*) - (.*) - ([0-9]+) - .*', playing)
    return match[1], match[2], int(match[3])


def parse_args():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('--artist', help='artist name')
    parser.add_argument('--album', help='album name')
    parser.add_argument('--track', type=int, help='track number')

    return parser.parse_args()


def print_album(album):
    print('- Album: {}'.format(album.title))


def print_track(track):
    print('--- Track: {}. {}'.format(track.number, track.title))
    lyrics = str(track.lyrics)
    if lyrics:
        print(lyrics)


def print_artists(artists):
    for artist in artists:
        print('- Artist: {}'.format(artist.name))
        print('  - Location: {} ({})'.format(artist.country, artist.location))
        print('  - Genres: {}'.format(', '.join(artist.genres)))
        print('  - Themes: {}'.format(', '.join(artist.themes)))


def main():
    args = parse_args()
    artist_name = args.artist
    album_name = args.album
    track_number = args.track

    if not album_name or not artist_name:
        artist_name, album_name, track_number = currently_playing()

    if not album_name or not artist_name:
        raise RuntimeError('Album and artist name are required')

    albums = metallum.album_search(
        album_name,
        band=artist_name,
        strict=False,
        band_strict=False,
    )

    album = albums[0].get()
    print_album(album)
    print_artists(album.bands)
    print()

    if track_number:
        print_track(album.tracks[track_number - 1])
    else:
        for track in album.tracks:
            print_track(track)
            print()
            print()


if __name__ == "__main__":
    main()
