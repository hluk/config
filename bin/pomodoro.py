#!/usr/bin/env python3
"""
Simple pomodoro timer to show status in waybar (panel for sway window manager).

Requires inotify_simple Python package.

Example configuration in "~/.config/waybar/config":

    "custom/pomodoro": {
        "on-click": "~/dev/bin/pomodoro.py next",
        "on-click-right": "~/dev/bin/pomodoro.py prev",
        "on-scroll-up": "~/dev/bin/pomodoro.py up",
        "on-scroll-down": "~/dev/bin/pomodoro.py down",
        "exec": "~/dev/bin/pomodoro.py",
        "return-type": "json"
    },
"""
import json
import getpass
import logging
import math
import sys
from time import time

from inotify_simple import INotify, flags


logging.basicConfig(level=logging.DEBUG, format="%(levelname)s: %(message)s")
log = logging.getLogger(__name__)


class Interval:
    def __init__(self, minutes):
        self.minutes = minutes


class Focus(Interval):
    name = "focus"


class Break(Interval):
    name = "🍅 break"


def load_state(state_file):
    try:
        with open(state_file, 'r') as f:
            index, start = f.readline().split(' ')
            return int(index), int(start)
    except (FileNotFoundError, ValueError):
        return 0, 0


def save_state(state_file, index, start):
    with open(state_file, 'w') as f:
        f.write(f"{index} {start}")


FOCUS = Focus(minutes=25)
SHORT = Break(minutes=5)
LONG = Break(minutes=30)
SHORT_COUNT = 4
SCROLL_MINUTES = 2
STATE_FILE = f"/tmp/pomodoro-{getpass.getuser()}"


def update(cmds=[]):
    intervals = [FOCUS, SHORT] * SHORT_COUNT + [FOCUS, LONG]

    index, start = load_state(STATE_FILE)
    index0 = index
    start0 = start

    for cmd in cmds:
        if cmd == "next" or cmd == "prev":
            if start > 0:
                d = 1 if cmd == "next" else -1
                index = (index + d) % len(intervals)
            start = int(time())
        elif cmd == "up" or cmd == "down":
            if start > 0:
                d = 1 if cmd == "up" else -1
                start += d * 60 * SCROLL_MINUTES
        elif cmd == "reset":
            index = 0
            start = 0
        else:
            raise RuntimeError(f"Unknown command: {cmd}")

    interval = intervals[index]
    remaining_seconds = interval.minutes * 60

    if start > 0:
        elapsed = time() - start
        remaining_seconds -= elapsed
        if remaining_seconds <= 0:
            index = (index + 1) % len(intervals)
            start = 0
            interval = intervals[index]
            remaining_seconds = interval.minutes * 60

    remaining_minutes = math.ceil(remaining_seconds / 60)
    paused = start == 0
    symbol = "⏸️ " if paused else ""
    status = "paused" if paused else "running"
    out = {
        "text": f"{symbol}{interval.name} <b>{remaining_minutes}</b>′",
        "tooltip": f"pomodoro {status} {int(index/2) + 1}/{int(len(intervals)/2)}",
        "class": status,
    }

    print(json.dumps(out), flush=True)

    if index0 != index or start0 != start:
        save_state(STATE_FILE, index, start)


def watch(state_file):
    inotify = INotify()
    watch_flags = flags.CREATE | flags.DELETE | flags.MODIFY | flags.DELETE_SELF
    watched = False
    while True:
        if not watched:
            try:
                watch = inotify.add_watch(state_file, watch_flags)
                watched = True
                log.debug('inotify watch: %s', watch)
            except FileNotFoundError:
                save_state(state_file, 0, 0)
            except OSError as e:
                log.warning('failed inotify watch: %s', e)

        timeout_ms = 60 * 1000 if watched else 1000
        for event in inotify.read(timeout=timeout_ms):
            event_flags = flags.from_mask(event.mask)
            log.debug('inotify: %s', event_flags)
            if flags.DELETE_SELF in event_flags:
                watched = False

        update()


def main():
    cmds = sys.argv[1:]
    if cmds:
        update(cmds)
    else:
        update()
        return watch(STATE_FILE)


if __name__ == "__main__":
    main()
