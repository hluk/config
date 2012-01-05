#!/usr/bin/env python
import pynotify
import gtk
from os import execvp, system
from datetime import datetime

# timeout in seconds
timeout = 60
cmd = ["sudo", "/sbin/shutdown", "-h", "now"]
#cmd = ["echo", "SHUTDOWN"]
# do not shutdown if these apps are running
apps = ["mplayer", "vlc"]
pidcmd = "pidof -s %s >/dev/null"

def log(msg):
    print( datetime.today().strftime("[%Y-%m-%d %H:%M:%S] ")+msg )

def poweroff():
    log("Vypinam")
    execvp(cmd[0], cmd)

def destroy(n):
    n.close()
    gtk.main_quit()

def timed_out(n):
    n.close()
    gtk.main_quit()
    poweroff()
    return False

def closed(n):
    destroy(n)
    exit(1)

def action(n, answer):
    destroy(n)
    if answer == "vypnout":
        poweroff()
    else:
        log("Nevypinam - preruseno uzivatelem")
        exit(1)

def main():
    for app in apps:
        if system( pidcmd%(app) ) == 0:
            log( "Nevypinam - applikace \"%s\" stale bezi"%(app) )
            exit(1)
    if not pynotify.init("Vypnout?"):
        poweroff();

    n = pynotify.Notification("Vypnuti Systemu", "System bude vypnut za "+str(timeout)+" sekund!", gtk.STOCK_DIALOG_WARNING)
    n.set_urgency(pynotify.URGENCY_CRITICAL)
    n.connect('closed', closed)
    n.add_action('vypnout', 'Vypnout', action)
    n.add_action('nevypinat', 'Nevypinat', action)

    n.show()
    gtk.timeout_add(timeout*1000, timed_out, n)
    gtk.main()

if __name__ == '__main__':
    main()

