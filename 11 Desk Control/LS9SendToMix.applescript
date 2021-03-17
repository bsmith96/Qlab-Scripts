-- Creates a midi sysex cue to set the value of a fader's send to a mix
-- Yamaha LS9-32
-- change to preamble will change desk type, should work for modern desks
--  but to be vereified
--
-- Example string inputs:
-- ch 7 to mix 5 at -20    -- send channel 7 to mix 5 at -20db
-- 
-- accepted chan values:   ch 1-64 
-- accepted mix values:    mix 1-16 
-- accepoted db values:    -inf ; -137 -> +10
--
-- author: t.streuli

------- Script  --------

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	display dialog "Enter Fader Sent to Mix Control String" default answer "" buttons {"Set", "Cancel"} cancel button "Cancel" default button "Set" with title "SCENE NUMBER"
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
	
    -- channel & mix number
	set chanN to item 2 of splitText as integer
	set chanNumVal to hex(chanN - 1)

	set mixN to item 5 of splitText as integer
	set mixNumVal to hex(mixN*3+2)

    -- send value value
	set dbVal to item 7 of splitText as number
    if dbVal = "-inf" then
			set value to "00 00"
    else
        set value to midiDbVal(dbVal)
	end if
	
	set msg to pre & " 00 43 00 " & mixNumVal & " 00 " & chanNumVal & " 00 00 00 " & value
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