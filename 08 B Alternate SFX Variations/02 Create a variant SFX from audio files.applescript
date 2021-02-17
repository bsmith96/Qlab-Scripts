##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: TRUE

### Create a variant SFX from audio files


tell application id "com.figure53.QLab.4" to tell front workspace
	
	set itemNumber to ""
	set otherFilesPrefix to {}
	-- Files should be named with the cue number and the title of the cue, then the actor's full name / full announcement title after a comma. e.g. "ann.eve.1 Opening Announcement, Evening" for an opening announcement
	
	-- Please note the script does not perform any checks to ensure all global information is correct on on the files (variable, number, name)
	
	-- Get files first. Populate arrays with all necessary details.
	
	set audioFilesOne to choose file with prompt "Please select the first audio file to insert into a variation" of type {"public.audio"}
	set audioFiles to choose file with prompt "Please select all other alternate versions" of type {"public.audio"} with multiple selections allowed
	
	-- Decode the name into all the relevant data
	
	-- Get variable information from the first file
	
	set firstFileName to my getFileName(audioFilesOne)
	
	set fileOneArray to (my splitString(firstFileName, "."))
	set filePrefixOne to item 1 of fileOneArray
	set filePrefixTwo to item 2 of fileOneArray
	set fileAllThree to item 3 of fileOneArray
	
	set fileOneArrayTwo to (my splitString(fileAllThree, " "))
	set filePrefixThree to item 1 of fileOneArrayTwo
	set fileName to ""
	
	repeat with eachItem from 2 to (length of fileOneArrayTwo)
		set fileName to fileName & " " & (item eachItem of fileOneArrayTwo)
	end repeat
	
	set fileOneArrayThree to (my splitString(fileName, ", "))
	set fileName to item 1 of fileOneArrayThree
	
	-- Get variant information from all subsequent files
	repeat with eachFile in audioFiles
		set eachFileName to (my getFileName(eachFile))
		set itemNumber to itemNumber + 1
		set eachFileArray to (my splitString(eachFileName, "."))
		set eachFilePrefixOne to item 1 of eachFileArray
		set eachFilePrefixTwo to item 2 of eachFileArray
		set eachFileAllThree to item 3 of eachFileArray
		
		set eachFileArrayTwo to (my splitString(eachFileAllThree, " "))
		set eachFilePrefixThree to item 1 of eachFileArrayTwo
		set eachFileName to ""
		
		repeat with eachItem from 2 to (length of eachFileArrayTwo)
			set eachFileName to eachFileName & " " & (item eachItem of eachFileArrayTwo)
		end repeat
		
		set eachFileArrayThree to (my splitString(eachFileName, ", "))
		set eachFileName to item 1 of eachFileArrayThree
		my insertItemInList(eachFilePrefixTwo, otherFilesPrefix, itemNumber)
		
		-- Check information against the first file
		if eachFilePrefixOne is not equal to filePrefixOne then display dialog "The variable ABBREVIATION for \"" & eachFilePrefixOne & "." & eachFilePrefixTwo & "." & eachFilePrefixThree & " " & eachFileName & "\" is not the same as that in the first file. Would you like to continue? If you do, the abbreviation from the first file will be used" default button "OK" cancel button "Cancel" with title "Abbreviation Inconsistency"
		
		if eachFilePrefixThree is not equal to filePrefixThree then display dialog "The variation NUMBER for \"" & eachFilePrefixOne & "." & eachFilePrefixTwo & "." & eachFilePrefixThree & " " & eachFileName & "\" is not the same as that in the first file. Would you like to continue? If you do, the number from the first file will be used" default button "OK" cancel button "Cancel" with title "Variation Number Inconsistency"
		
		if eachFileName is not equal to fileName then display dialog "The cue NAME for \"" & eachFilePrefixOne & "." & eachFilePrefixTwo & "." & eachFilePrefixThree & " " & eachFileName & "\" is not the same as that in the first file. Would you like to continue? If you do, the name from the first file will be used" default button "OK" cancel button "Cancel" with title "Variation Name Inconsistency"
		
		
	end repeat
	
	
	-- For debugging, the following snippet can be re-enabled. It will display to you the prefix information, and all additional variants, in a dialog, followed by the cue name
	
	(*
	set allVariants to ""
	if (get count of otherFilesPrefix) is greater than 0 then
		repeat with theItem in otherFilesPrefix
			set allVariants to allVariants & " : " & theItem
		end repeat
	end if
	
	

	display dialog filePrefixOne & "/" & filePrefixTwo & "/" & filePrefixThree & "   Other Variants" & allVariants with title "Please check these details"
	display dialog fileName with title "Please check these details: Cue Name" 
	*)
	
	-- Get actor names
	set actorNameArray to {}
	set actorNameOne to item 2 of (my splitString(firstFileName, ", "))
	set actorNameOneFinal to item 1 of (my splitString(actorNameOne, "."))
	my insertItemInList(actorNameOneFinal, actorNameArray, 1)
	set itemNumber to 1
	repeat with eachFile in audioFiles
		set itemNumber to itemNumber + 1
		set eachFileName to (my getFileName(eachFile))
		set eachFileNameArray to (my splitString(eachFileName, ", "))
		set nextActorName to item 2 of eachFileNameArray
		set nextActorNameFinal to item 1 of (my splitString(nextActorName, "."))
		my insertItemInList(nextActorNameFinal, actorNameArray, itemNumber)
	end repeat
	
	-- Create the main group
	make type "Group"
	set mainSFXGroup to last item of (selected as list)
	set mainSFXGroupID to uniqueID of mainSFXGroup
	set q name of mainSFXGroup to fileName
	set q color of mainSFXGroup to "Blue"
	
	-- Create first audio cue
	make type "Audio"
	set audioOne to last item of (selected as list)
	set audioOneID to uniqueID of audioOne
	set q name of audioOne to ((item 1 of actorNameArray) & " | " & fileName) as string
	set q number of audioOne to filePrefixOne & "." & filePrefixTwo & "." & filePrefixThree
	set file target of audioOne to audioFilesOne
	move cue id audioOneID of parent of audioOne to end of mainSFXGroup
	
	-- Create subsequent audio cues
	set itemNumber to 0
	repeat with eachFile in audioFiles
		set itemNumber to itemNumber + 1
		make type "Audio"
		set nextAudio to last item of (selected as list)
		set nextAudioID to uniqueID of nextAudio
		set q name of nextAudio to ((item (itemNumber + 1) of actorNameArray) & " | " & fileName as string)
		set q number of nextAudio to filePrefixOne & "." & (item itemNumber of otherFilesPrefix) & "." & filePrefixThree
		set file target of nextAudio to eachFile
		move cue id nextAudioID of parent of nextAudio to end of mainSFXGroup
	end repeat
	
	
end tell

on getFileName(theFile)
	tell application "Finder"
		set fileName to name of theFile
	end tell
	
end getFileName

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