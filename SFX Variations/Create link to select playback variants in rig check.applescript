-- @description SFX VARIATIONS: Create link to select playback variants in rig check
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 2.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Creates a cue underneath the rig check marker to go to any selection cues and choose the variant for the next performance
-- @separateprocess TRUE

-- @changelog
--   v2.0  + moved common functions to external script
--   v1.1  + allows assignment of UDVs from the script calling this one


-- USER DEFINED VARIABLES -----------------

try -- if global variables are given when this script is called by another, use those variables
	whereIsRigCheck
on error
	set whereIsRigCheck to "   RIG CHECK" -- the cue name of your rig check title cue – the cue this script creates will go underneath this
end try

---------- END OF USER DEFINED VARIABLES --


property util : script "Applescript Utilities"


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
			set allVariants to item 2 of (util's splitString((q name of eachCue), ": "))
		else
			set allVariants to allVariants & ", " & item 2 of (util's splitString((q name of eachCue), ": "))
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