#!/usr/bin/python
import gtk
from sys import argv
from os import fork,execv

def run(cmd,args):
	pid = fork()
	if pid == 0:
		execv(cmd,[cmd]+args)

def toggleHidden(e = None):
	global hidden, cmd

	#if hidden:
		#run(cmd, ["show"])
	#else:
		#run(cmd, ["hide"])
	run(cmd, ["toggle"])

	#hidden = not hidden

def exitCommand(a,b,c):
	run(cmd, ["exit"])
	exit()

if __name__ == "__main__":
	if len(argv) != 3:
		print "Usage: %s icon_path command" % argv[0]
		exit(2)

	global cmd, hidden
	cmd = argv[2]
	#hidden = True

	gtk.StatusIcon
	icon = gtk.status_icon_new_from_file(argv[1])
	icon.connect("activate",toggleHidden)
	icon.connect("popup-menu",exitCommand)

	gtk.main()

