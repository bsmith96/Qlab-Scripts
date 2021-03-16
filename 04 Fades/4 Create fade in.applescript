-- @description Create fade in
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 1.1
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Create a fade in for the selected audio/group cue
-- @separateprocess FALSE

-- @changelog
--   v1.1  + if no cue name, script uses file name
--   v1.0  + init


tell front workspace
	set originalCue to last item of (selected as list)

	-- Create fade in for an audio cue

	if q type of originalCue is "Audio" then
		set originalCueLevel to originalCue getLevel row 0 column 0
		originalCue setLevel row 0 column 0 db -120
		set originalPreWait to pre wait of originalCue
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCue
		set pre wait of newCue to originalPreWait
		newCue setLevel row 0 column 0 db originalCueLevel
		if q name of originalCue is not "" then
			set q name of newCue to "Fade in: " & q name of originalCue
		else
			set originalFile to file target of originalCue
			tell application "System Events"
				set originalName to name of originalFile
			end tell
			set q name of newCue to "Fade in: " & originalName
		end if

	-- Create fade in for each audio cue in a selected group

	else if q type of originalCue is "Group" then
		set originalCueName to q name of originalCue
		set cuesToFade to (cues in originalCue)
		make type "Group"
		set fadeGroup to last item of (selected as list)
		set fadeGroupID to uniqueID of fadeGroup
		set q name of fadeGroup to "Fade in: " & originalCueName
		repeat with eachCue in cuesToFade
			if q type of eachCue is "Audio" then
				set eachCueLevel to eachCue getLevel row 0 column 0
				eachCue setLevel row 0 column 0 db -120
				set eachPreWait to pre wait of eachCue
				make type "Fade"
				set newCue to last item of (selected as list)
				set cue target of newCue to eachCue
				set pre wait of newCue to eachPreWait
				newCue setLevel row 0 column 0 db eachCueLevel
				if q name of eachCue is not "" then
					set q name of newCue to "Fade in: " & q name of eachCue
				else
					set eachFile to file target of eachCue
					tell application "System Events"
						set eachName to name of eachFile
					end tell
					set q name of newCue to "Fade in: " & eachName
				end if
				set newCueID to uniqueID of newCue
				move cue id newCueID of parent of newCue to end of fadeGroup
			end if
		end repeat
	end if
end tell