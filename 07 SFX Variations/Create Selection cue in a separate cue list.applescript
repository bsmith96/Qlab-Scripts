-- @description SFX VARIATIONS: Create selection cue in a separate cue list
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Creates a group and OSC cues in a separate cue list to select which variations to arm and disarm. Requires default group to be "timeline", and default network cue to be "Qlab message".
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	-- Define variables
	set triggerName to ""
	set triggerAbb to ""
	set triggerOptions to {}
	set triggerOptionsAbb to {}
	set allVariations to "No"
	set currentPosition to 0
	
	-- Get the name & abbreviation of the variation
	set firstResults to (display dialog "What is the name of this Character, or Announcement?" default answer "" buttons {"OK", "Announcement", "Cancel"} default button "OK" cancel button "Cancel")
	if button returned of firstResults is "Announcement" then
		set triggerName to "Announcement"
		set triggerAbb to "ann"
	else
		set triggerName to text returned of firstResults
		display dialog "What abbreviation do you want to use?" default answer ""
		set triggerAbb to text returned of result
	end if
	
	-- If announcements was selected, automatically populate with Evening and Matinee first
	if triggerAbb is "ann" then
		-- Set Evening name
		my insertItemInList("Evening", triggerOptions, 1)
		-- Set Evening abbreviation
		my insertItemInList("eve", triggerOptionsAbb, 1)
		-- Set Matinee name
		my insertItemInList("Matinee", triggerOptions, 2)
		-- Set Matinee abbreviation
		my insertItemInList("mat", triggerOptionsAbb, 2)
		
		-- Allow additional variations of announcements to be entered
		repeat while allVariations is not "Yes"
			set listPosition to (length of triggerOptions) + 1
			set results to (display dialog "If there are any variations, in addition to Evening and Matinee, start entering them here. If that is all, click \"That's All\"" default answer "" buttons {"OK", "That's All", "Cancel"} default button "OK" cancel button "Cancel")
			set nextOption to text returned of results
			set buttonReturned to button returned of results
			if buttonReturned is "That's All" then exit repeat
			my insertItemInList(nextOption, triggerOptions, listPosition)
			display dialog "What abbreviation do you want to use?" default answer ""
			set nextAbb to text returned of result
			my insertItemInList(nextAbb, triggerOptionsAbb, listPosition)
		end repeat
	else
		
		-- Get the names & abbreviations of each variation (e.g. understudies)
		repeat while allVariations is not "Yes"
			set listPosition to (length of triggerOptions) + 1
			if length of triggerOptions is less than 1 then
				set results to (display dialog "Which is the first actor playing this character, or variation of the announcement?" default answer "" buttons {"OK", "That's All", "Cancel"} default button "OK" cancel button "Cancel")
				set nextOption to text returned of results
				set buttonReturned to button returned of results
				my insertItemInList(nextOption, triggerOptions, listPosition)
				display dialog "What abbreviation do you want to use?" default answer ""
				set nextAbb to text returned of result
				my insertItemInList(nextAbb, triggerOptionsAbb, listPosition)
			else
				set results to (display dialog "Which is the next actor playing this character, or variation of the announcement?" default answer "" buttons {"OK", "That's All", "Cancel"} default button "OK" cancel button "Cancel")
				set nextOption to text returned of results
				set buttonReturned to button returned of results
				if buttonReturned is "That's All" then exit repeat
				my insertItemInList(nextOption, triggerOptions, listPosition)
				display dialog "What abbreviation do you want to use?" default answer ""
				set nextAbb to text returned of result
				my insertItemInList(nextAbb, triggerOptionsAbb, listPosition)
			end if
			
			
		end repeat
		
	end if
	
	
	-- Create cue list if necessary, or switch to it
	set didItWork to "No"
	try
		set current cue list to first cue list whose q name is "Select Playback Variants"
		set didItWork to "Yes"
	end try
	if didItWork is "No" then
		make type "cue list"
		set variantSelectCueList to first cue list whose q name is "Cue list"
		set q name of variantSelectCueList to "Select Playback Variants"
		collapse variantSelectCueList
		set current cue list to first cue list whose q name is "Select Playback Variants"
	end if
	
	-- Make the main variations group (not to be fired, just to house those within)
	make type "group"
	set triggerGroup to last item of (selected as list)
	set mode of triggerGroup to timeline
	set q name of triggerGroup to "Select: " & triggerName
	set q color of triggerGroup to "cerulean"
	set triggerGroupID to uniqueID of triggerGroup
	
	-- Make variation groups
	repeat with eachItem in triggerOptions
		
		--Set the current variation for triggerOptionsAbb
		set currentPosition to currentPosition + 1
		set eachAbb to item currentPosition in triggerOptionsAbb
		
		-- Make the group for each trigger option
		make type "group"
		set itemGroup to last item of (selected as list)
		set mode of itemGroup to timeline
		set q name of itemGroup to "Select " & triggerName & ": " & eachItem
		set q number of itemGroup to "sel." & triggerAbb & "." & eachAbb
		set itemGroupID to uniqueID of itemGroup
		move cue id itemGroupID of parent of itemGroup to end of triggerGroup
		
		-- Disarm all
		make type "network"
		set disarmAll to last item of (selected as list)
		set disarmAllID to uniqueID of disarmAll
		set osc message type of disarmAll to qlab
		set q_num of disarmAll to triggerAbb & ".*"
		set q_command of disarmAll to 20
		set q_params of disarmAll to "0"
		move cue id disarmAllID of parent of disarmAll to end of itemGroup
		
		-- Arm correct cues
		make type "network"
		set armCorrect to last item of (selected as list)
		set armCorrectID to uniqueID of armCorrect
		set osc message type of armCorrect to qlab
		set q_num of armCorrect to triggerAbb & "." & eachAbb & ".*"
		set q_command of armCorrect to 20
		set q_params of armCorrect to "1"
		move cue id armCorrectID of parent of armCorrect to end of itemGroup
		
		-- Uncolour all
		make type "network"
		set uncolorAll to last item of (selected as list)
		set uncolorAllID to uniqueID of uncolorAll
		set osc message type of uncolorAll to qlab
		set q_num of uncolorAll to triggerAbb & ".*"
		set q_command of uncolorAll to 21
		set q_params of uncolorAll to "none"
		move cue id uncolorAllID of parent of uncolorAll to end of itemGroup
		
		-- Color currently chosen options
		make type "network"
		set colorCorrect to last item of (selected as list)
		set colorCorrectID to uniqueID of colorCorrect
		set osc message type of colorCorrect to qlab
		set q_num of colorCorrect to triggerAbb & "." & eachAbb & ".*"
		set q_command of colorCorrect to 21
		set q_params of colorCorrect to "celadon"
		move cue id colorCorrectID of parent of colorCorrect to end of itemGroup
		
		-- Rename the group which contains the voiceover / announcement, to visually display the currently selected variation
		set thisCuePrefix to triggerAbb & "." & eachAbb
		set thisCueName to eachItem
		set thisCueList to "cues in (first cue list whose q name is \"Main Cue List\")"
		my makeRenameScript(thisCuePrefix, thisCueName, thisCueList, itemGroup)
		
		collapse itemGroup
		
	end repeat
	
