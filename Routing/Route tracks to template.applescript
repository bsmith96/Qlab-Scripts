-- @description Route tracks to template
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 2.1
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Routes the selected audio track/s the same as a selected template cue
-- @separateprocess TRUE

-- @changelog
--   v2.1  + will now correctly route audio if it is ganged differently to the routing option
--   v2.0  + moved common functions to external script
--   v1.4  + works with videos as well
--   v1.3  + allows assignment of UDVs from the script calling this one
--   v1.2  + added option to turn off renaming cues
--         + added error catching
--   v1.1  + takes number of output channels from the notes of cues, to streamline editing for new projects


-- USER DEFINED VARIABLES -----------------

try -- if global variables are given when this script is called by another, use those variables
	renameCues
on error
	set renameCues to false -- whether or not to append cues with the name of the chosen template
end try

try
	variableCueListName
on error
	set variableCueListName to "Other scripts & utilities" -- cue list containing Script Variables
end try

try
	templateCueListName
on error
	set templateCueListName to "Other scripts & utilities" -- cue list containing template cues
end try

try
	templateGroupCueName
on error
	set templateGroupCueName to "Click track routing templates" -- group cue containing all template cues
end try

---------- END OF USER DEFINED VARIABLES --


-- VARIABLES FROM QLAB NOTES --------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	set audioChannelCount to notes of (first cue of (first cue list whose q name is variableCueListName) whose q name is "Output channel count") -- total number of Qlab output
end tell

------------------ END OF QLAB VARIABLES --


property util : script "Applescript Utilities"


---- RUN SCRIPT ---------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	set containerList to (first cue list whose q name is templateCueListName)
	
	set containerCue to first cue in containerList whose q name is templateGroupCueName
	
	set routingTemplates to (cues in containerCue)
	set routingNames to {}
	
	repeat with eachCue in routingTemplates
		set end of routingNames to (q name of eachCue)
	end repeat
	
	set whatTemplate to choose from list routingNames
	if whatTemplate is false then
		return
	end if
	
	set whatTemplateCue to first cue in containerCue whose q name is whatTemplate
	
	set selectedCues to (selected as list)
	
	repeat with eachCue in selectedCues
		
		set cueType to q type of eachCue
		if cueType is in {"Audio", "Video"} then
			repeat with eachChannel from 1 to audioChannelCount
				set eachGang to getGang eachCue row 0 column eachChannel
				if eachGang is missing value then
					set theLevel to getLevel whatTemplateCue row 0 column eachChannel
					setLevel eachCue row 0 column eachChannel db theLevel
				else
					setGang eachCue row 0 column eachChannel gang ""
					set theLevel to getLevel whatTemplateCue row 0 column eachChannel
					setLevel eachCue row 0 column eachChannel db theLevel
					setGang eachCue row 0 column eachChannel gang eachGang
				end if
			end repeat
			if renameCues is true then
				my renameCue(eachCue, whatTemplate)
			end if
		end if
		
	end repeat
	
end tell


-- FUNCTIONS ------------------------------

on renameCue(theCue, theTemplate)
	tell application id "com.figure53.Qlab.4" to tell front workspace
		set oldName to q display name of theCue
		set oldNameList to util's splitString(oldName, " | ")
		set oldName to item 1 of oldNameList
		set newName to oldName & " | " & theTemplate
		set q name of theCue to newName
	end tell
end renameCue