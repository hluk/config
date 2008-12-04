# dmenu version
VERSION = 3.4

# Customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# includes and libs
INCS = -I. -I/usr/include -I${X11INC}
LIBS = -L/usr/lib -lc -L${X11LIB} -lX11

# flags
#CFLAGS = -Os ${INCS} -DVERSION=\"${VERSION}\"
CFLAGS = -O2 -pipe -march=pentium4 -fomit-frame-pointer ${INCS} -DVERSION=\"${VERSION}\"
#LDFLAGS = -s ${LIBS}
LDFLAGS = -s ${LIBS}
#CFLAGS = -g -std=c99 -pedantic -Wall -O2 ${INCS} -DVERSION=\"${VERSION}\"
#LDFLAGS = -g ${LIBS}

# Solaris
#CFLAGS = -fast ${INCS} -DVERSION=\"${VERSION}\"
#LDFLAGS = ${LIBS}
#CFLAGS += -xtarget=ultra

# compiler and linker
CC = cc
