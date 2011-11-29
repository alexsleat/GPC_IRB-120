#!/bin/usr/python

f_cmd = open('cmd_list', 'r') #read commands from file
f_code = open('new.py', 'w') #location to save new program

f_code.write("#!/bin/usr/python\n") #add python location
f_code.write("str_item = 'alex'\n")

#read file, one line (or command) at a time
for line in f_cmd:
	#split the line into individual words
	words = line.split()
	#use first word (the command) as case item
	f_code.write("if str_item == '" + words[0] + "':\n")
	f_code.write("\tprint '") 
	for item in words:
		f_code.write(item + " ")
	f_code.write("'\n")

	#for item in words:
	#	print item,

