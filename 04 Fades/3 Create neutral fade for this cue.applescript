-- @description Create neutral fade for this cue
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 1.2
-- @testedmacos 10.13.6
-- @testedqlab 4.6.10
-- @about Create a neutral fade cue for the selected audio/video/fade/group cue
-- @separateprocess TRUE

-- @changelog
--   v1.2  + implemented q display name in renaming
--         + runs script in separate process
--         + now uses relative fades
--   v1.1  + if no cue name, script uses file name
--   v1.0  + init


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	set originalCue to last item of (selected as list)
	set originalCueType to q type of originalCue

	-- Create a fade for an audio or video cue

	if originalCueType is in {"Audio", "Video"} then
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCue
		set audio fade mode of newCue to relative
		newCue setLevel row 0 column 0 db 0
		set q name of newCue to "Fade: " & q display name of originalCue

	-- Create a fade from an audio or video cue, from a fade cue which targets the original cue

	else if originalCueType is "Fade" then
		set originalCueTarget to cue target of originalCue
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCueTarget
		set audio fade mode of newCue to relative
		newCue setLevel row 0 column 0 db 0
		set q name of newCue to "Fade: " & q display name of originalCueTarget

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
					set audio fade mode of newCue to relative
					newCue setLevel row 0 column 0 db 0
					set q name of newCue to "Fade: " & (q display name of eachCue)
					set newCueID to uniqueID of newCue
					move cue id newCueID of parent of newCue to end of fadeGroup
				end try
			else if q type of eachCue is "Fade" then
				try
					make type "Fade"
					set newCue to last item of (selected as list)
					set cue target of newCue to (cue target of eachCue)
					set audio fade mode of newCue to relative
					newCue setLevel row 0 column 0 db 0
					set q name of newCue to "Fade: " & (q display name of eachCue)
					set newCueID to uniqueID of newCue
					move cue id newCueID of parent of newCue to end of fadeGroup
				end try
			end if
		end repeat
	end if
end tell