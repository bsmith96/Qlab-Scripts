##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

### Fade up


set userDuration to 5
set userLevel to 3
set kindString to "Fade up: "
tell front workspace
	set originalCue to last item of (selected as list)
	set originalCueType to q type of originalCue
	if originalCueType is "Group" then
		set cuesToFade to (cues in originalCue)
		set originalCueName to q name of originalCue
		make type "Group"
		set fadeGroup to last item of (selected as list)
		set fadeGroupID to uniqueID of fadeGroup
		set q name of fadeGroup to kindString & originalCueName
		repeat with eachCue in cuesToFade
			--set eachCueType to q type of eachCue
			if q type of eachCue is "Audio" then
				try
					make type "Fade"
					set newCue to last item of (selected as list)
					set cue target of newCue to eachCue
					set q name of newCue to kindString & (q name of eachCue)
					set currentLevel to eachCue getLevel row 0 column 0
					newCue setLevel row 0 column 0 db (currentLevel + userLevel)
					set newCueID to uniqueID of newCue
					move cue id newCueID of parent of newCue to end of fadeGroup
				end try
				
			end if
		end repeat
	else if originalCueType is in {"Audio", "Video"} then
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCue
		--set duration of newCue to userDuration
		set currentLevel to originalCue getLevel row 0 column 0
		newCue setLevel row 0 column 0 db (currentLevel + userLevel)
		set q name of newCue to kindString & q name of originalCue
	else if originalCueType is "Fade" then
		set originalCueTarget to cue target of originalCue
		if q type of originalCueTarget is not "Group" then
			make type "Fade"
			set newCue to last item of (selected as list)
			set cue target of newCue to originalCueTarget
			--set duration of newCue to userDuration
			set currentLevel to originalCue getLevel row 0 column 0
			newCue setLevel row 0 column 0 db (currentLevel + userLevel)
			set q name of newCue to kindString & q name of originalCueTarget
		end if
	end if
end tell