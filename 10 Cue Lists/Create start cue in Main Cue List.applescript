-- @description Create start cue in Main Cue List
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 1.1
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Creates a cue at the end of Main Cue List targeting the currently selected cue in another cue list.
-- @separateprocess TRUE

-- @changelog
--   v1.1  + runs in external process
--   v1.0  + init


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
			make type "Start"
			set newCue to last item of (selected as list)
			set cue target of newCue to eachCue
			set nameString to "Start | "
			set eachNumber to q number of eachCue
			set eachName to q display name of eachCue
			set nameString to nameString & eachName
			if originalCueList is not "" then
				set nameString to nameString & " | " & originalCueList
			end if
			set q name of newCue to nameString
			if eachNumber is not "" then
				set q number of newCue to ("s" & eachNumber)
			end if
			
			
		end repeat
		delay 0.5 -- Let you see it
		set current cue list to first cue list whose q name is originalCueList
		set playback position of current cue list to last item of selectedCues
		(* This will maintain the selection (more or less) if "Playback position is always the selected cue" is ON *)
	end if
end tell