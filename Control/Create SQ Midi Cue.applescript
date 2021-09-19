-- @description Create SQ Midi control cue
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Create an SQ Midi control cue
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

try -- if global variables are given when this script is called by another, use those variables
	cueTitle
on error
	set cueTitle to "SQ5"
end try

try
	cuePatch
on error
	set cuePatch to "1"
end try

try
	askForValue
on error
	set askForValue to "Cue Number"
end try

try
	cueColor
on error
	set cueColor to "green"
end try

---------- END OF USER DEFINED VARIABLES --


-- VARIABLES FROM QLAB NOTES --------------

------------------ END OF QLAB VARIABLES --


property util : script "Applescript Utilities"


---- RUN SCRIPT ---------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	-- save current position
	try
		set currentPosition to last item of (selected as list)
	end try
	set currentCueList to current cue list
	
	-- Get context
	display dialog "Please provide " & askForValue with title cueTitle default answer ""
	set sceneNumber to (text returned of result) as integer
	
	display dialog "Please provide cue name" with title "cueTitle" default answer ""
	set sceneName to (text returned of result)
	
	-- Construct midi message
	set bankNumHex to my calculateBank(sceneNumber)
	set sceneNumHex to my calculateScene(sceneNumber)
	
	set bankMessage to "B0 00 " & bankNumHex
	set sceneMessage to " C0 " & sceneNumHex
	
	-- Create cue list if necessary, or switch to it
	try
		set cueList to first cue list whose q name is (cueTitle & " control")
	on error
		make type "cue list"
		set cueList to first cue list whose q name is "Cue list"
		set q name of cueList to (cueTitle & " control")
		set q color of cueList to cueColor
		collapse cueList
	end try
	
	set current cue list to cueList
	
	-- Create cue
	make type "Midi"
	set midiCue to last item of (selected as list)
	set message type of midiCue to sysex
	set patch of midiCue to cuePatch
	
	-- Set cue
	set sysex message of midiCue to bankMessage & sceneMessage
	set q name of midiCue to cueTitle & ": Scene " & sceneNumber & " - " & sceneName
	set q color of midiCue to cueColor
	
	-- put start cue in original cue list
	set current cue list to currentCueList
	try
		set selected to currentPosition
	end try
	
	make type "Start"
	set startCue to last item of (selected as list)
	set cue target of startCue to midiCue
	set q name of startCue to cueTitle & ": Scene " & sceneNumber & " - " & sceneName
	set q color of startCue to cueColor
	if q type of (parent of startCue) is not "cue list" then
		set q color of (parent of startCue) to cueColor
	end if
	
end tell


-- FUNCTIONS ------------------------------

on calculateBank(num)
	set bank to integer
	if num is less than 129 then
		set bank to "00"
	end if
	if num is greater than 128 and num is less than 257 then
		set bank to "01"
	end if
	if num is greater than 256 and num is less than 385 then
		set bank to "02"
	end if
	if num is greater than 384 and num is less than 501 then
		set bank to "03"
	end if
	
	
	set bankNumHex to bank
end calculateBank

on calculateScene(num)
	set scene to integer
	if num is less than 129 then
		set scene to num - 1
	end if
	if num is greater than 128 and num is less than 257 then
		set scene to (num - 129)
	end if
	if num is greater than 256 and num is less than 385 then
		set scene to (num - 257)
	end if
	if num is greater than 384 and num is less than 501 then
		set scene to (num - 385)
	end if
	
	set sceneHex to do shell script "perl -e 'printf(\"%02X\", " & scene & ")'"
	
	set sceneNumHex to sceneHex
end calculateScene
