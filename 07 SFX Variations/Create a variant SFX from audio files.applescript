-- @description SFX VARIATIONS: Create a variant SFX from audio files
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 2.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Creates a group of multiple variations of the same SFX, to be armed and disarmed by a selection cue. Uses the audio file name to name the cue
-- @separateprocess TRUE

-- @changelog
--   v2.0  + moved common functions to external script
--   v1.1  + cleaned up unnecessary functions
--   v1.0  + init


property util : script "Applescript Utilities"


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	-- Define variables
	set itemNumber to ""
	set otherFilesPrefix to {}
	
	-- Files should be named with the cue number and the title of the cue, then the actor's full name / full announcement title after a comma. e.g. "ann.eve.1 Opening Announcement, Evening" for an opening announcement
	
	-- Please note the script does not perform any checks to ensure all global information is correct on on the files (variable, number, name)
	
	-- Get files first. Populate arrays with all necessary details.
	
	set audioFilesOne to choose file with prompt "Please select the first audio file to insert into a variation" of type {"public.audio"}
	set audioFiles to choose file with prompt "Please select all other alternate versions" of type {"public.audio"} with multiple selections allowed
	
	-- Decode the name into all the relevant data
	
	-- Get variable information from the first file
	
	set firstFileName to util's getFileName(audioFilesOne)
	
	set fileOneArray to (util's splitString(firstFileName, "."))
	set filePrefixOne to item 1 of fileOneArray
	set filePrefixTwo to item 2 of fileOneArray
	set fileAllThree to item 3 of fileOneArray
	
	set fileOneArrayTwo to (util's splitString(fileAllThree, " "))
	set filePrefixThree to item 1 of fileOneArrayTwo
	set fileName to ""
	
	repeat with eachItem from 2 to (length of fileOneArrayTwo)
		set fileName to fileName & " " & (item eachItem of fileOneArrayTwo)
	end repeat
	
	set fileOneArrayThree to (util's splitString(fileName, ", "))
	set fileName to item 1 of fileOneArrayThree
	
	-- Get variant information from all subsequent files
	repeat with eachFile in audioFiles
		set eachFileName to (util's getFileName(eachFile))
		set eachFileArray to (util's splitString(eachFileName, "."))
		set eachFilePrefixOne to item 1 of eachFileArray
		set eachFilePrefixTwo to item 2 of eachFileArray
		set eachFileAllThree to item 3 of eachFileArray
		
		set eachFileArrayTwo to (util's splitString(eachFileAllThree, " "))
		set eachFilePrefixThree to item 1 of eachFileArrayTwo
		set eachFileName to ""
		
		repeat with eachItem from 2 to (length of eachFileArrayTwo)
			set eachFileName to eachFileName & " " & (item eachItem of eachFileArrayTwo)
		end repeat
		
		set eachFileArrayThree to (util's splitString(eachFileName, ", "))
		set eachFileName to item 1 of eachFileArrayThree
		set end of otherFilesPrefix to eachFilePrefixTwo
		
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
	set actorNameOne to item 2 of (util's splitString(firstFileName, ", "))
	set actorNameOneFinal to item 1 of (util's splitString(actorNameOne, "."))
	set end of actorNameArray to actorNameOneFinal
	repeat with eachFile in audioFiles
		set eachFileName to (util's getFileName(eachFile))
		set eachFileNameArray to (util's splitString(eachFileName, ", "))
		set nextActorName to item 2 of eachFileNameArray
		set nextActorNameFinal to item 1 of (util's splitString(nextActorName, "."))
		set end of actorNameArray to nextActorNameFinal
	end repeat
	
	-- Create the main group
	make type "Group"
	set mainSFXGroup to last item of (selected as list)
	set mode of mainSFXGroup to timeline
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