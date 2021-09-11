-- @description Create OSC control cue
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Create an OSC control cue
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

try
	cueTitle
on error
	set cueTitle to "LX"
end try

try
	cuePatch
on error
	set cuePatch to "2"
end try

try -- if global variables are given when this script is called by another, use those variables
	stringBase
on error
	set stringBase to "/eos/cue"
end try

try
	stringSuffix
on error
	set stringSuffix to ""
end try

try
	askForInString
on error
	set askForInString to {"Cue List Number", "Cue Number"}
end try

try
	askForValue
on error
	set askForValue to ""
end try

try
	cueColor
on error
	set cueColor to "Blue"
end try

---------- END OF USER DEFINED VARIABLES --


-- VARIABLES FROM QLAB NOTES --------------

------------------ END OF QLAB VARIABLES --


---- RUN SCRIPT ---------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	-- save current position
	try
		set currentPosition to last item of (selected as list)
	end try
	set currentCueList to current cue list
	
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
	make type "Network"
	set networkCue to last item of (selected as list)
	set osc message type of networkCue to custom
	set patch of networkCue to cuePatch
	
	-- Get context
	if askForInString is not {} then
		set userString to {}
		repeat with eachItem in askForInString
			display dialog "Please provide " & eachItem with title eachItem default answer ""
			set end of userString to ("/" & (text returned of result))
		end repeat
	end if
	
	if askForValue is not "" then
		display dialog "Please provide " & askForValue with title askForValue default answer ""
		set userValue to (text returned of result)
	end if
	
	-- Construct command
	try
		set oscCommand to stringBase & (every item of userString as string) & stringSuffix
	on error
		set oscCommand to stringBase & stringSuffix
	end try
	if askForValue is not "" then
		set oscCommand to oscCommand & " " & userValue
	end if
	
	-- Set cue
	set custom message of networkCue to oscCommand
	set q name of networkCue to cueTitle & ": " & oscCommand
	set q color of networkCue to cueColor
	
	-- put start cue in original cue list
	set current cue list to currentCueList
	try
		set selected to currentPosition
	end try
	
	make type "Start"
	set startCue to last item of (selected as list)
	set cue target of startCue to networkCue
	set q name of startCue to cueTitle & ": " & oscCommand
	set q color of startCue to cueColor
	if q type of (parent of startCue) is not "cue list" then
		set q color of (parent of startCue) to cueColor
	end if
	
end tell


-- FUNCTIONS ------------------------------
