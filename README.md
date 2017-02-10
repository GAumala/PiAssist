# PiAssist

[![Build
Status](https://travis-ci.org/GAumala/PiAssist.svg?branch=master)](https://travis-ci.org/GAumala/PiAssist)

## How to build the script compiler

Make sure you have installed
[Stack](https://docs.haskellstack.org/en/stable/README/) in your system.

```
cd input-script-parser
stack setup
stack build
```
Now you can compile any script to stdout with:

```
stack exec input-script-parser-exe my-script.txt
```

## How to launch the C program.

1. install the library wiringPi. If you use an Arch-Based Linux Distribution you can install it from the AUR with the package `wiringpi-git`
2. Execute `make` in the project directory, then execute `./main`.


## How to launch the subscriber

1. install the package  `mosquitto`. Verify that the server is successfully running using `systemctl status mosquitto` 
2. Install the `paho-mosquitto` library using pip.
3. When you run the script `receiver.py` don't forget to put the first argument that represents the topic you subscribe to.

## Contributors

* Sebastian Caceres
* Gabriel Aumala

