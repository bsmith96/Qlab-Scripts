-- @description Fade down
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 1.1
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Create a fade down cue for the selected audio/video/fade/group cue
-- @separateprocess FALSE

-- @changelog
--   v1.1  + if no cue name, script uses file name
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

set userLevel to -3
set kindString to "Fade down: "

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
					if q name of eachCue is not "" then
						set q name of newCue to kindString & (q name of eachCue)
					else
						set eachFile to file target of eachCue as alias
						tell application "System Events"
							set eachName to name of eachFile
						end tell
						set q name of newCue to kindString & eachName
					end if
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
		set currentLevel to originalCue getLevel row 0 column 0
		newCue setLevel row 0 column 0 db (currentLevel + userLevel)
		if q name of originalCue is not "" then
			set q name of newCue to kindString & q name of originalCue
		else
			set originalFile to file target of originalCue as alias
			tell application "System Events"
				set originalName to name of originalFile
			end tell
			set q name of newCue to kindString & originalName
		end if

	-- Make a fade for an audio or video cue, from a fade cue which targets the original cue

	else if originalCueType is "Fade" then
		set originalCueTarget to cue target of originalCue
		if q type of originalCueTarget is not "Group" then
			make type "Fade"
			set newCue to last item of (selected as list)
			set cue target of newCue to originalCueTarget
			set currentLevel to originalCue getLevel row 0 column 0
			newCue setLevel row 0 column 0 db (currentLevel + userLevel)
			if q name of originalCueTarget is not "" then
				set q name of newCue to kindString & q name of originalCueTarget
			else
				set originalFile to file target of originalCueTarget as alias
				tell application "System Events"
					set originalName to name of originalFile
				end tell
				set q name of newCue to kindString & originalName
			end if
		end if
	end if
end tell
