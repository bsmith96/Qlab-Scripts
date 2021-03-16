#!/usr/bin/python
print "LS9 MIDI SysEx Encoder"
print "Channel On / Cue Function"
pre = "43 10 3E 12 01"
x = 0

print ""
print ""
op = raw_input("Enter Operation (on, off, cue, nocue): ")

while x != 1:
	if op == "q":
		x = 1
		print ""
		print "Thank You"
		break

	print ""
	print op.upper()
	typ, ch = raw_input("Enter Channel Type and No. (e.g. 'ch 5'): ").split()
	ch = int(ch)
	
	if op == "on" or op == "cue":
		q = format(1, '02X')
	else:
		q = format(0, '02X')
	
	if op == "on" or op == "off":
		if typ == "ch":
			xtyp = format(49, '02X')
			while ch > 64:
				print "error"
				ch = input("Re-Enter Channel No. ")
			ch = format(ch-1, '02X')
		elif typ == "st":
			xtyp = format(49, '02X')
			while ch > 4:
				print "st error"
				ch = input("Re-Enter Stereo Channel No. ")
			ch = format(ch*2+62, '02X')
		elif typ == "mix":
			xtyp = format(76, '02X')
			while ch > 16:
				print "mix error"
				ch = input("Re-Enter Mix No. ")
			ch = format(ch-1, '02X')
		elif typ == "mt" or typ == "mtrx":
			xtyp = format(93, '02X')
			while ch > 8:
				print "mt error"
				ch = input("Re-Enter Matrix No. ")
			ch = format(ch-1, '02X')
			
		print "%s 00 %s 00 00 00 %s 00 00 00 00 %s" %(pre,xtyp,ch,q)

	if op == "cue" or op == "nocue":
		if typ == "ch":
			xtyp = format(94, '02X')
			while ch > 64:
				print "error"
				ch = input("Re-Enter Channel No. ")
			ch = format(ch-1, '02X')
		elif typ == "st":
			xtyp = format(94, '02X')
			while ch > 4:
				print "st error"
				ch = input("Re-Enter Stereo Channel No. ")
			ch = format(ch*2+62, '02X')
		elif typ == "mix":
			xtyp = format(95, '02X')
			while ch > 16:
				print "mix error"
				ch = input("Re-Enter Mix No. ")
			ch = format(ch-1, '02X')
		elif typ == "mt" or typ == "mtrx":
			xtyp = format(96, '02X')
			while ch > 8:
				print "mt error"
				ch = input("Re-Enter Matrix No. ")
			ch = format(ch-1, '02X')
			
		print "%s 01 %s 00 00 00 %s 00 00 00 00 %s" %(pre,xtyp,ch,q)
