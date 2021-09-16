-- @description Set crosspoints to current default
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 2.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about If you need to change the default crosspoints after programming a lot of audio cues, select all audio cues and run this script to set the crosspoints to the new default.
-- @separateprocess TRUE

-- @changelog
--   v2.0  + moved common functions to external script


-- USER DEFINED VARIABLES -----------------

set inputChannelCount to 2
set outputChannelCount to 6

---------- END OF USER DEFINED VARIABLES --


property util : script "Applescript Utilities"


---- RUN SCRIPT ---------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	-- Define variables
	
	set useCueList to (selected as list)
	set defaultLevels to {}
	
	
end tell

-- Run script

findDefault(inputChannelCount, outputChannelCount, defaultLevels)
setDefault(inputChannelCount, outputChannelCount, useCueList, defaultLevels)


-- FUNCTIONS ------------------------------

on findDefault(inputCount, outputCount, Levels)
	tell application id "com.figure53.Qlab.4" to tell front workspace
		
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
				util's insertItemInList(thisLevel, Levels, listPosition)
			end repeat
		end repeat
		set defaultAudioID to uniqueID of defaultAudio
		delete cue id defaultAudioID of parent of defaultAudio
	end tell
end findDefault


on setDefault(inputCount, outputCount, cueList, defaultLevels)
	tell application id "com.figure53.Qlab.4" to tell front workspace
		
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