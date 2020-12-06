#!/usr/bin/env python3
"""
Simple pomodoro timer to show status in waybar (panel for sway window manager).

Example configuration in "~/.config/waybar/config":

    "custom/pomodoro": {
        "interval": 60,
        "on-click": "~/dev/bin/pomodoro.py next",
        "on-click-right": "~/dev/bin/pomodoro.py prev",
        "on-scroll-up": "~/dev/bin/pomodoro.py up",
        "on-scroll-down": "~/dev/bin/pomodoro.py down",
        "exec": "sh -c ~/dev/bin/pomodoro.py",
        "return-type": "json"
    },

Using "sh -c" in the above fixes issues with updating the status.
"""
import json
import getpass
import math
import sys
from time import time


class Interval:
    def __init__(self, minutes):
        self.minutes = minutes


class Work(Interval):
    name = "work"


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


WORK = Work(minutes=25)
SHORT = Break(minutes=5)
LONG = Break(minutes=30)
SHORT_COUNT = 4
SCROLL_MINUTES = 2
STATE_FILE = f"/tmp/pomodoro-{getpass.getuser()}"


def main():
    intervals = [WORK, SHORT] * SHORT_COUNT + [WORK, LONG]

    index, start = load_state(STATE_FILE)
    index0 = index
    start0 = start

    for cmd in sys.argv[1:]:
        if cmd == "next" or cmd == "prev":
            if start > 0:
                d = 1 if cmd == "next" else -1
                index = (index + d) % len(intervals)
            start = int(time())
        elif cmd == "up" or cmd == "down":
            if start > 0:
                d = 1 if cmd == "up" else -1
                start += d * 60 * SCROLL_MINUTES

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

    print(json.dumps(out))

    if index0 != index or start0 != start:
        save_state(STATE_FILE, index, start)


if __name__ == "__main__":
    main()
