CC=gcc
PROGRAMS=tas

all: gpio.o frame_input.o
	$(CC) tas.c gpio.o frame_input.o -l wiringPi -o $(PROGRAMS) 

gpio.o: gpio.c gpio.h frame_input.o
	$(CC) -c gpio.c -std=c99

frame_input.o: frame_input.c frame_input.h
	$(CC) -c frame_input.c -std=c99

clean:
	@rm -f $(PROGRAMS) *.o
