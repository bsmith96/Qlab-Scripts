-- @description Create spoken line check cues
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.3
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Creates spoken output names and automated line check cues
-- @separateprocess TRUE

-- @changelog
--   v1.3  + creates cues in the correct order
--         + cleaned up "speak output names" loop
--         + recompiling or running the script within qlab no longer throws an error
--   v1.2  + fixed a bug where the wrong recording could be assigned to cues


-- USER DEFINED VARIABLES -----------------

-- Input channel names as a single string, separated by ", ".
-- Some guidance on channel names for the best result:
-- 1. for main PA, using the term "pros" will have its pronunciation corrected.
-- 2. for foldback, the TTS works better if "Foldback" is not the first word. Try putting the side before, rather than after, "Foldback". If there is only 1 foldback channel, try "Stage Foldback"
-- 3. for subs, include the word "Sub" in each channel's name. This will use the sub soundcheck sound instead of a spoken voice.

set userChannels to "Pros Left, Pros Right, Pros Centre, Sub, Left Foldback, Right Foldback, Upstage Left, Upstage Right, Surround Left, Surround Right"

-- Set file type to save (wav or aiff)
set fileType to ".wav"

-- Set the cue which you want to precede your line check group
set rigCheckTitleCue to "   RIG CHECK" -- Leave blank to use the current position

-- Set the cue list you want to place this group cue in
set mainCueListName to "Main Cue list"

-- Set the level which the audio files will play back at in Qlab. Sub is separate since it is a separate sound.
set userLevel to -18
set subLevel to -12

-- Set the name of the sub sound. This should be saved, relative to the Qlab file, in "~/Soundcheck/Line Checks"
set subFileName to "Sub v2.wav"

-- Set the delay between each file playing in seconds
set userDelay to 0.5

---------- END OF USER DEFINED VARIABLES --


---- RUN SCRIPT ---------------------------

-- Get the path to the project
tell application id "com.figure53.Qlab.4" to tell front workspace
	set qlabPath to path
end tell

tell application "Finder"
	set qlabPathAlias to POSIX file qlabPath as alias
	set qlabParentPath to (container of qlabPathAlias) as alias
end tell

set saveLocation to (POSIX path of qlabParentPath & "Soundcheck/Line Checks/")

-- Set current cue list to the Main Cue List.
tell application id "com.figure53.Qlab.4" to tell front workspace
	set current cue list to first cue list whose q name is mainCueListName
end tell


-- If the cues already exist, delete them before running the rest of this script:
checkForCues()


-- If the audio files already exist, delete them before running the rest of this script:
checkForFiles(saveLocation, subFileName)


-- Convert userChannels into a list
set theChannels to splitString(userChannels, ", ")

-- Speak output names
set outputCount to count of theChannels

repeat with eachOutput from 1 to outputCount
	set eachOutputToSay to correctOutputName(item eachOutput of theChannels)
	if eachOutputToSay does not contain "Sub" then
		say (eachOutputToSay) using "Daniel" saving to (POSIX file saveLocation & checkDigits(eachOutput, 2) & " " & (item eachOutput of theChannels) as string) & fileType
	else
		set newFileName to (checkDigits(eachOutput, 2) & " " & (item eachOutput of theChannels) as string) & fileType
		tell application "Finder"
			set newFile to duplicate file (POSIX file (saveLocation & subFileName) as alias)
			set name of newFile to newFileName
		end tell
	end if
end repeat


---- Import into Qlab

-- Make main cue list a variable
tell application id "com.figure53.Qlab.4" to tell front workspace
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
end tell

-- Make audio cues
tell application id "com.figure53.Qlab.4" to tell front workspace
	repeat with eachOutput in my sortList(allTheFiles)
		if q number of eachOutput is not subFileName then
			set eachOutputName to my getOutputName(eachOutput)
			set eachOutputNumber to my getOutputNumber(eachOutput)
			make type "Audio" -- make cue
			set thisCue to last item of (selected as list) -- give the cue a variable
			set file target of thisCue to eachOutput as alias -- add the file to the cue
			set q name of thisCue to eachOutputName
			
			-- Put the cue into the group cue
			set thisCueID to uniqueID of thisCue
			try
				move cue id thisCueID of parent of thisCue to end of groupCue
			end try
			
			-- Set level of cues as they are made
			repeat with eachColumn from 1 to outputCount
				if eachColumn is eachOutputNumber then
					if item eachOutputNumber of theChannels contains "Sub" then
						setLevel thisCue row 0 column eachColumn db subLevel
						setLevel thisCue row 1 column eachColumn db 0
					else
						setLevel thisCue row 0 column eachColumn db userLevel
						setLevel thisCue row 1 column eachColumn db 0
					end if
				else
					setLevel thisCue row 0 column eachColumn db "-inf"
				end if
			end repeat
			
			-- Set predelay of cues as they are made
			set previousCue to cue before thisCue
			if eachOutputNumber is not 1 then
				set previousDuration to duration of previousCue
				set previousPreWait to pre wait of previousCue
				set pre wait of thisCue to (previousDuration + previousPreWait + userDelay)
			end if
		end if
	end repeat
	
	-- Brief delay to let the user see the completed cue stack
	delay 0.5
	collapse groupCue
	
end tell


-- FUNCTIONS ------------------------------

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

-- Checks for cues and deletes them if they're already present

on checkForCues()
	tell application id "com.figure53.Qlab.4" to tell front workspace
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

-- Checks for audio files and deletes them if they're already present

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

-- Sort the list of files before creating cues

on sortList(theList)
	set the indexList to {}
	set the sortedList to {}
	set theListNames to {}
	set sortedListNames to {}
	
	-- Create a list with the names of the files
	repeat with i from 1 to (count of theList)
		set eachItem to item i of theList
		tell application "Finder"
			set end of theListNames to (name of eachItem as string)
		end tell
	end repeat
	
	-- Sort the list of filenames alphabetically (by output number)
	repeat (the number of items in theListNames) times
		set the lowItem to ""
		repeat with i from 1 to (number of items in theListNames)
			if i is not in the indexList then
				set thisItem to item i of theListNames
				if the lowItem is "" then
					set the lowItem to thisItem
					set the lowItemIndex to i
				else if thisItem comes before the lowItem then
					set the lowItem to thisItem
					set the lowItemIndex to i
				end if
			end if
		end repeat
		set the end of sortedListNames to the lowItem
		set the end of the indexList to the lowItemIndex
	end repeat
	
	-- Use the index list to create a sorted list of the files themselves
	repeat with eachItem in indexList
		set end of sortedList to item eachItem of theList
	end repeat
	
	return the sortedList
end sortList

-- Gets the output name from the file name. Hopefully useful if the list is not in the correct order.

on getOutputName(theFile)
	tell application "Finder"
		set fileName to name of theFile
	end tell
	set nameWithoutExtension to splitString(fileName, ".")
	set nameAsList to splitString(item 1 of nameWithoutExtension, "")
	set outputList to items 4 thru -1 of nameAsList as string
	return outputList
end getOutputName

-- Gets the output number from the file name. Similarly (hopefully) useful if the list is not in the correct order. 

on getOutputNumber(theFile)
	tell application "Finder"
		set fileName to name of theFile
	end tell
	set nameAsList to splitString(items 1 thru 2 of fileName, "")
	set outputNumber to item 1 of nameAsList & item 2 of nameAsList as number
	return outputNumber
end getOutputNumber