MAGICK_HOME=/usr/local
WANDCONFIG=Wand-config
VER=`uname -s`-magick_`${WANDCONFIG} --version`
INSTALLPATH=../../../${VER}

all: lcdresample

clean:
	rm -rf *.o *.core lcdresample

test: source.png lcdresample
	rm -f target.png
	./lcdresample source.png target.png

lcdresample.o: lcdresample.c
	gcc -g -I/usr/local/include -c `${WANDCONFIG} --cppflags --cflags` lcdresample.c

lcdresample: lcdresample.o
	gcc -g -L/usr/local/lib -o lcdresample `${WANDCONFIG} --ldflags --libs` lcdresample.o

install: lcdresample
	mkdir -p ../../../${VER}
	cp lcdresample ${INSTALLPATH}
