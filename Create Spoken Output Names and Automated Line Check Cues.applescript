-- User defined variables

set theChannels to {"Pros Left", "Pros Right", "Pros Center", "Sub", "Left Foldback", "Right Foldback", "Upstage Left", "Upstage Right", "Surround Left", "Surround Right"} -- Input channels manually
set saveLocation to "/Users/Ben/Dropbox/002 GSA - Babe/Data/Qlab/Line Checks/"
set fileType to ".wav"

set userLevel to -6

set userDelay to 0.5 -- delay between each file in seconds

-- Speak output names 
set outputCount to count of theChannels

set chanNum to 0

repeat with eachOutput from 1 to outputCount
	set eachOutputToSay to correctOutputName(item eachOutput of theChannels)
	set chanNum to chanNum + 1
	say (eachOutputToSay) using "Daniel" saving to (POSIX file saveLocation & checkDigits(chanNum, 2) & " " & (item eachOutput of theChannels) as string) & fileType
end repeat


-- Import into Qlab

tell application "QLab 4" to tell front workspace
	-- Make main cue list a variable
	set mainCueList to (first cue list whose q name is "Main Cue List")
	
	-- Get rig check title cue, so it knows where to make these cues
	set current cue list to mainCueList
	set titleCue to (first cue whose q name is "   RIG CHECK")
	set playback position of mainCueList to titleCue
	
	-- Make the group
	make type "Group"
	set groupCue to last item of (selected as list)
	set q name of groupCue to "Line Check"
end tell

-- Get all files in the linecheck folder
tell application "Finder"
	set saveLocationAlias to POSIX file saveLocation as alias
	set allFiles to (entire contents of folder saveLocationAlias)
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
		
		-- Put the cue into the group cue
		set thisCueID to uniqueID of thisCue
		try
			move cue id thisCueID of parent of thisCue to end of groupCue
		end try
		my insertItemInList(thisCue, lineCheckCues, outputNumber)
		
		-- Set level of cues as they are made
		setLevel thisCue row 0 column outputNumber db userLevel
		setLevel thisCue row 1 column outputNumber db 0
		
		-- 
	end repeat
	
end tell


-- Set levels of line check audio files sequentially.


(*tell application "QLab 4" to tell front workspace
	
	--set lineCheckCues to (selected as list)
	
	set lineCheckCount to count of lineCheckCues
	
	set thisCue to 0
	
	repeat with eachCue in lineCheckCues
		
		set thisCue to thisCue + 1
		
		setLevel eachCue row 0 column thisCue db userLevel
		
		repeat with eachOutput from 1 to lineCheckCount
			
			setLevel eachCue row 1 column eachOutput db 0
			
		end repeat
		
	end repeat
	
end tell*)

-- Sped up by putting it in the cue creation loop?



-- Set predelays of line check files in a fire-all-at-once group cue. Select all except the first one and run.


tell application "QLab 4" to tell front workspace
	
	set lineCheckCuesToDelay to rest of lineCheckCues
	--set item 1 of lineCheckCuesToDelay to {}
	
	repeat with currentCue in lineCheckCuesToDelay
		--set currentCue to last item of (selected as list)
		
		set previousCue to cue before currentCue
		
		--start (previousCue)
		
		set previousDuration to duration of previousCue
		
		set previousPreWait to pre wait of previousCue
		
		--display dialog previousDuration
		
		set pre wait of currentCue to (previousDuration + previousPreWait + userDelay)
		
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
