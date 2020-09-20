#!/usr/bin/env python3
# Helper script for activating windows and desktop/workspace.
# focus [1-9]  activates given desktop
# focus terminal|web|work  activates window or launches application
import logging
import os
import subprocess
import sys
import time

logger = logging.getLogger(__name__)

TERMINAL_WINDOW_CLASS = 'xfce4-terminal|Gnome-terminal|konsole|st-256color|kitty'


def execute(cmd):
    logger.info('Executing: %s', cmd)
    args = [os.path.expanduser(cmd)]
    os.execv(args[0], args)


def run(*cmd):
    logger.info('Executing: %s', ' '.join(cmd))
    with subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as p:
        out, err = p.communicate()
        if err:
            logger.warning('Non-empty stderr "%s": %s', ' '.join(cmd), err)
        if p.returncode != 0:
            raise RuntimeError('Non-zero exit code "{}": {}'.format(' '.join(cmd), p.returncode))
        return out.decode('utf-8').strip()


def set_desktop(desktop):
    return run('xdotool', 'set_desktop', str(desktop - 1))


def get_desktop():
    return int(run('xdotool', 'get_desktop')) + 1


def get_current_window():
    try:
        return run('xdotool', 'getactivewindow')
    except RuntimeError:
        return 'NONE'


def activate_window(window_id):
    run('xdotool', 'windowactivate', str(window_id))


def find_window(desktop, class_name, *args):
    try:
        out = run('xdotool', 'search', '--desktop', str(desktop - 1), '--class', class_name, *args)
        return out.split('\n')
    except RuntimeError:
        return []


def wait_for_desktop_activated(desktop):
    current_desktop = get_desktop()
    # Return immediately if different desktop is active
    # (can be active on different screen).
    if current_desktop != desktop:
        return

    matching_windows = find_window(desktop, '.*')
    current_window = get_current_window()
    tries = 5
    while current_window not in matching_windows:
        tries -= 1
        if tries <= 0:
            raise RuntimeError('Failed to activate desktop')
        time.sleep(0.01)
        current_window = get_current_window()


def focus(desktop, class_name=None, retry=2):
    previous_desktop = get_desktop()
    if previous_desktop != desktop:
        set_desktop(desktop)
        wait_for_desktop_activated(desktop)

    matching_windows = find_window(desktop, class_name)
    if not matching_windows:
        retry -= 1
        if retry <= 0:
            return False

        return focus(desktop, class_name, retry)

    current_window = get_current_window()

    if previous_desktop == desktop:
        if current_window in matching_windows:
            # If matching window is already active, activate next matching.
            matching_windows.remove(current_window)
            if matching_windows:
                activate_window(matching_windows[0])
        else:
            # If matching window is not already active,
            # reactivate last active matching window.
            activate_window(matching_windows[-1])
    else:
        # Skip focusing next matching window if matching was just focused by
        # switching desktops.
        if current_window not in matching_windows:
            activate_window(matching_windows[0])

    return True


def focus_or_execute(desktop, class_name, cmd):
    focus(desktop, class_name) or execute(cmd)


def open_terminal(desktop):
    focus_or_execute(desktop or 1, TERMINAL_WINDOW_CLASS, '~/dev/bin/console.sh')


def open_web(desktop):
    focus_or_execute(desktop or 2, 'firefox', '~/dev/bin/browser.sh')


def open_work(desktop):
    focus(desktop or 3, 'firefox')


def open_devel(desktop):
    focus(desktop or 4, 'code|qtcreator')


def open_music(desktop):
    # focus_or_execute(4, 'deadbeef', '/usr/bin/deadbeef')
    focus_or_execute(desktop or 5, 'Quod Libet', '/usr/bin/quodlibet')


def open_previous():
    run('xdotool', 'key', '--clearmodifiers', 'Alt+Tab')


def main():
    arg = sys.argv[1]
    desktop = int(sys.argv[2]) if len(sys.argv) > 2 else 0

    log_format = '%(levelname)s: %(message)s'
    log_level = logging.DEBUG
    logging.basicConfig(level=log_level, format=log_format)

    if arg == 'terminal':
        open_terminal(desktop)
    elif arg == 'web':
        open_web(desktop)
    elif arg == 'work':
        open_work(desktop)
    elif arg == 'devel':
        open_devel(desktop)
    elif arg == 'music':
        open_music(desktop)
    elif arg == 'previous':
        open_previous()
    else:
        desktop = int(arg)
        focus(desktop, '.*')


if __name__ == "__main__":
    main()
