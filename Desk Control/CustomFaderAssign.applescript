-- Creates a midi sysex cue to assign any fader to a specific custom fader
-- Yamaha LS9-32
-- change to preamble will change desk type, should work for modern desks
--  but to be vereified
--
-- Example string inputs:
-- ch 7 to custom 3    -- channel 7 to -20db
-- x to custom 10
-- mono to custom 1
-- accepted chan values:   ch 1-64 ; mix 1-16 ; mt/mtrx 1-8 ; mono/sub
-- accepoted custom fader values:  custom 1 - 32
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
	
    if length of splitText = 5 then
        set chan to item 1 of splitText
        set chanN to item 2 of splitText as integer
        set customN to item 5 of splitText as integer
    else
        set chan to item 1 of splitText
        set customN to item 4 of splitText as integer
    end if

    set customNumVal to hex(customN-1)

	-- channel type and number
    if chan = "x" then
		set chanNumVal to "0F 7F 7F 7F 7F"
    else if chan = "mono" or chan = "sub" then
		set chanNumVal to "00 00 00 00 62"
	else if chan = "ch" then
		set chanNumVal to "00 00 00 00 " & hex(chanN - 1)
	else if chan = "mix" then
		set chanNumVal to "00 00 00 00 " & hex(chanN + 71)
    else if chan = "mt" or chan = "mtrx" then
		set chanNumVal to "00 00 00 00 " & hex(chanN + 87)
	end if
	
	set msg to pre & " 02 2C 00 " & customNumVal & " 00 03 " & chanNumVal
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