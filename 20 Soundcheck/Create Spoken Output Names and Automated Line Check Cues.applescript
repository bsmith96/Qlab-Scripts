##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: TRUE

### Create Spoken Output Names and Automated Line Check Cues


-- USER DEFINED VARIABLES

-- Input channel names as a single string, separated by ",". Some guidance on channel names for the best result:
-- 1. for main PA, using the term "pros" will have its pronunciation corrected.
-- 2. for foldback, the TTS works better if "Foldback" is not the first word. Try putting the side before, rather than after, "Foldback". If there is only 1 foldback channel, try "Stage Foldback"
-- 3. for subs, include the word "Sub" in each channel's name. This will use the sub soundcheck sound instead of a spoken voice.

set userChannels to "Pros Left, Pros Right, Pros Centre, Sub, Left Foldback, Right Foldback, Upstage Left, Upstage Right, Surround Left, Surround Right"

-- Set file type to save (wav or aiff)
set fileType to ".wav"

-- Set the cue which you want to precede your line check group
set rigCheckTitleCue to "   RIG CHECK"

-- Set the cue list you want to place this group cue in (by default, this is Main Cue List, but you might have a Soundcheck cue list separately)
set mainCueListName to "Main Cue list"

-- Set the level which the audio files will play back at in Qlab. Sub is separate since it is a separate sound.
-- The sub sound should be save, relative to the Qlab file, in "~/Soundcheck/Line Checks"
set userLevel to -6
set subLevel to 0
set subFileName to "Sub v2.wav"

-- Set the delay between each file playing in seconds
set userDelay to 0.5

-- END OF USER DEFINED VARIABLES


-- Automatically get the path to the project
tell application "QLab 4" to tell front workspace
	set qlabPath to path
end tell

tell application "Finder"
	set qlabPathAlias to POSIX file qlabPath as alias
	set qlabParentPath to (container of qlabPathAlias) as alias
end tell

set saveLocation to (POSIX path of qlabParentPath & "Soundcheck/Line Checks/")


-- If the cues already exist, delete them before running the rest of this script:
checkForCues()


-- If the audio files already exist, delete them before running the rest of this script:
checkForFiles(saveLocation, subFileName)


-- Convert userChannels into a list
set theChannels to splitString(userChannels, ", ")

-- Speak output names 
set outputCount to count of theChannels

set chanNum to 0

repeat with eachOutput from 1 to outputCount
	set eachOutputToSay to correctOutputName(item eachOutput of theChannels)
	set chanNum to chanNum + 1
	if eachOutputToSay does not contain "Sub" then
		say (eachOutputToSay) using "Daniel" saving to (POSIX file saveLocation & checkDigits(chanNum, 2) & " " & (item eachOutput of theChannels) as string) & fileType
	else
		set newFileName to (checkDigits(chanNum, 2) & " " & (item eachOutput of theChannels) as string) & fileType
		tell application "Finder"
			set newFile to duplicate file (POSIX file (saveLocation & subFileName) as alias)
			set name of newFile to newFileName
		end tell
	end if
end repeat


-- Import into Qlab

-- Make main cue list a variable
tell application "QLab 4" to tell front workspace
	set mainCueList to (first cue list whose q name is mainCueListName)
	
	-- Get rig check title cue, so it knows where to make these cues
	if rigCheckTitleCue is not "" then
		set current cue list to mainCueList
		set titleCue to (first cue whose q name is rigCheckTitleCue)
		set playback position of mainCueList to titleCue
	end if
	
	-- Make the group
	make type "Group"
	set groupCue to last item of (selected as list)
	set q name of groupCue to "Line Check"
	set mode of groupCue to timeline
end tell

-- Get all files in the linecheck folder
tell application "Finder"
	set saveLocationAlias to POSIX file saveLocation as alias
	delay 1
	set allTheFiles to (entire contents of folder saveLocationAlias)
	set allFiles to items 1 thru -2 of allTheFiles
end tell

-- Create list for later
set lineCheckCues to {}

-- Make audio cues
set outputNumber to 0
tell application "QLab 4" to tell front workspace
	repeat with eachOutput in allFiles
		set outputNumber to outputNumber + 1
		make type "Audio" -- make cue
		set thisCue to last item of (selected as list) -- give the cue a variable
		set file target of thisCue to eachOutput as alias -- add the file to the cue
		set q name of thisCue to item outputNumber of theChannels
		
		-- Put the cue into the group cue
		set thisCueID to uniqueID of thisCue
		try
			move cue id thisCueID of parent of thisCue to end of groupCue
		end try
		my insertItemInList(thisCue, lineCheckCues, outputNumber)
		
		-- Set level of cues as they are made
		if item outputNumber of theChannels contains "Sub" then
			setLevel thisCue row 0 column outputNumber db subLevel
			setLevel thisCue row 1 column outputNumber db 0
		else
			setLevel thisCue row 0 column outputNumber db userLevel
			setLevel thisCue row 1 column outputNumber db 0
		end if
		
		-- Set predelay of cues as they are made
		set previousCue to cue before thisCue
		if outputNumber is not 1 then
			set previousDuration to duration of previousCue
			set previousPreWait to pre wait of previousCue
			set pre wait of thisCue to (previousDuration + previousPreWait + userDelay)
		end if
		
		-- 
	end repeat
	
	collapse groupCue
	
end tell


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

on checkDigits(num, howLong)
	set num to text -howLong thru -1 of ("00" & num)
	return num
end checkDigits

on correctOutputName(outputName)
	if outputName contains "Pros" then
		set newOutputName to findAndReplaceInText(outputName, "Pros", "Proz")
		return newOutputName
	else
		return outputName
	end if
	
end correctOutputName

on findAndReplaceInText(theText, theSearchString, theReplacementString)
	set AppleScript's text item delimiters to theSearchString
	set theTextItems to every text item of theText
	set AppleScript's text item delimiters to theReplacementString
	set theText to theTextItems as string
	set AppleScript's text item delimiters to ""
	return theText
end findAndReplaceInText

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

on checkForCues()
	tell application "QLab 4" to tell front workspace
		set groupCueAlready to ""
		try
			set groupCueAlready to (first cue whose q name is "Line Check")
			set groupCueAlreadyID to uniqueID of groupCueAlready
		end try
		
		if groupCueAlready is not "" then
			delete cue id groupCueAlreadyID of parent of groupCueAlready -- of cue list mainCueList
		end if
	end tell
end checkForCues

on checkForFiles(saveLocation, subFileName)
	tell application "Finder"
		set saveLocationAlias to POSIX file saveLocation as alias
		set startingFolderContents to (entire contents of folder saveLocationAlias)
		if (count of startingFolderContents) is not 1 then
			repeat with eachItem in startingFolderContents
				if name of eachItem is not (subFileName) then
					delete eachItem
				end if
			end repeat
		end if
	end tell
end checkForFiles
