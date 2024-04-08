#!/usr/bin/env python3
"""
Simple GUI application that runs a command when a shortcut is typed.
"""
import os
import socket
from tkinter import StringVar, Tk, ttk
from threading import Thread

SERVER = ("localhost", 8889)
TITLE = "Shortcut Center"
WINDOW_CLASS_NAME = "Shortcut_center"
WIDTH = 180
HEIGHT = 320

COMMAND_FORMAT = "{} & disown"
DEFAULT_ACTION = 'swaymsg "workspace back_and_forth"'
MAPPING = {
    "p": "~/bin/toggleplay.sh",
    "t": "~/bin/tidal.sh",
    "e": "dolphin",
    "Q": ":quit",
    "a": 'swaymsg "workspace 1"',
    "s": 'swaymsg "workspace 2"',
    "d": 'swaymsg "workspace 3"',
    "f": 'swaymsg "workspace 4"',
    "g": 'swaymsg "workspace 4"',
    "1": 'swaymsg "workspace 1"',
    "2": 'swaymsg "workspace 2"',
    "3": 'swaymsg "workspace 3"',
    "4": 'swaymsg "workspace 4"',
    "5": 'swaymsg "workspace 5"',
    "6": 'swaymsg "workspace 6"',
    "7": 'swaymsg "workspace 7"',
    "8": 'swaymsg "workspace 8"',
    "9": 'swaymsg "workspace 9"',
    "0": 'swaymsg "workspace 10"',
}


class App:
    def __init__(self):
        self.root = Tk(className=WINDOW_CLASS_NAME)
        self.root.title(TITLE)
        self.root.minsize(width=WIDTH, height=HEIGHT)
        self.root.maxsize(width=WIDTH, height=HEIGHT)
        self.root.bind("<FocusOut>", lambda _: self.close())
        self.root.bind("<Escape>", lambda _: self.close())
        self.root.bind("<<ToggleFocus>>", lambda _: self.toggle_focus())

        mainframe = ttk.Frame(self.root)
        mainframe.grid()

        self.shortcut = StringVar()
        self.shortcut.trace_add("write", lambda *_: self.trigger(self.shortcut.get()))
        entry = ttk.Entry(mainframe, textvariable=self.shortcut)
        entry.grid(column=0, row=0, sticky="w")
        entry.focus()

        help = "\n".join(f"{k}: {v}" for k, v in MAPPING.items())
        ttk.Label(mainframe, text=help).grid(column=0, row=1, sticky="w")

    def mainloop(self):
        self.root.mainloop()

    def run(self, command):
        if command == ":quit":
            self.root.quit()
            return

        os.system(COMMAND_FORMAT.format(command))
        self.close()

    def trigger(self, value):
        map = MAPPING.get(value)
        if map:
            self.run(map)

    def quit(self):
        self.root.quit()

    def close(self):
        self.root.withdraw()
        self.shortcut.set("")

    def open(self):
        self.root.deiconify()

    def has_focus(self):
        return self.root.focus_get() is not None

    def send_toggle_focus(self):
        self.root.event_generate("<<ToggleFocus>>")

    def toggle_focus(self):
        if self.has_focus():
            self.run(DEFAULT_ACTION)
        else:
            self.open()


def run_server(callback):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.bind(SERVER)
    sock.listen(1)

    try:
        while True:
            client, _ = sock.accept()
            data = client.recv(1)
            client.close()
            if data:
                break
            callback()
    finally:
        sock.close()

def send(data):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        sock.connect(SERVER)
        sock.send(data)
        return True
    except ConnectionRefusedError:
        return False


def main():
    if send(b""):
        return

    app = App()
    Thread(target=run_server, args=(app.send_toggle_focus,)).start()
    app.mainloop()
    send(b"0")


if __name__ == "__main__":
    main()
