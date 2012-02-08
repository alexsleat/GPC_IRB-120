#!/usr/bin/python

import socket
import sys
import time


data = " ".join(sys.argv[1:])

print len(data)
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

send_string = [string1, string2, string3]

print send_string[:1]