end tell


-- FUNCTIONS ------------------------------

on insertItemInList(theItem, theList, thePosition)
	set theListCount to length of theList
	if thePosition is 0 then
		return false
	else if thePosition is less than 0 then
		if (thePosition * -1) is greater than theListCount + 1 then return false
	else
		if thePosition is greater than theListCount + 1 then return false
	end if
	if thePosition is less than 0 then
		if (thePosition * -1) is theListCount + 1 then
			set beginning of theList to theItem
		else
			set theList to reverse of theList
			set thePosition to (thePosition * -1)
			if thePosition is 1 then
				set beginning of theList to theItem
			else if thePosition is (theListCount + 1) then
				set end of theList to theItem
			else
				set theList to (items 1 thru (thePosition - 1) of theList) & theItem & (items thePosition thru -1 of theList)
			end if
			set theList to reverse of theList
		end if
	else
		if thePosition is 1 then
			set beginning of theList to theItem
		else if thePosition is (theListCount + 1) then
			set end of theList to theItem
		else
			set theList to (items 1 thru (thePosition - 1) of theList) & theItem & (items thePosition thru -1 of theList)
		end if
	end if
	return theList
end insertItemInList

-- Script with the text to be copied into the script created, for renaming groups containing these SFX
on makeRenameScript(theCuePrefix, theCueName, theCueList, itemGroup)
	tell application id "com.figure53.Qlab.4" to tell front workspace
		
		make type "Script"
		set renameScript to last item of (selected as list)
		set renameScriptID to uniqueID of renameScript
		set script source of renameScript to "tell application id \"com.figure53.QLab.4\" to tell front workspace

	set cuePrefix to \"" & theCuePrefix & "\"
	set cueName to \"" & theCueName & "\"
	set cueList to " & theCueList & "
	set controlCueList to cues in (first cue list whose q name is \"Select Playback Variants\")
	
	repeat with levelOneCues in cueList
		if q type of levelOneCues is \"Group\" then
			my testForIt(cuePrefix, cueName, cueList, levelOneCues)
			set levelOneCuesList to cues in levelOneCues
			repeat with levelTwoCues in levelOneCuesList
				my testForIt(cuePrefix, cueName, cueList, levelTwoCues)
			end repeat
		end if
	end repeat

	-- new addition starts
	repeat with levelOneCues in controlCueList
		if q type of levelOneCues is \"Group\" then
			my testForIt((\"sel.\" & cuePrefix), cueName, controlCueList, levelOneCues)
			set levelOneCuesList to cues in levelOneCues
			repeat with levelTwoCues in levelOneCuesList
				my testForIt((\"sel.\" & cuePrefix), cueName, controlCueList, levelTwoCues)
			end repeat
		end if
	end repeat
	-- new addition ends
	
end tell

on testForIt(cuePrefix, cueName, cueList, groupCue)
	
	tell application id \"com.figure53.Qlab.4\" to tell front workspace
		try
			set eachCue to cues in groupCue
			set isThisCue to \"\"
			repeat with nextCues in eachCue
				if q number of nextCues starts with cuePrefix then
					set isThisCue to \"YES\"
					exit repeat
				else
					set isThisCue to \"NO\"
				end if
			end repeat
			--display dialog isThisCue
			if isThisCue is \"YES\" then
				if notes of groupCue is \"\" then set notes of groupCue to q name of groupCue
				set originalCueName to notes of groupCue
				set q name of groupCue to cueName & \" | \" & originalCueName
			end if
		end try
	end tell
	
end testForIt"
		set q name of renameScript to "Rename group " & theCuePrefix
		move cue id renameScriptID of parent of renameScript to end of itemGroup
	end tell
	
end makeRenameScript