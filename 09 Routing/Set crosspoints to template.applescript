-- @description Set crosspoints to template
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.4
-- @testedmacos 10.13.6
-- @testedqlab 4.6.10
-- @about Set the crosspoints of the selected cue to match a selected template cue
-- @separateprocess TRUE

-- @changelog
--   v1.4  + allows assignment of UDVs from the script calling this one
--   v1.3  + Added error catching
--   v1.2  + Takes number of output channels from the notes of cues, to streamline editing for new projects
--   v1.1  + If only 1 template exists for the number of cue inputs, sets crosspoints automatically.


-- USER DEFINED VARIABLES -----------------

try -- if global variables are given when this cue is run from another script, use those variables
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
	set templateGroupCueName to "Crosspoints routing templates" -- group cue containing all template cues
end try

---------- END OF USER DEFINED VARIABLES --


-- VARIABLES FROM QLAB NOTES --------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	set audioChannelCount to notes of (first cue of (first cue list whose q name is variableCueListName) whose q name is "Output channel count") -- total number of Qlab output
end tell

------------------ END OF QLAB VARIABLES --


---- RUN SCRIPT ---------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	set containerList to (first cue list whose q name is templateCueListName)
	
	set containerCue to first cue in containerList whose q name is templateGroupCueName
	
	set routingTemplates to (cues in containerCue)
	set routingNames to {}
	set routingNumbers to {}
	
	repeat with eachCue in routingTemplates
		set end of routingNames to (q name of eachCue)
	end repeat
	
	set selectedCues to (selected as list)
	
	-- try to do it automatically
	try
		repeat with eachTemplate in routingNames
			set eachTemplateList to my splitString((eachTemplate as string), " - ")
			set inputCountTemplate to item -1 of eachTemplateList as integer
			set end of routingNumbers to inputCountTemplate
		end repeat
		
		repeat with eachCue in selectedCues
			set inputCountCue to audio input channels of eachCue
			
			set inputCountMatches to {}
			repeat with eachTemplate from 1 to length of routingTemplates
				if inputCountCue as integer is equal to (item eachTemplate of routingNumbers as integer) then
					set end of inputCountMatches to eachTemplate
				end if
			end repeat
			
			if length of inputCountMatches is 1 then
				set whatTemplate to item (item 1 of inputCountMatches) of routingNames
				set whatTemplateCue to (first cue in containerCue whose q name is whatTemplate)
				set whatTemplateList to my splitString((whatTemplate as string), " - ")
				set inputCount to item -1 of whatTemplateList as integer
				repeat with eachChannel from 1 to audioChannelCount
					repeat with eachInput from 1 to inputCount
						set theLevel to getLevel whatTemplateCue row eachInput column eachChannel
						setLevel eachCue row eachInput column eachChannel db theLevel
					end repeat
				end repeat
			else
				error
			end if
		end repeat
		return
	end try
	
	-- end of automatic section
	
	set whatTemplate to choose from list routingNames
	if whatTemplate is false then
		return
	end if
	
	set whatTemplateCue to first cue in containerCue whose q name is whatTemplate
	
	-- Get the number of inputs for the selected routing
	
	set whatTemplateList to my splitString((whatTemplate as string), " - ") -- append the cue name with " - 2" where "2" is the number of cue input channels to affect. ## Only works up to 9 ##
	try
		set inputCount to item -1 of whatTemplateList as integer
	on error
		return
	end try
	
	repeat with eachCue in selectedCues
		
		set cueType to q type of eachCue
		if cueType is "Audio" then
			repeat with eachChannel from 1 to audioChannelCount
				repeat with eachInput from 1 to inputCount
					set theLevel to getLevel whatTemplateCue row eachInput column eachChannel
					setLevel eachCue row eachInput column eachChannel db theLevel
				end repeat
			end repeat
			
		end if
		
	end repeat
	
end tell


-- FUNCTIONS ------------------------------

on renameCue(theCue, theTemplate)
	tell application id "com.figure53.Qlab.4" to tell front workspace
		set oldName to q display name of theCue
		set oldNameList to my splitString(oldName, " | ")
		set oldName to item 1 of oldNameList
		set newName to oldName & " | " & theTemplate
		set q name of theCue to newName
	end tell
end renameCue

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