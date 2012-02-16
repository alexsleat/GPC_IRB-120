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

# ##################################################
#
# Publishers for returned data from the IRC5 server:
#
def CRobTPublisher(x,y,z):
	xPub = rospy.Publisher('CRobT_x', Float32)
	yPub = rospy.Publisher('CRobT_y', Float32)
	zPub = rospy.Publisher('CRobT_z', Float32)
	rospy.init_node('rosclient')

	xPub.publish(Float32(x))
	yPub.publish(Float32(y))
	zPub.publish(Float32(z))
	
def ReadMotorPublisher(mot1, mot2, mot3, mot4, mot5, mot6):

	mot1Pub = rospy.Publisher('ReadMotor_mot1', Float32)
	mot2Pub = rospy.Publisher('ReadMotor_mot2', Float32)
	mot3Pub = rospy.Publisher('ReadMotor_mot3', Float32)
	mot4Pub = rospy.Publisher('ReadMotor_mot4', Float32)
	mot5Pub = rospy.Publisher('ReadMotor_mot5', Float32)
	mot6Pub = rospy.Publisher('ReadMotor_mot6', Float32)
	rospy.init_node('rosclient')
	
	mot1Pub.publish(Float32(mot1))
	mot2Pub.publish(Float32(mot2))
	mot3Pub.publish(Float32(mot3))
	mot4Pub.publish(Float32(mot4))
	mot5Pub.publish(Float32(mot5))
	mot6Pub.publish(Float32(mot6))
	

# ##################################################
#
# Send a data packet (split in to 3 and stiched at the other end):
#
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

	# send data (3 packets 
	for i in 3:

		if i >= 1 && send_str[i] == '':
			send_str[i] = '#0'
		sock.send(send_str[i])
		received = sock.recv(1024)
		#print "Iteration ", i, ":"
		print "\tSent: " , data
		print "\tRecieved: ", received	
		if send_str[i] == received:
			print "\t\tData OK!"

	# clear received buffer:	
	received = ''

	# recieve returned packet from data, currently set to get 3 packets, which get stiched together
	#for i in 1:
	received = received + sock.recv(1024)
		
	received.split('#')
	
	# ##################################################
	#
	# Check which function was recieved:
	#
	if received[0] == 'MoveJ_fc':
		# Publish the angles each joint was set to:
		print "\t Robot Joints set: "
		
		# Set move set flag?

	elif received[0] == 'CRobT_fc':
		# Check if the server returned the correct number of variables:
		if len(received) == 4:
			# Publish XYZ coordinates:
			CRobTPublisher(float(received[1]), float(received[2]), float(received[3]))
			print "\t CRobT: x=" + received[1] + ", y=" + received[2] + ", z=" + received[3]

	elif received[0] == 'CPos_fc':
		# 
		print "\t "
	elif received[0] == 'CJointT_fc':
		# 
		print "\t "
	elif received[0] == 'ReadMotor_fc':
		# Check if the server returned the correct number of variables:
		if len(received) == 7:
			# Publish the motor readings:
			ReadMotorPublisher(float(received[1]), float(received[2]), float(received[3]), float(received[4]), float(received[5]), float(received[6]))
			print "\t ReadMotor: 1=" + received[1] + ", 2=" + received[2] + ", 3=" + received[3] + ", 4=" + received[4] + ", 5=" + received[5] + ", 6=" + received[6]
	elif received[0] == 'VelSet':
		# Publish the new velocity setting:
		print "\t "
	elif received[0] == 'AccSet':
		# Publish the new acceleration setting:
		print "\t "
	elif received[0] == 'GripLoad':
		# Publish the grip load reading:
		print "\t "
	else:
		print "ERROR : Returned packet, was wrong, falling out."
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

