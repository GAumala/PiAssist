CC=gcc
CLIBS=wiringPi
PROGRAMS=main

all: pi.o
	$(CC) main.c pi.o -l wiringPi -g -o main

pi.o: pi.c pi.h
	$(CC) -g -c pi.c -o pi.o -l $(CLIBS) `pkg-config --cflags --libs glib-2.0`

clean:
	@rm -f $(PROGRAMS) *.o
