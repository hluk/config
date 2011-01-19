#!/usr/bin/python2
import sys, cgi, pynotify

#data = cgi.escape( sys.stdin.read() )
if len(sys.argv)==1:
	exit(1)

data = sys.argv[1]
if len(data) > 500:
	data = [ data[:400],data[-100:] ]
else:
	data = [data]
#data = map(lambda x: '<tt>'+cgi.escape(x)+'</tt>', data)

pynotify.init( "Notification" )

f = open("/home/lukas/clipboard","w");
f.write(str(data));

n = pynotify.Notification("Clipboard", '\n<span color="#4466aa"><i><b>   -------------------- CUT --------------------   </b></i></span>\n'.join(data), "editpaste")
n.set_urgency(pynotify.URGENCY_NORMAL)
n.set_timeout(2000)

#n.add_action("clicked","Button text", callback_function, None)
n.show()

