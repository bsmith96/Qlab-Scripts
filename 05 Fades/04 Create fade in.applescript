##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

### Create fade in


set userDuration to 5
tell front workspace
	set originalCue to last item of (selected as list)
	if q type of originalCue is "Audio" then
		set originalCueLevel to originalCue getLevel row 0 column 0
		originalCue setLevel row 0 column 0 db -120
		set originalPreWait to pre wait of originalCue
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCue
		set pre wait of newCue to originalPreWait
		--set duration of newCue to userDuration
		newCue setLevel row 0 column 0 db originalCueLevel
		set q name of newCue to "Fade in: " & q name of originalCue
	else if q type of originalCue is "Group" then
		set originalCueName to q name of originalCue
		set cuesToFade to (cues in originalCue)
		make type "Group"
		set fadeGroup to last item of (selected as list)
		set fadeGroupID to uniqueID of fadeGroup
		set q name of fadeGroup to "Fade in: " & originalCueName
		repeat with eachCue in cuesToFade
			--set eachCueType to q type of eachCue
			if q type of eachCue is "Audio" then
				set eachCueLevel to eachCue getLevel row 0 column 0
				eachCue setLevel row 0 column 0 db -120
				set eachPreWait to pre wait of eachCue
				make type "Fade"
				set newCue to last item of (selected as list)
				set cue target of newCue to eachCue
				set pre wait of newCue to eachPreWait
				--set duration of newCue to userDuration
				newCue setLevel row 0 column 0 db eachCueLevel
				set q name of newCue to "Fade in: " & q name of eachCue
				set newCueID to uniqueID of newCue
				move cue id newCueID of parent of newCue to end of fadeGroup
			end if
		end repeat
	end if
end tell