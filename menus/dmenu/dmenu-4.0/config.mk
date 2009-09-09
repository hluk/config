# dmenu version
VERSION = 4.0

# Customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# Xinerama, comment if you don't want it
#XINERAMALIBS = -L${X11LIB} -lXinerama
#XINERAMAFLAGS = -DXINERAMA

# includes and libs
INCS = -I. -I/usr/include -I${X11INC} -I/usr/include -I/usr/include/freetype2
LIBS = -L/usr/lib -lc -L${X11LIB} -lX11 ${XINERAMALIBS} -lXft -lX11 -lXrender -lfreetype -lz -lfontconfig -lXrender -lX11

# flags
PERF=-pipe -O3 -march=pentium4 -msse2 -mfpmath=sse -fomit-frame-pointer
CPPFLAGS = -D_BSD_SOURCE -DVERSION=\"${VERSION}\" ${XINERAMAFLAGS} ${PERF}
CFLAGS = -std=c99 ${INCS} ${CPPFLAGS}
LDFLAGS = -s ${LIBS}

# Solaris
#CFLAGS = -fast ${INCS} -DVERSION=\"${VERSION}\"
#LDFLAGS = ${LIBS}

# compiler and linker
CC = cc
