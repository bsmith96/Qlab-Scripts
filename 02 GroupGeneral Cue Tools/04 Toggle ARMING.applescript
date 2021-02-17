##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

### Toggle ARMING


tell front workspace
	set selectedCues to (selected as list)
	if (count selectedCues) is 0 then -- If no cues are selected arm/disarm the current cue list
		set armed of current cue list to not armed of current cue list
	else
		repeat with eachCue in reverse of selectedCues -- Reversed so as to do a Group Cue's children before it
			set armed of eachCue to not armed of eachCue
		end repeat
	end if
end tell