-- Creates a midi sysex cue to set the value of any fader to a given value
-- Yamaha LS9-32
-- change to preamble will change desk type, should work for modern desks
--  but to be vereified
--
-- Example string inputs:
-- ch 7 to -20    -- channel 7 to -20db
-- mix 16 to 1    -- mix 16 to +1db
-- mtrx 4 out     -- mtrx 4 to -inf db  (if setting out/-inf NO NOT include 'to')
-- 
-- accepted chan values:   ch 1-64 ; st 1-4 ; mix 1-16 ; mt/mtrx 1-8
-- accepoted db values:    out/-Inf ; -137 -> +10
--
-- author: t.streuli

------- Script  --------

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	display dialog "Enter Fader Level Control String" default answer "" buttons {"Set", "Cancel"} cancel button "Cancel" default button "Set" with title "SCENE NUMBER"
	set inputMsg to text returned of result
	
	set message to my faderString(inputMsg)
	
	-- Make the midi program cue
	make type "Midi"
	set midiBank to first item of (selected as list)
	set message type of midiBank to sysex
	set sysex message of midiBank to message
	set q name of midiBank to inputMsg
	
end tell


---------- Functions ----------------

-- SYSEX midi string for given control string
on faderString(inputMsg)
	set pre to "43 10 3E 12 01"
	set splitText to split(inputMsg, space)
	
	-- channel number
	set chan to item 1 of splitText
	set chanN to item 2 of splitText as integer
	if chan = "st" then
		set chanNumVal to hex(chanN * 2 + 62)
	else
		set chanNumVal to hex(chanN - 1)
	end if
	
	-- Hex value for channel type
	if chan = "ch" or chan = "st" then
		set chanType to hex(51)
	else if chan = "mix" then
		set chanType to hex(78)
	else if chan = "mt" or chan = "mtrx" then
		set chanType to hex(95)
	end if
	-- stereo master = 109, not checked or implimented
	
	-- fader value
	if length of splitText = 3 then
		set dbVal to item 3 of splitText
		if dbVal = "out" or dbVal = "-inf" then
			set value to "00 00"
		end if
	else if length of splitText is equal to 4 then
		set dbVal to item 4 of splitText as number
		set value to midiDbVal(dbVal)
	end if
	
	set msg to pre & " 00 " & chanType & " 00 00 00 " & chanNumVal & " 00 00 00 " & value
	return msg
end faderString

-- fader value as hex string
on midiDbVal(d)
	if d > -138.0 and d ≤ -96.0 then
		set q to 47 + (d / 3)
	else if d > -96.0 and d ≤ -78.0 then
		set q to 111 + d
	else if d > -77.8 and d ≤ -40 then
		set q to 423 + d * 5
	else if d > -40 and d ≤ -20 then
		set q to 623 + d * 10
	else if d > -20 then
		set q to 823 + d * 20
	end if
	set q to round (q)
	
	set y to q div 128 as text
	set z to hex(q mod 128)
	
	set midiVal to "0" & y & " " & z
	return midiVal
end midiDbVal

-- splits text into list
to split(someText, delimiter)
	set AppleScript's text item delimiters to delimiter
	set someText to someText's text items
	set AppleScript's text item delimiters to {""}
	return someText
end split

-- returns hex from an integer
on hex(x)
	set val to do shell script "perl -e 'printf(\"%02X\", " & x & ")'"
	return val
end hex