#!/usr/bin/env python3
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
    name = "break"


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
STATE_FILE = f"/tmp/pomodoro-{getpass.getuser()}"


def main():
    intervals = [WORK, SHORT] * SHORT_COUNT + [WORK, LONG]

    index, start = load_state(STATE_FILE)
    index0 = index
    start0 = start

    for cmd in sys.argv[1:]:
        if cmd == "next" or cmd == "prev":
            if start == 0:
                start = int(time())
            else:
                d = 1 if cmd == "next" else -1
                index = (index + d) % len(intervals)
                start = 0
        elif cmd == "up" or cmd == "down":
            if start > 0:
                start += 60 if cmd == "up" else -60

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

    def info():
        return (
            f"{interval.name}"
            f" {math.ceil(remaining_seconds / 60)}min"
            f" ({index + 1}/{len(intervals)})"
        )

    if start == 0:
        print(f"[START?] {info()}")
    else:
        print(info())

    if index0 != index or start0 != start:
        save_state(STATE_FILE, index, start)


if __name__ == "__main__":
    main()
