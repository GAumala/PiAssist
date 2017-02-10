import sys
import paho.mqtt.client as mqtt
import os
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(("google.com", 80))
HOST = s.getsockname()[0]
ARCHIVO = "content_received.txt"
s.close()

try:
    TOPIC = sys.argv[1]

except:
    print("Missing topic.")
    sys.exit()


def on_connect(client, userdata, rc):
    print("Connected with result code "+str(rc))
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(TOPIC)


# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    # print(msg.topic+" "+str(msg.payload))
    # os.system('./tas ' + str(msg.payload))
    archivo = open(ARCHIVO, 'a')
    archivo.write(str(msg.payload))
    archivo.close()


client = mqtt.Client()
os.getcwd()
os.chdir("../pi")  # changing our current working directory.
client.on_connect = on_connect
client.on_message = on_message
client.connect(HOST, 1883, 60)
client.loop_forever()
