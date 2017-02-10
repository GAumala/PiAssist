import sys
import paho.mqtt.client as mqtt
import os
import socket
from subprocess import Popen, PIPE, STDOUT

HOST = "192.168.0.5"
TOPIC = "tas"

try:
    SCRIPT = sys.argv[1]
except:
    print("Missing bash script to execute.")
    sys.exit()


def on_connect(client, userdata, rc):
    print("Connected with result code "+str(rc))
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(TOPIC)


# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    lines = len(msg.payload.splitlines())
    p = Popen([SCRIPT, str(lines)], stdout=PIPE, stdin=PIPE, stderr=STDOUT)
    grep_stdout = p.communicate(input=msg.payload)[0]
    print(grep_stdout.decode())


client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect(HOST, 1883, 60)
client.loop_forever()
