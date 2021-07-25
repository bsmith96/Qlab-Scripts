-- @description Bump cue level +6dB
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Leaves the cue master, and bumps the individual channels (which are not -inf) +6dB
-- @separateprocess TRUE


-- USER DEFINED VARIABLES -----------------

set variableCueListName to "Other scripts & utilities"

set bumpLevel to 3

---------- END OF USER DEFINED VARIABLES --


-- VARIABLES FROM QLAB NOTES --------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	set audioChannelCount to notes of (first cue of (first cue list whose q name is variableCueListName) whose q name is "Output channel count") -- total number of Qlab output
	set minAudioLevel to notes of (first cue of (first cue list whose q name is variableCueListName) whose q name is "Min audio level") as integer -- audio level which is -inf
end tell

------------------ END OF QLAB VARIABLES --


---- RUN SCRIPT ---------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	set selectedCues to (selected as list)
	
	set cueTypes to {"Audio", "Fade", "Video", "Mic"}
	
	repeat with eachCue in selectedCues
		if (q type of eachCue) is in cueTypes then
			repeat with eachChannel from 1 to audioChannelCount
				set oldLevel to getLevel eachCue row 0 column eachChannel
				if oldLevel is not minAudioLevel then
					setLevel eachCue row 0 column eachChannel db (oldLevel + bumpLevel)
				end if
			end repeat
		end if
	end repeat
	
end tell
