#ifndef _GPIO_H_
#define _GPIO_H_

#include <wiringPi.h>
#include <errno.h>
#include <string.h>
#include "frame_input.h"

#define LEFT_PIN  2
#define RIGHT_PIN 3
#define DOWN_PIN  4
#define UP_PIN    14
#define LP_PIN    15
#define MP_PIN    17
#define HP_PIN    18
#define LK_PIN    27
#define MK_PIN    22
#define HK_PIN    23
#define CLOCK_PIN 24

int run_gpio_tas(FrameInput *list, int count);

#endif
