-- @description Bump cue level
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.4
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Leaves the cue master, and bumps the individual channels (which are not -inf) +6dB
-- @separateprocess TRUE

-- @changelog
--   v1.4  + avoids duplicating bumps to ganged channels more efficiently
--   v1.3  + no longer errors when no gang was assigned
--   v1.2  + removes gangs temporarily, to avoid duplicate bumps
--   v1.1  + allows assignment of UDVs from the script calling this one


-- USER DEFINED VARIABLES -----------------

try -- if global variables are given when this script is called by another, use those variables
	variableCueListName
on error
	set variableCueListName to "Other scripts & utilities"
end try

try
	bumpLevel
on error
	set bumpLevel to 6
end try

---------- END OF USER DEFINED VARIABLES --


-- VARIABLES FROM QLAB NOTES --------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	set audioChannelCount to notes of (first cue of (first cue list whose q name is variableCueListName) whose q name is "Output channel count") as integer -- total number of Qlab output
	set minAudioLevel to notes of (first cue of (first cue list whose q name is variableCueListName) whose q name is "Min audio level") as integer -- audio level which is -inf
end tell

------------------ END OF QLAB VARIABLES --


---- RUN SCRIPT ---------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	set selectedCues to (selected as list)
	
	set cueTypes to {"Audio", "Fade", "Video", "Mic"}
	
	repeat with eachCue in selectedCues
		if (q type of eachCue) is in cueTypes then
			set allGangs to {}
			repeat with eachChannel from 1 to audioChannelCount as integer
				set oldLevel to getLevel eachCue row 0 column eachChannel
				set newLevel to (oldLevel + bumpLevel)
				if oldLevel is not minAudioLevel then
					set eachGang to getGang eachCue row 0 column eachChannel
					if eachGang is missing value then -- change unganged values
						setLevel eachCue row 0 column eachChannel db newLevel
					else if eachGang is not missing value and eachGang is not in allGangs then -- only change ganged values if they haven't already been changed
						setLevel eachCue row 0 column eachChannel db newLevel
						set end of allGangs to eachGang
					end if
				end if
			end repeat
		end if
	end repeat
	
end tell
