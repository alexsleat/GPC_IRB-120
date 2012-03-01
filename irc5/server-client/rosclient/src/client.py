#!/usr/bin/env python

import roslib; roslib.load_manifest('rosclient')
import rospy

import socket
import sys
import time

# std_msgs
from std_msgs.msg import String
from std_msgs.msg import Float32
from std_msgs.msg import Float32MultiArray
from std_msgs.msg import Int32

def callback(data):
	#rospy.loginfo("server_spammer: %s",data.data)
	#if sendflag is set, send the data
	sendflag = 1
	sendData("hi", sendflag)
	recvData()
# ##################################################
#
# If a new XYZ is published, this callback will happen and send the pose to the server
#
def setXYZ(data):
	#subscribe to XYZ
	print "\n\n\n\n raw:"
	print data.data
	print "\n"
	#convert XYZ double array to string
	tempStr = ''
	tempStr = repr(data.data).replace('array','')
	
	print "\n str:"
	print tempStr
	print "\n"
	
	tempStr = tempStr.replace(' ','')
	tempStr = tempStr.replace('(', '')
	tempStr = tempStr.replace(')','')
	tempStr = "setXYZ#" + tempStr + "#0"

	print type(tempStr)
	print "\n to send:"
	print tempStr
	print "\n\n\n\n"	
	
	#send string with setXYZ to server.
	sock.send(tempStr)
	#Clear string
	tempStr = ''
# ##################################################
#
# If a new rotation matrix is published, this callback will send the data to the server
#	
def setROT(data):
	#subscribe to ROT
	tempStr = data.data
	#convert ROT double array to 3 strings:
	#Remove the gumf from python strings
	tempStr1 = repr(tempStr[0:4]).replace('array','')
	tempStr1 = tempStr1.replace(' ','')
	tempStr1 = tempStr1.replace('(', '')
	tempStr1 = tempStr1.replace(')','')

	tempStr2 = repr(tempStr[4:8]).replace('array','')
	tempStr2 = tempStr2.replace(' ','')
	tempStr2 = tempStr2.replace('(', '')
	tempStr2 = tempStr2.replace(')','')
	
	tempStr3 = repr(tempStr[8:14]).replace('array','')
	tempStr3 = tempStr3.replace(' ','')
	tempStr3 = tempStr3.replace('(', '')
	tempStr3 = tempStr3.replace(')','')	
	
	tempStr1 = "setROT1#" + tempStr1 + "#0"	
	tempStr2 = "setROT2#" + tempStr2 + "#0"
	tempStr3 = "setROT3#" + tempStr3 + "#0"
	
	#send each string of ROT to server:
	sock.send(tempStr1)
	sock.send(tempStr2)
	sock.send(tempStr3)
	#Clear strings
	tempStr = ''
	tempStr1 = ''
	tempStr2 = ''
	tempStr3 = ''
# ##################################################
#
# If armMoveFlag is set, a move command will be sent to the server.
#
def moveArm(data):
	#subscribe to armMoveFlag, if 1 send the move command:
	if(data.data == 1):
		sock.send("MoveJ_fc#0")
		#publish armMoveFlag to 0 (to say it's moved.)

def listener():
	
	rospy.init_node('listener', anonymous=True)
	rospy.Subscriber("server_spammer", String, callback)
	rospy.Subscriber("armXYZArr", 	Float32MultiArray, setXYZ)
	rospy.Subscriber("armRotArr",	Float32MultiArray, setROT)
	rospy.Subscriber("armMoveFlag", Int32, moveArm)
	rospy.spin()


# ##################################################
#
# Send a data packet
#
def sendData(sendPacket, sendflag):

	if sendflag == 1:
		sock.send(sendPacket)
		print "\tSent: ", sendPacket
		sendflag = 0
	
# ##################################################
#
# Get a data packet
#
def recvData():

	received = sock.recv(1024)
	print "\tRecieved: ", received

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
	print "Shutting Down.."
	time.sleep(1)
	sock.send("closeSocket")
	time.sleep(1)
	sock.close()
	

