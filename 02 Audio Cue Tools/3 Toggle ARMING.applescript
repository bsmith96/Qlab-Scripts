-- @description Toggle arming
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 1.1
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Toggles the arm state of selected cues
-- @separateprocess TRUE

-- @changelog
--   v1.1  + runs as separate process


tell application id "com.figure53.Qlab.4" to tell front workspace
	set selectedCues to (selected as list)
	if (count selectedCues) is 0 then -- If no cues are selected arm/disarm the current cue list
		set armed of current cue list to not armed of current cue list
	else
		repeat with eachCue in reverse of selectedCues -- Reversed so as to do a Group Cue's children before it
			set armed of eachCue to not armed of eachCue
		end repeat
	end if
end tell