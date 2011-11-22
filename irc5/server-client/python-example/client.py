#!/usr/bin/python

import socket
import sys

HOST, PORT = "192.168.125.1", 1025
data = " ".join(sys.argv[1:])

# Create a socket (SOCK_STREAM means a TCP socket)
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# Connect to server
sock.connect((HOST, PORT))
for i in range(1,5):

	#try:
	    # and send data
	sock.send(data + "\n")

	    # Receive data from the server and shut down
	received = sock.recv(1024)
	print "Iteration ", i, ":"
	print "\tSent: " , data
	print "\tRecieved: ", received

else:
	#finally:
	print "fin"
	sock.close()

