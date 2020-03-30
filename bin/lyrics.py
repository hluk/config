#!/usr/bin/env python3
import argparse
import logging
import os
import subprocess

from metallum import album_search

logger = logging.getLogger(__name__)

DEFAULT_CONFIG_FILE_PATH = os.path.expanduser('~/.config/lastfm_wallpaper.ini')


def run(*cmd):
    with subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as p:
        out, err = p.communicate()
        if err:
            logger.warning('Non-empty stderr "%s": %s', ' '.join(cmd), err)
        if p.returncode != 0:
            raise RuntimeError('Non-zero exit code "{}": {}'.format(' '.join(cmd), p.returncode))
        return out.decode('utf-8').strip()


def currently_playing():
    import configparser
    import pylast

    config = configparser.ConfigParser()
    config.read(DEFAULT_CONFIG_FILE_PATH)
    config = config["default"]

    network = pylast.LastFMNetwork(
        api_key=config["api_key"],
        api_secret=config["api_secret"],
        username=config["user"]
    )

    user = network.get_user(config["user"])
    track = user.get_now_playing()
    artist = track.get_artist()
    album = track.get_album()
    album_tracks = album.get_tracks()
    track_number = album_tracks.index(track) + 1

    return artist.get_name(), album.get_title(), track_number


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

    albums = album_search(
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
