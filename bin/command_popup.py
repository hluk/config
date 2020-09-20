#!/usr/bin/env python3
"""
Shows simple popup for focusing windows.
"""
import os
import sys

from pathlib import Path

from PySide2.QtCore import (
    QEvent,
    Qt,
    QThread,
    Signal,
)
from PySide2.QtWidgets import (
    QApplication,
    QLabel,
    QStyle,
)

import focus

STYLE_SHEET = """
background-color: black;
color: white;
padding: 1em;
font-size: 14pt;
"""

TEXT = """
Q - Terminal
W - Web Browser
E - IDE
X - EXIT
ESC - Hide
"""

FIFO = f"{Path.home()}/.command_popup"


class Popup(QLabel):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setWindowFlag(Qt.FramelessWindowHint)
        self.setWindowFlag(Qt.WindowStaysOnTopHint)

        self.setStyleSheet(STYLE_SHEET)
        self.setText(TEXT)
        self.adjustSize()

        self.setGeometry(
            QStyle.alignedRect(
                Qt.LeftToRight,
                Qt.AlignCenter,
                self.size(),
                self.screen().availableGeometry()
            )
        )

    def popup(self):
        self.show()
        self.raise_()
        self.activateWindow()
        QApplication.setActiveWindow(self)

    def keyPressEvent(self, ev):
        if ev.modifiers() == Qt.NoModifier:
            if ev.key() == Qt.Key_Q:
                focus.open_terminal(desktop=1)
            elif ev.key() == Qt.Key_W:
                focus.open_web(desktop=1)
            elif ev.key() == Qt.Key_E:
                focus.open_devel(desktop=1)
            elif ev.key() == Qt.Key_X:
                QApplication.exit()

            self.hide()
            return

        return super().keyPressEvent(ev)

    def mousePressEvent(self, ev):
        QApplication.exit()
        return super().mousePressEvent(ev)

    def event(self, ev):
        if ev.type() == QEvent.WindowDeactivate:
            self.hide()

        return super().event(ev)


class PipeReader(QThread):
    line = Signal(str)

    def run(self):
        while True:
            print("Waiting for command...")
            with open(FIFO, "r") as fifo:
                cmd = fifo.readline().strip()
                print(f"Received command: {cmd!r}")
                if cmd == "focus":
                    self.line.emit(cmd)
                elif cmd == "exit":
                    break


def send_command(cmd):
    print(f"Sending command: {cmd}")
    with open(FIFO, "w") as fifo:
        fifo.write(f"{cmd}\n")


def main():
    want_focus = len(sys.argv) == 1
    if want_focus and Path(FIFO).is_fifo():
        send_command("focus")
        sys.exit()

    try:
        os.mkfifo(FIFO)
    except FileExistsError:
        pass

    try:
        app = QApplication(sys.argv)
        app.setApplicationName("command_window")
        app.setQuitOnLastWindowClosed(False)

        popup = Popup()

        pipe = PipeReader()
        pipe.line.connect(popup.popup)
        pipe.start()

        if want_focus:
            popup.popup()

        exit_code = app.exec_()
        send_command("exit")
        pipe.wait()
        sys.exit(exit_code)
    except BaseException:
        os.unlink(FIFO)
        raise


if __name__ == '__main__':
    main()
