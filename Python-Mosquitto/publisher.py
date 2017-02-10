import sys
import paho.mqtt.client as mqtt
import os
import socket
import fileinput

TOPIC = "tas"
HOST = "192.168.0.7"

# get data from STDIN
content = ""
for line in fileinput.input():
    content += line

# publish
client = mqtt.Client()
client.connect(HOST, 1883, 60)
client.publish(TOPIC, content, 0, False)

print("Published new content in channel " + TOPIC + " from host " + HOST)
