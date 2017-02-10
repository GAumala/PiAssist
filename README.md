# PiAssist

[![Build
Status](https://travis-ci.org/GAumala/PiAssist.svg?branch=master)](https://travis-ci.org/GAumala/PiAssist)

## How to build the script compiler (tasc)

Make sure you have installed
[Stack](https://docs.haskellstack.org/en/stable/README/) in your system.

```
cd input-script-parser
stack setup
stack build
```
Now you can compile any script to stdout with:

```
stack exec tasc my-script.txt
```

You can try compiling the files in `input-script-parser/script_examples`. The
results should be identical to the files in `pi/combo_examples`

## How to launch the C program.

The C program for controlling GPIO pins, can only be run in a Raspberry Pi, you
can find it in `pi/`

1. install the library wiringPi. If you use an Arch-Based Linux Distribution you 
   can install it from the AUR with the package `wiringpi-git`
2. Build with `make`
3. The executable file is `tas`. it must recieve one argument: the number of
   inputs to process. You can get this number with GNU coreutils' `wc`. You must
   also pass the compiled via STDIN. if you compiled your script into a
   `compiled_output.txt` file, you can run it with:

   ```bash
   cat compiled_output.txt | sudo ./tas $(wc -l compiled_output.txt) 
   ```
   In fact, the script `pi/execute_combo.sh` already does something like this.


## How to launch the subscriber

1. install the package  `mosquitto`. Verify that the server is successfully running using `systemctl status mosquitto` 
2. Install the `paho-mosquitto` library using pip.
3. When you run the script `receiver.py` don't forget to put the first argument that represents the topic you subscribe to.

## Contributors

* Sebastian Caceres
* Gabriel Aumala

