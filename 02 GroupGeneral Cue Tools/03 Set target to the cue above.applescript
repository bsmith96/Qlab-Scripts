##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

### Set target to the cue above

-- Declarations

set simpleCases to {"Start", "Stop", "Pause", "Reset", "Load", "Goto", "Arm", "Disarm"}
set specialCases to {"Fade", "Animation", "Devamp", "Target"}
set acceptableTargets to {"Audio", "Video", "Audio", "Goto"}

-- Main routine

tell front workspace
	set originalCue to last item of (selected as list)
	set originalType to q type of originalCue
	if originalType is in simpleCases then
		moveSelectionUp
		set targetCue to last item of (selected as list)
		try
			set cue target of originalCue to targetCue
			set targetName to q name of targetCue
			set q name of originalCue to originalType & ": " & targetName
		end try
		moveSelectionDown
	else if originalType is in specialCases then
		repeat with i from 1 to count specialCases
			if originalType is item i of specialCases then
				set acceptableType to item i of acceptableTargets
				exit repeat
			end if
		end repeat
		set foundType to ""
		set moveCounter to 0
		repeat while foundType is not acceptableType
			moveSelectionUp
			set moveCounter to moveCounter + 1
			set targetCue to last item of (selected as list)
			set foundType to q type of targetCue
			if targetCue is first item of cues of current cue list then -- Protect against infinite loop if no acceptable target found
				exit repeat
			end if
		end repeat
		if foundType is acceptableType then -- Don't change the target if we've gone all the way up the cue list without finding one
			set cue target of originalCue to targetCue
			set targetName to q name of targetCue
			set q name of originalCue to originalType & ": " & targetName
		end if
		repeat moveCounter times
			moveSelectionDown
		end repeat
	end if
end tell