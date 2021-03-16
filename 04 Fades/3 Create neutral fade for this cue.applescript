-- @description Create neutral fade for this cue
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 1.1
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Create a neutral fade cue for the selected audio/video/fade/group cue
-- @separateprocess FALSE

-- @changelog
--   v1.1  + if no cue name, script uses file name
--   v1.0  + init


-- RUN SCRIPT -----------------------------

tell front workspace
	set originalCue to last item of (selected as list)
	set originalCueType to q type of originalCue

	-- Create a fade for an audio or video cue

	if originalCueType is in {"Audio", "Video"} then
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCue
		if q name of originalCue is not "" then
			set q name of newCue to "Fade: " & q name of originalCue
		else
			set originalFile to file target of originalCue as alias
			tell application "System Events"
				set originalName to name of originalFile
			end tell
			set q name of newCue to "Fade: " & originalName
		end if

	-- Create a fade from an audio or video cue, from a fade cue which targets the original cue

	else if originalCueType is "Fade" then
		set originalCueTarget to cue target of originalCue
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCueTarget
		if q name of originalCueTarget is not "" then
			set q name of newCue to "Fade: " & q name of originalCueTarget
		else
			set originalFile to file target of originalCueTarget
			tell application "System Events"
				set originalName to name of originalFile
			end tell
			set q name of newCue to "Fade: " & originalName
		end if
		
	-- Create a fade cue for every audio or video cue inside a group cue

	else if originalCueType is "Group" then
		set cuesToFade to (cues in originalCue)
		set originalCueName to q name of originalCue
		make type "Group"
		set fadeGroup to last item of (selected as list)
		set fadeGroupID to uniqueID of fadeGroup
		set q name of fadeGroup to "Fade: " & originalCueName
		repeat with eachCue in cuesToFade
			if q type of eachCue is in {"Audio", "Video"} then
				try
					make type "Fade"
					set newCue to last item of (selected as list)
					set cue target of newCue to eachCue
					if q name of eachCue is not "" then
						set q name of newCue to "Fade: " & (q name of eachCue)
					else
						set eachFile to file target of eachCue
						tell application "System Events"
							set eachName to name of eachFile
						end tell
						set q name of newCue to "Fade: " & eachName
					end if
					set newCueID to uniqueID of newCue
					move cue id newCueID of parent of newCue to end of fadeGroup
				end try
				
			end if
		end repeat
	end if
end tell