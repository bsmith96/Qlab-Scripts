import math
import time
pre = "43 10 3E 12 01"
print("LS9 MIDI SysEx Encoder") 
print("Which function do you need?") 
print("") 

def Midi(q):
	x = int(q)
	y = x//128
	z = format(x%128, '02X')
	if len(z) == 1:
		print("MIDI Value is:  0%d 0%s" %(y,z))
	elif len(z) == 2:
		print("MIDI Value is:  0%d %s" %(y,z))
		
def Midi2(q):
	x = int(q)
	y = x//128
	z = format(x%128, '02X')
	global v
	if len(z) == 1:
		v = "0%d 0%s" %(y,z)
	elif len(z) == 2:
		v = "0%d %s" %(y,z)
	return v

def Fader():
	typ, ch = input("Enter Channel Type and No. (e.g. 'ch 3'): ").split()
	while typ.isdigit() == True or ch.isdigit() == False:
		typ, ch = input("ERROR: Enter Channel Type and No. (e.g. 'ch 3'): ").split()
	ch = int(ch)
	if typ == "ch":
		xtyp = format(51, '02X')
		while ch > 64:
			ch = eval(input("Re-Enter Channel No. "))
		chN = ch
		ch = format(ch-1, '02X')
	elif typ == "st":
		xtyp = format(51, '02X')
		while ch > 4:
			ch = eval(input("Re-Enter Stereo Channel No. "))
		chN = ch
		ch = format(ch*2+62, '02X')
	elif typ == "mix":
		xtyp = format(78, '02X')
		while ch > 16:
			ch = eval(input("Re-Enter Mix No. "))
		chN = ch
		ch = format(ch-1, '02X')
	elif typ == "mt" or typ == "mtrx":
		xtyp = format(95, '02X')
		while ch > 8:
			ch = eval(input("Re-Enter Matrix No. "))
		chN = ch
		ch = format(ch-1, '02X')
	d = input("At dB: ")
	while d.isalpha() == True:
		d = input("ERROR: At dB: ")
	dN = d
	d = float(d)
	if abs(d) != d:
		d *= -1
		if d <= 138.0 and d >= 96.0:
			q = 47 - d//3
		elif d <= 95.0 and d >= 78.0:
			q = 111 - d
		elif d <= 77.8 and d >= 40.0:
			q = 423 - d*5
		elif d <= 39.9 and d >= 20.0:
			q = 623 - d*10
		elif d <= 19.95 and d >= 0.05:
			q = 823 - d*20
	else:
		q = 823 + d*20
	
	Midi2(q)
	
	data[c] = "Fader:   %s %d at %sdB" %(typ,chN,dN)
	msg[c] = "%s 00 %s 00 00 00 %s 00 00 00 %s" %(pre,xtyp,ch,v)
	print("%s 00 %s 00 00 00 %s 00 00 00 %s" %(pre,xtyp,ch,v))
	
		
