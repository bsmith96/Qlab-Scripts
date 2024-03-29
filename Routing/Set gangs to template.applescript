-- @description Set gangs to template
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 2.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Create a version of this script for each track you are using, and run each using a different hotkey.
-- @separateprocess TRUE

-- @changelog
--   v2.0  + moved common functions to external script
--   v1.4  + works with videos as well
--   v1.3  + allows assignment of UDVs from the script calling this one
--   v1.2  + added error catching


-- USER DEFINED VARIABLES -----------------

try -- if global variables are given when this script is called by another, use those variables
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
	set templateGroupCueName to "Gangs routing templates" -- group cue containing all template cues
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
	
	-- Get the number of inputs for the selected routing. To only affect the master level of each cue output channel, you can omit this from the template cue name
	
	set whatTemplateList to util's splitString((whatTemplate as string), " - ") -- append the cue name with " - 2" where "2" is the number of cue input channels to affect. To only affect levels and not crosspoints, you can omit this or enter "0".
	try
		set inputCount to item -1 of whatTemplateList as integer
	on error
		set inputCount to 0
	end try
	
	repeat with eachCue in selectedCues
		
		set cueType to q type of eachCue
		if cueType is in {"Audio", "Video"} then
			repeat with eachChannel from 1 to audioChannelCount
				repeat with eachInput from 0 to inputCount
					set theGang to getGang whatTemplateCue row eachInput column eachChannel
					try
						setGang eachCue row eachInput column eachChannel gang theGang
					on error
						setGang eachCue row eachInput column eachChannel gang ""
					end try
				end repeat
			end repeat
			
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