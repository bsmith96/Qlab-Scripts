##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

### Create fade out


set userDuration to 5
tell front workspace
	set originalCue to last item of (selected as list)
	set originalCueType to q type of originalCue
	if originalCueType is in {"Audio", "Video"} then
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCue
		--set duration of newCue to userDuration
		newCue setLevel row 0 column 0 db -120
		if originalCueType is not "Video" then
			set stop target when done of newCue to true
		end if
		set q name of newCue to "Fade out: " & q name of originalCue
	else if originalCueType is "Fade" then
		set originalCueTarget to cue target of originalCue
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCueTarget
		--set duration of newCue to userDuration
		newCue setLevel row 0 column 0 db -120
		if q type of originalCueTarget is not "Video" then
			set stop target when done of newCue to true
		end if
		set q name of newCue to "Fade out: " & q name of originalCueTarget
	else if originalCueType is "Group" then
		set cuesToFade to (cues in originalCue)
		set originalCueName to q name of originalCue
		make type "Group"
		set fadeGroup to last item of (selected as list)
		set fadeGroupID to uniqueID of fadeGroup
		set q name of fadeGroup to "Fade out: " & originalCueName
		repeat with eachCue in cuesToFade
			--set eachCueType to q type of eachCue
			if q type of eachCue is in {"Audio", "Video"} then
				try
					make type "Fade"
					set newCue to last item of (selected as list)
					set cue target of newCue to eachCue
					set q name of newCue to "Fade out: " & (q name of eachCue)
					setLevel newCue row 0 column 0 db -120
					set stop target when done of newCue to true
					set newCueID to uniqueID of newCue
					move cue id newCueID of parent of newCue to end of fadeGroup
				end try
				
			end if
		end repeat
		
	end if
end tell