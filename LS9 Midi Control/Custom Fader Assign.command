#!/usr/bin/python
print "LS9 MIDI SysEx Encoder"
print "Custom Fader Asigner"
pre = "43 10 3E 12 01"
x = 0
y = 0

while x != 1:
	print ""
	print ""
	cust = raw_input("Enter Custom Fader Channel No (65-68 St. In): ")
	if cust == "q":
		x = 1
		print ""
		print "Thank You"
		break
	else:
		cust = int(cust)
		
	while cust > 68:
		print "error"
		cust = input("Re-Enter Custom Fader Channel No. ")
		
	if cust > 64:
		cust = format(cust-33, '02X')
		ch = input("Enter Stereo Channel No: ")
		while ch > 4:
			print "error"
			ch = input("Re-Enter Stereo Channel No. ")
		ch = format(2*ch+62, '02X')
		ch = "00 00 00 00 %s" %(ch)
	else:
		cust = format(cust-1, '02X')
		typ = raw_input("Enter Channel Type (e.g. 'ch' , 'x' for NO Assign): ")
		while typ.isdigit() == True:
			typ = raw_input("ERROR: Enter Channel Type: ")
		
		if typ == "x":
			ch = "0F 7F 7F 7F 7F"
		elif typ == "mono" or typ == "sub":
			ch = "00 00 00 00 62"
		else:
			ch = input("Enter Channel/Mix/Matrix No: ")
			if typ == "ch":
				while ch > 64:
					print "error"
					ch = input("Re-Enter Channel No. ")
				ch = format(ch-1, '02X')
			elif typ == "mix":
				while ch > 16:
					print "error"
					ch = input("Re-Enter Mix No. ")
				ch = format(ch+71, '02X')
			elif typ == "mt" or typ == "mtrx":
				while ch > 8:
					print "error"
					ch = input("Re-Enter Matrix No. ")
				ch = format(ch+87, '02X')
				
			ch = "00 00 00 00 %s" %(ch)
	print ""
	print "%s 02 2C 00 %s 00 03 %s" %(pre,cust,ch)
