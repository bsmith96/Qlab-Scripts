-- @description Set crosspoints to current default
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about If you need to change the default crosspoints after programming a lot of audio cues, select all audio cues and run this script to set the crosspoints to the new default.
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

set inputChannelCount to 2
set outputChannelCount to 6

---------- END OF USER DEFINED VARIABLES --


tell application "Qlab 4" to tell front workspace

	-- Define variables

	set useCueList to (selected as list)
	set defaultLevels to {}
	

end tell

-- Run script

findDefault(inputChannelCount, outputChannelCount, defaultLevels)
setDefault(inputChannelCount, outputChannelCount, useCueList, defaultLevels)
	

-- FUNCTIONS ------------------------------

on findDefault(inputCount, outputCount, Levels)
	tell application "QLab 4" to tell front workspace
		
		make type "Audio"
		set defaultAudio to last item of (selected as list)
		set q name of defaultAudio to "REFERENCE CUE - DELETE AFTER RUNNING SCRIPT"
		set q color of defaultAudio to "rufous"
		
		repeat with eachRow from 1 to inputCount as integer
			repeat with eachCol from 0 to outputCount as integer
				set thisLevel to getLevel defaultAudio row eachRow column eachCol
				set rowAdjust to (eachRow - 1) * (outputCount + 1)
				if eachRow is 1 then
					set listPosition to eachCol + 1
				else if eachRow is greater than or equal to 2 then
					set listPosition to eachCol + rowAdjust + 1
				end if
				my insertItemInList(thisLevel, Levels, listPosition)
			end repeat
		end repeat
		set defaultAudioID to uniqueID of defaultAudio
		delete cue id defaultAudioID of parent of defaultAudio
	end tell
end findDefault


on setDefault(inputCount, outputCount, cueList, defaultLevels)
	tell application "QLab 4" to tell front workspace
		
		repeat with eachCue in cueList
			if q type of eachCue is "Audio" then
				repeat with eachRow from 1 to inputCount as integer
					repeat with eachCol from 0 to outputCount as integer
						set rowAdjust to (eachRow - 1) * (outputCount + 1)
						if eachRow is 1 then
							set listPosition to eachCol + 1
						else if eachRow is greater than or equal to 2 then
							set listPosition to eachCol + rowAdjust + 1
						end if
						set newValue to (item listPosition of defaultLevels) as integer
						setLevel eachCue row eachRow column eachCol db newValue
					end repeat
				end repeat
			end if
		end repeat
		
	end tell
end setDefault


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