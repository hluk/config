all: brightness invert

brightness: brightness.c
	gcc $(CFLAGS) -o brightness -lXxf86vm -lX11 brightness.c

invert: invert.c
	gcc $(CFLAGS) -o invert -lXxf86vm -lX11 invert.c

test_brightness: brightness
	./brightness && \
		for x in `seq 1 10`;\
	   	do\
		./brightness -30 && sleep 0.5 || break;\
		done && ./brightness
