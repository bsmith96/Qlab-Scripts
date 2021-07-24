-- @description Move to cut list
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Sam Schloegel (adapted)
-- @version 2.2
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Moves the selected cues to a cut cue list, and removes their cue number
-- @separateprocess TRUE

-- @changelog
--   v2.2  + successfully cuts cues without a cue number again
--   v2.1  + does not allow valid numbers to remain in the cut list
--   v2.0  + creates cue list if needed, renumbered


-- USER DEFINED VARIABLES -----------------

set cutListName to "Cut Cues"

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	set theSelection to (selected as list)
	
	-- Create cue list if necessary, or switch to it
	try
		set cutList to first cue list whose q name is cutListName
	on error
		make type "cue list"
		set cutList to first cue list whose q name is "Cue list"
		set q name of cutList to cutListName
		set q color of cutList to "scarlet"
		collapse cutList
	end try
	
	repeat with eachCue in theSelection
		if q number of eachCue is not "" then
			set originalCueNumber to q number of eachCue
			set q name of eachCue to ("(" & q number of eachCue & ") " & q list name of eachCue)
			set q number of eachCue to "x" & originalCueNumber
		end if
		
		try
			if q number of eachCue is originalCueNumber then -- if duplicate numbers are cut, avoids leaving those numbers valid
				set q number of eachCue to ""
			end if
		end try
		
		set cueID to uniqueID of eachCue
		set midi trigger of eachCue to disabled
		set hotkey trigger of eachCue to disabled
		set timecode trigger of eachCue to disabled
		set wall clock trigger of eachCue to disabled
		set armed of eachCue to false
		if parent list of eachCue is not cutList then
			move cue id cueID of parent of eachCue to end of cutList
		end if
	end repeat
end tell