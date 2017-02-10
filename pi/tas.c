#include "gpio.h"
#include <stdlib.h>

int main (int argc, char *argv[]) {
	if (argc == 0) {
		fprintf (stderr, 
		"Debes de pasar un numero valido de frames como argumento\n");
      	return 1;
	}

	char *arg1 = argv[1];
	int total_frames = atoi(arg1);
	if (total_frames == 0) {
		fprintf (stderr, 
		"Debes de pasar un numero valido de frames como argumento\nNumero enviado: %s\n", arg1);
      	return 1;
	}

	FrameInput *input_list = (FrameInput *) malloc(
		total_frames * sizeof (FrameInput));
	int frames_read = frame_input_fill_array_from_stdin(input_list);

	if (frames_read != total_frames - 1) {
		fprintf (stderr, 
		"Error al leer frames desde stdin en linea %d\n", frames_read);
      	return 1;
	}

	/*
	FrameInput fi = input_list[total_frames - 1];
	printf("ultimo: %i, %i, %i\n", fi.arrows, fi.punches, fi.kicks);
	fi = input_list[total_frames - 2];
	printf("penultimo: %i, %i, %i\n", fi.arrows, fi.punches, fi.kicks);
	*/
	

	return run_gpio_tas(input_list, total_frames);
}
