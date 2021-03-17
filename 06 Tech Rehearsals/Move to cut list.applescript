-- @description Move to cut list
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Sam Schloegel (adapted)
-- @version 2.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Moves the selected cues to a cut cue list, and removes their cue number
-- @separateprocess TRUE

-- @changelog
--   v2.0  + creates cue list if needed, renumbered
--   v1.0  + init


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
			set q name of eachCue to ("(" & q number of eachCue & ") " & q list name of eachCue)
			set q number of eachCue to "x" & q number of eachCue
		end if
		
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