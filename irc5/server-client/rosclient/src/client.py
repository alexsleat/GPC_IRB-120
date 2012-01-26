#!/usr/bin/env python

import roslib; roslib.load_manifest('rosclient')
import rospy

import socket
import sys
import time

# subscribe
from std_msgs.msg import String
def callback(data):
	#rospy.loginfo("server_spammer: %s",data.data)
	#if send_flag is set, send the data
	sendData(data.data)

def listener():
	rospy.init_node('listener', anonymous=True)
	rospy.Subscriber("server_spammer", String, callback)
	rospy.spin()

def sendData(sendPacket):
		
	# send data
	print "send packet"
	sock.send(sendPacket)
	# Receive data from the server
	print "receive packet"
	received = sock.recv(1024)
	#check received data against the sent stuff.
	if sendPacket == received:
		print "\tData OK!"	

if __name__ == '__main__':

# Set up sockets
	print "starting socket"
	HOST, PORT = "localhost", 1025
	#data = ",".join(sys.argv[1:])
	# Create a socket (SOCK_STREAM means a TCP socket)
	sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	# Connect to server
	sock.connect((HOST, PORT))

# will end up in the callback loop, so stuff happens there
	listener()

#Close down (ctrl+c should do this!)
	print "sleepytime"
	time.sleep(0.1)
	print "fin"
	sock.send("closeSocket")
	time.sleep(0.1)
	sock.close()

