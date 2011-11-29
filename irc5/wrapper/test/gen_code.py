#!/bin/usr/python

f_cmd = open('cmd_list', 'r') #read commands from file
f_code = open('test.mod', 'w') #location to save new program

# get number of commands in the file
for numLines, l in enumerate(f_cmd):
	pass
print numLines
f_cmd.seek(0) # head back to the start of the file

f_code.write('MODULE MainModule\n')
f_code.write('\tVAR string str_item := "alex"\n')
f_code.write('\tPROC main()\n')

counter = 0
#read file, one line (or command) at a time
for line in f_cmd:
	#split the line into individual words
	words = line.split()
	#use first word (the command) as if statement for first cmd, elseif for the rest
	if counter == 0:
		f_code.write('\t\tIF str_item = "' + words[0] + '" THEN\n')
	else:
		f_code.write('\t\tELSEIF str_item = "' + words[0] + '" THEN\n')
	f_code.write('\t\t\t ') 
	#print the command and its inputs, space seperated.
	for item in words:
		f_code.write(item + " ")
	f_code.write(';\n')
	f_code.write('\t\tENDIF\n')

	counter += 1

f_code.write('\t\tELSE THEN\n')
f_code.write('\t\t\tERR - Something went wrong\n')
f_code.write('\t\tENDIF\n')

f_code.write('\tENDPROC\n')
f_code.write('ENDMODULE\n')


