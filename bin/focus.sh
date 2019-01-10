#!/bin/bash
# Helper script for activating windows and desktop/workspace.
# focus [1-9]  activates given desktop
# focus terminal|web|work  activates window or launches application
set -ex

set_desktop() {
    desktop=$1 && shift
    xdotool set_desktop "$((desktop - 1))"
}

get_desktop() {
    echo $(($(xdotool get_desktop) + 1))
}

wait_for_desktop_activated() {
    matching_windows=$(find_window "$desktop" ".*")
    current_window=$(xdotool getactivewindow)
    tries=5
    while ! [[ -n "$current_window" && "$matching_windows" =~ $current_window ]]; do
        sleep 0.01
        [[ $((--tries)) -gt 0 ]] || exit 1
        current_window=$(xdotool getactivewindow)
    done
}

find_window() {
    desktop=$1 && shift
    xdotool search --desktop "$((desktop - 1))" --class "$@"
}

activate_window() {
    xdotool windowactivate "$1"
}

focus() {
    desktop=$1 && shift
    class_name=$1 && shift

    previous_desktop=$(get_desktop)
    if [[ "$previous_desktop" != "$desktop" ]]; then
        set_desktop "$desktop"
        wait_for_desktop_activated
    fi

    matching_windows=$(find_window "$desktop" "$class_name")
    current_window=$(xdotool getactivewindow)

    if [[ "$previous_desktop" == "$desktop" ]]; then
        if [[ "$matching_windows" =~ $current_window ]]; then
            # If matching window is already active, activate next matching.
            activate_window "$(head -1 <<< "$matching_windows")"
        else
            # If matching window is not already active,
            # reactivate last active matching window.
            activate_window "$(tail -1 <<< "$matching_windows")"
        fi
    else
        # Skip focusing next matching window if matching was just focused by
        # switching desktops.
        if ! [[ "$matching_windows" =~ $current_window ]]; then
            activate_window "$(head -1 <<< "$matching_windows")"
        fi
    fi
}

case "$1" in
    "terminal")
        focus 1 "Gnome-terminal" || ~/dev/bin/console.sh
        ;;
    "web")
        focus 1 "firefox" || ~/dev/bin/browser.sh
        ;;
    "work")
        focus 2 "firefox"
        ;;
    [1-9])
        set_desktop "$1"
        ;;
    *)
        echo "Unknown argument: $1"
        exit 1
    ;;
esac
