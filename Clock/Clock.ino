#include <TimerOne.h>

//duration of a clock tick in microseconds
const unsigned long frame_duration = 16667;
//PWM pin
const unsigned short pwm_pin = 11;
//clock output
int clock_pin = 7;

void setup() { 
    pinMode(clock_pin, OUTPUT);  // use on-board LED
    initTimer();
} 
    
void loop() { }

/** TIMER FUNCTIONS
start the timer interrupting every tick to update the clock signal
*/
void initTimer(){
    Timer1.initialize(frame_duration);         // initialize timer1, and set a 1/2 second period
    Timer1.pwm(pwm_pin, 512);                // setup pwm on pin 9, 50% duty cycle
    Timer1.attachInterrupt(callback);  // attaches callback() as a timer overflow interrupt
    }

void callback()
{
    digitalWrite(clock_pin, !digitalRead(clock_pin));  // toggle state
} 
