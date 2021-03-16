#!/usr/bin/python

def FaderValue():
	d = raw_input("Enter dB Value (or 'x' for direct table conversion): ")
	if d == "-inf":
		q = 0
		print ""
		Midi(q)
	elif d == "x":
		q = input("Input Value from PRM table: ")
		print ""
		db = -141.00
		if q < 16:
			n = db + q*3
		elif q >= 16 and q < 34:
			n = db + 30 + q
		elif q >= 34 and q < 224:
			n = db + 56.4 + 0.2*q
		elif q >= 224 and q < 424:
			n = db + 78.7 + 0.1*q
		elif q >= 424 and q < 1024:
			n = db + 0.05*q + 99.85
		n = str(n)
		if q > 823:
			n = "+%s" %(n)
		if len(n) == 3:
			print "%s0 dB" %(n)
		elif len(n) >= 4:
			print "%s dB" %(n)
		Midi(q)
	else:
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
		print ""
		Midi(q)

FaderValue()
