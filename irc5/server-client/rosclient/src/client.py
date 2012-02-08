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


	count = 0;
	string1 = string2 = string3 = ''

	for i in data:
		count = count + 1
		if count <= 70: 
			string1 = string1 + i
		elif count <= 140:
			string2 = string2 + i
		else:
			string3 = string3 + i

	print "String 1: " + string1
	print "String 2: " + string2
	print "String 3: " + string3

	send_str = [string1, string2, string3]

	#send data	

	for i in 3:

		sock.send(send_str[:i])
		received = sock.recv(1024)
		#print "Iteration ", i, ":"
		print "\tSent: " , data
		print "\tRecieved: ", received	
		if send_str[:1] == received:
			print "\t\tData OK!"

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

