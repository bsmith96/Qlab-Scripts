-- Creates a midi sysex cue to set the cue / on value of any channel
-- Yamaha LS9-32
-- change to preamble will change desk type, should work for modern desks
--  but to be vereified
--
-- Example string inputs:
-- ch 7 on    -- channel 7 on
-- mix 16 off    -- mix 16 off
-- mtrx 4 cue     -- mtrx 4 cue off   
-- 
-- accepted chan values:   ch 1-64 ; st 1-4 ; mix 1-16 ; mt/mtrx 1-8
-- accepoted control values:    on ; off ; cue ; nocue
--
-- author: t.streuli

------- Script  --------

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	display dialog "Enter Channel Control String" default answer "" buttons {"Set", "Cancel"} cancel button "Cancel" default button "Set" with title "SCENE NUMBER"
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
	
	-- value and channel type
	set operation to item 3 of splitText
	if operation = "on" or operation = "cue" then
		set value to hex(1)
	else
		set value to hex(0)
	end if
	if operation = "on" or operation = "off" then
		if chan = "ch" or chan = "st" then
			set chanType to hex(49)
		else if chan = "mix" then
			set chanType to hex(76)
		else if chan = "mt" or chan = "mtrx" then
			set chanType to hex(93)
		end if
		set msg to pre & " 00 " & chanType & " 00 00 00 " & chanNumVal & " 00 00 00 00 " & value
		
	end if
	if operation = "cue" or operation = "nocue" then
		if chan = "ch" or chan = "st" then
			set chanType to hex(94)
		else if chan = "mix" then
			set chanType to hex(95)
		else if chan = "mt" or chan = "mtrx" then
			set chanType to hex(96)
		end if
		set msg to pre & " 01 " & chanType & " 00 00 00 " & chanNumVal & " 00 00 00 00 " & value
	end if
	
	return msg
end faderString

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