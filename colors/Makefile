all: brightness

brightness: brightness.c
	gcc $(CFLAGS) -o brightness -lXxf86vm brightness.c

test_brightness: brightness
	./brightness && \
		for x in `seq 1 10`;\
	   	do\
		./brightness -30 && sleep 0.5 || break;\
		done && ./brightness