def OnCue():
	typ, ch = input("Enter Channel Type and No. (e.g. 'ch 5'): ").split()
	while typ.isdigit() == True or ch.isdigit() == False:
		typ, ch = input("ERROR: Enter Channel Type and No. (e.g. 'ch 5'): ").split()
	ch = int(ch)
	op = input("Enter Operation (on, off, cue, nocue): ")
	while op.isdigit() == True:
		op = input("ERROR: Enter Operation (on, off, cue, nocue): ")
		
	if op == "on" or op == "cue":
		q = format(1, '02X')
	else:
		q = format(0, '02X')
	
	if op == "on" or op == "off":
		if typ == "ch":
			xtyp = format(49, '02X')
			while ch > 64:
				ch = input("Re-Enter Channel No. ")
			chN = ch
			ch = format(ch-1, '02X')
		elif typ == "st":
			xtyp = format(49, '02X')
			while ch > 4:
				ch = input("Re-Enter Stereo Channel No. ")
			chN = ch
			ch = format(ch*2+62, '02X')
		elif typ == "mix":
			xtyp = format(76, '02X')
			while ch > 16:
				ch = input("Re-Enter Mix No. ")
			chN = ch
			ch = format(ch-1, '02X')
		elif typ == "mt" or typ == "mtrx":
			xtyp = format(93, '02X')
			while ch > 8:
				ch = input("Re-Enter Matrix No. ")
			chN = ch
			ch = format(ch-1, '02X')
		
		msg[c] = "%s 00 %s 00 00 00 %s 00 00 00 00 %s" %(pre,xtyp,ch,q)
		print("%s 00 %s 00 00 00 %s 00 00 00 00 %s" %(pre,xtyp,ch,q))

	if op == "cue" or op == "nocue":
		if typ == "ch":
			xtyp = format(94, '02X')
			while ch > 64:
				ch = input("Re-Enter Channel No. ")
			chN = ch
			ch = format(ch-1, '02X')
		elif typ == "st":
			xtyp = format(94, '02X')
			while ch > 4:
				ch = input("Re-Enter Stereo Channel No. ")
			chN = ch
			ch = format(ch*2+62, '02X')
		elif typ == "mix":
			xtyp = format(95, '02X')
			while ch > 16:
				print("mix error")
				ch = input("Re-Enter Mix No. ")
			chN = ch
			ch = format(ch-1, '02X')
		elif typ == "mt" or typ == "mtrx":
			xtyp = format(96, '02X')
			while ch > 8:
				ch = input("Re-Enter Matrix No. ")
			chN = ch
			ch = format(ch-1, '02X')
			
		msg[c] = "%s 01 %s 00 00 00 %s 00 00 00 00 %s" %(pre,xtyp,ch,q)
		print("%s 01 %s 00 00 00 %s 00 00 00 00 %s" %(pre,xtyp,ch,q))
	op = op.upper()
	data[c] = "On/Cue:  %s %d: %s" %(typ,chN,op)
	

def SendToMix():
	ch = input("Input Channel No: ")
	while ch.isdigit() == False:
		ch = input("ERROR: Input Channel No: ")
	while int(ch) > 64:
		ch = input("Re-Enter Input Channel No: ")
		
	mix = input("Send to Mix: ")
	while mix.isdigit() == False:
		mix = input("ERROR: Send to Mix: ")
	mix = int(mix)
	while mix > 16:
		mix = input("Re-Enter Mix No. ")
		
	ch = int(ch)
	chN = ch
	mixN = mix
	
	mix = format(mix*3+2, '02X')
	ch = format(ch-1, '02X')
	
	d = input("At dB: ")
	while d.isalpha() == True:
		d = input("ERROR: At dB: ")
	
	dN = d
	d = float(d)
	if abs(d) != d:
		d *= -1
		if d <= 138.0 and d >= 96.0:
			q = 47 - d//3
		elif d <= 95.0 and d >= 78.0:
			q = 111 - d
		elif d <= 77.8 and d >= 40.0:
			q = 423 - d*5
		elif d <= 39.9 and d >= 20.0:
			q = 623 - d*10
		elif d <= 19.95 and d >= 0.05:
			q = 823 - d*20
	else:
		q = 823 + d*20
	
	Midi2(q)
	

	data[c] = "Send:    Input %d to Mix %d at %s" %(chN,mixN,dN)
	msg[c] = "%s 00 43 00 %s 00 %s 00 00 00 %s" %(pre,mix,ch,v)
	print("%s 00 43 00 %s 00 %s 00 00 00 %s" %(pre,mix,ch,v))
	
	
