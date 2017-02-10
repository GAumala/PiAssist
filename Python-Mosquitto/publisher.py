import sys
import paho.mqtt.client as mqtt
import os
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(("google.com", 80))
HOST = s.getsockname()[0]
ARCHIVO = "content_to_send.txt"
s.close()

try:
    TOPIC = str(sys.argv[1])

except:
    print("Missing topic.")
    sys.exit()

client = mqtt.Client()
os.chdir("../pi")  # changing our current working directory.
client.connect(HOST, 1883, 60)
archivo = open(ARCHIVO, 'r')
content = archivo.read()
archivo.close()
client.publish(TOPIC, content, 0, False)

print("Published new content in channel " + TOPIC)
