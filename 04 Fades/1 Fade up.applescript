-- @description Fade up
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Create a fade up cue for the selected audio/video/fade/group cue
-- @separateprocess FALSE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

set userDuration to 5
set userLevel to 3
set kindString to "Fade up: "

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

tell front workspace
	set originalCue to last item of (selected as list)
	set originalCueType to q type of originalCue

	-- Make a fade for each audio file in a selected group

	if originalCueType is "Group" then
		set cuesToFade to (cues in originalCue)
		set originalCueName to q name of originalCue
		make type "Group"
		set fadeGroup to last item of (selected as list)
		set fadeGroupID to uniqueID of fadeGroup
		set q name of fadeGroup to kindString & originalCueName
		repeat with eachCue in cuesToFade
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

	-- Make a fade for an audio or video cue

	else if originalCueType is in {"Audio", "Video"} then
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCue
		--set duration of newCue to userDuration
		set currentLevel to originalCue getLevel row 0 column 0
		newCue setLevel row 0 column 0 db (currentLevel + userLevel)
		set q name of newCue to kindString & q name of originalCue

	-- Make a fade for an audio or video cue, from a fade cue which targets the original cue

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