def Custom():
	
	cust = input("Enter Custom Fader Channel No (33-36 St. In): ")
	while cust.isdigit() == False:
		cust = input("ERROR: Enter Custom Fader Channel No (33-36 St. In): ")
	cust = int(cust)
	while cust > 68:
		print("error")
		cust = input("Re-Enter Custom Fader Channel No. ")
	custN = cust
		
	if cust > 32:
		cust = format(cust-1, '02X')
		ch = input("Enter Stereo Input Channel No: ")
		while ch > 4:
			print("error")
			ch = input("Re-Enter Stereo Input Channel No. ")
		chN = ch
		ch = format(2*ch+62, '02X')
		ch = "00 00 00 00 %s" %(ch)
	else:
		cust = format(cust-1, '02X')
		typ = input("Enter Channel Type (e.g. 'ch / mix' , 'x' for NO Assign): ")
		while typ.isdigit() == True:
			typ = input("ERROR: Enter Channel Type: ")

		if typ == "x":
			ch = "0F 7F 7F 7F 7F"
			chN = "No Assign"
		elif typ == "mono" or typ == "sub":
			ch = "00 00 00 00 62"
			chN = ""
		else:
			ch = input("Enter Channel/Mix/Matrix No: ")
			if typ == "ch":
				while ch > 64:
					print("error")
					ch = input("Re-Enter Channel No. ")
				chN = ch
				ch = format(ch-1, '02X')
			elif typ == "mix":
				while ch > 16:
					print("error")
					ch = input("Re-Enter Mix No. ")
				chN = ch
				ch = format(ch+71, '02X')
			elif typ == "mt" or typ == "mtrx":
				while ch > 8:
					print("error")
					ch = input("Re-Enter Matrix No. ")
				chN = ch
				ch = format(ch+87, '02X')
				
			ch = "00 00 00 00 %s" %(ch)
	chN = str(chN)
	msg[c] = "%s 02 2C 00 %s 00 03 %s" %(pre,cust,ch)
	data[c] = "Cust:    %s %s --> custom %s" %(typ,chN,custN)
	print("%s 02 2C 00 %s 00 03 %s" %(pre,cust,ch))


main = 0
global c
c = 0
global msg
msg = [""] * 99
data = [""] * 99

def Menu():
	print("Menu:")
	print("1 - Fader Level")
	print("2 - Ch On/Cue")
	print("3 - Send to Mix")
	print("4 - Custom Fader Assign")
	print("5 - Help")
	print("6 - Exit & Print")

while main != 5:
	Menu()
	main = input("Type in a number (1-6): ")
	try:
		if main == "q":
			exit()
		main = int(main)
	except ValueError:
		print("ERROR")
	# while main.isdigit() == False:
	# 	main = (input("ERROR: Type in a number (1-6): "))
	# main = int(main)

	while main == 1:
		print("")
		Fader()
		c += 1
		time.sleep(0.5)
		print("")
		t = eval(input("Press 'enter' to Repeat, or 'q' to return to Menu: "))
		if t == "q":
			print("")
			main = 0
		else:
			main = 1
	while main == 2:
		print("")
		OnCue()
		c += 1
		time.sleep(0.5)
		print("")
		t = eval(input("Press 'enter' to Repeat, or 'q' to return to Menu: "))
		if t == "q":
			print("")
			main = 0
		else:
			main = 2
	while main == 3:
		print("")
		SendToMix()
		c += 1
		time.sleep(0.5)
		print("")
		t = eval(input("Press 'enter' to Repeat, or 'q' to return to Menu: "))
		if t == "q":
			print("")
			main = 0
		else:
			main = 3
	while main == 4:
		print("")
		Custom()
		c += 1
		time.sleep(0.5)
		print("")
		t = eval(input("Press 'enter' to Repeat, or 'q' to return to Menu: "))
		if t == "q":
			print("")
			main = 0 
		else:
			main = 4
	if main == 5:
		print("")
		print("F0 43 10 3E 12 01 00 'typ' 00 'xx' cc cc dd dd dd dd dd F7")
		print("")
		time.sleep(3)
		main = 0
	if main == 6:
		print("")
		for a in range(0, c):
			print(data[a])
			print(msg[a])
			print("")
		print("")
		print("Thank You")
		exit()
