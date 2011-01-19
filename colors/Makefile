all: brightness invert

brightness: brightness.c
	gcc $(CFLAGS) -o brightness -lXxf86vm brightness.c

invert: invert.c
	gcc $(CFLAGS) -o invert -lXxf86vm invert.c

test_brightness: brightness
	./brightness && \
		for x in `seq 1 10`;\
	   	do\
		./brightness -30 && sleep 0.5 || break;\
		done && ./brightness
