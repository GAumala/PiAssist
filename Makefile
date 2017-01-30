CC=gcc
CLIBS=wiringPi

install:
	$(CC) pi.c -o main  -l $(CLIBS)

