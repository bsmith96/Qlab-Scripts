-- @description SFX VARIATIONS: Create link to select playback variants in rig check
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Creates a cue underneath the rig check marker to go to any selection cues and choose the variant for the next performance
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

set whereIsRigCheck to "   RIG CHECK" -- the cue name of your rig check title cue – the cue this script creates will go underneath this

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace

	-- Define variables
	set allVariants to ""
	set current cue list to first cue list whose q name is "Main Cue List"
	set theCueList to cues in first cue list whose q name is "Select Playback Variants"
	set cueBefore to (first cue in current cue list whose q name is whereIsRigCheck)
	
	-- Get a list of all variables
	repeat with eachCue in (cues in (first cue list whose q name is "Select Playback Variants") as list)
		if allVariants is "" then
			set allVariants to item 2 of (my splitString((q name of eachCue), ": "))
		else
			set allVariants to allVariants & ", " & item 2 of (my splitString((q name of eachCue), ": "))
		end if
	end repeat
	
	-- Create the cue
	set selected to cueBefore
	make type "Script"
	set scriptCheckCue to last item of (selected as list)
	set scriptCheckCueID to uniqueID of scriptCheckCue
	set q name of scriptCheckCue to "         Set playback variants here: " & allVariants
	set script source of scriptCheckCue to "tell application id \"com.figure53.Qlab.4\" to tell front workspace

	set current cue list to first cue list whose q name is \"Select Playback Variants\"
	
	end tell"
	
end tell


-- FUNCTIONS ------------------------------

on splitString(theString, theDelimiter)
	-- save delimiters to restore old settings
	set oldDelimiters to AppleScript's text item delimiters
	-- set delimiters to delimiter to be used
	set AppleScript's text item delimiters to theDelimiter
	-- create the array
	set theArray to every text item of theString
	-- restore old setting
	set AppleScript's text item delimiters to oldDelimiters
	-- return the array
	return theArray
end splitString