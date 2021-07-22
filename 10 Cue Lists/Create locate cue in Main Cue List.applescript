-- @description Create a locate cue in Main Cue List
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Create a cue in the Main Cue List to locate another cue list to a specific point
-- @separateprocess TRUE


-- USER DEFINED VARIABLES -----------------

set userCueList to "Main Cue List"

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	set originalCueList to q name of current cue list
	if originalCueList is not userCueList then
		set selectedCues to selected as list
		set current cue list to first cue list whose q name is userCueList
		repeat with eachCue in selectedCues
			make type "GoTo"
			set newCue to last item of (selected as list)
			set cue target of newCue to eachCue
			set nameString to "Locate | "
			set eachNumber to q number of eachCue
			set eachName to q display name of eachCue
			set nameString to nameString & eachName
			if originalCueList is not "" then
				set nameString to nameString & " | " & originalCueList
			end if
			set q name of newCue to nameString
		end repeat
		delay 0.5
		set current cue list to first cue list whose q name is originalCueList
		set playback position of current cue list to last item of selectedCues
	end if
end tell