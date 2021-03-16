-- @description Create fade out
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Create a fade out for the selected audio/video/group cue
-- @separateprocess FALSE

-- @changelog
--   v1.0  + init


tell front workspace
	set originalCue to last item of (selected as list)
	set originalCueType to q type of originalCue

	-- Create fade out for audio or video cues

	if originalCueType is in {"Audio", "Video"} then
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCue
		newCue setLevel row 0 column 0 db -120
		if originalCueType is not "Video" then
			set stop target when done of newCue to true
		end if
		set q name of newCue to "Fade out: " & q name of originalCue

	-- Create fade out for audio or video cues, from a fade cue which targets the original cue

	else if originalCueType is "Fade" then
		set originalCueTarget to cue target of originalCue
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCueTarget
		newCue setLevel row 0 column 0 db -120
		if q type of originalCueTarget is not "Video" then
			set stop target when done of newCue to true
		end if
		set q name of newCue to "Fade out: " & q name of originalCueTarget

	-- Create a fade out for every audio or video cue in a group

	else if originalCueType is "Group" then
		set cuesToFade to (cues in originalCue)
		set originalCueName to q name of originalCue
		make type "Group"
		set fadeGroup to last item of (selected as list)
		set fadeGroupID to uniqueID of fadeGroup
		set q name of fadeGroup to "Fade out: " & originalCueName
		repeat with eachCue in cuesToFade
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