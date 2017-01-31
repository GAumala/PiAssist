CC=gcc
CLIBS=wiringPi
PROGRAMS=test

test:
	$(CC) test_pi.c ../pi.o -l wiringPi -l check -o test

clean:
	@rm -f $(PROGRAMS) *.o
