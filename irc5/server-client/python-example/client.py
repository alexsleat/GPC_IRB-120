#!/usr/bin/python

import socket
import sys
import time

HOST, PORT = "192.168.125.1", 1025
#data = " ".join(sys.argv[1:])

# Create a socket (SOCK_STREAM means a TCP socket)
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# Connect to server
sock.connect((HOST, PORT))




while True:
	print "Enter a Command and press Enter"
	keyIn = str(raw_input('Cmd: '))
	# and send data
	
	sock.send(keyIn)
	received = sock.recv(1024)
	#print "Iteration ", i, ":"
	print "\tSent: " , keyIn
	print "\tRecieved: ", received		
	
	
	# Receive data from the server and shut down
	#received = sock.recv(1024)
	#print "Iteration ", i, ":"
	#print "\tSent: " , data
	#print "\tRecieved: ", received
	
	if received == "closeClient ":
		print "Shut down requested"
		break		

#finally:
print "Shutting Down"
time.sleep(1)
sock.send("closeSocket")
time.sleep(1)
sock.close()


