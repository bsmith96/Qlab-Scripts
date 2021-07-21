-- @description Create neutral fade for this cue
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 2.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Create a neutral fade cue for the selected audio/video/fade/group cue
-- @separateprocess TRUE

-- @changelog
--   v2.0  + subroutines
--         + doesn't daisychain "Fade xxx: " in group names


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	set originalCue to last item of (selected as list)
	set originalCueType to q type of originalCue

	-- Create a fade for an audio or video cue

	if originalCueType is in {"Audio", "Video"} then
		my createNeutralFade(originalCue)

	-- Create a fade from an audio or video cue, from a fade cue which targets the original cue

	else if originalCueType is "Fade" then
		set originalCueTarget to cue target of originalCue
		my createNeutralFade(originalCueTarget)

	-- Create a fade cue for every audio or video cue inside a group cue

	else if originalCueType is "Group" then
		my createGroup(originalCue)
	end if
end tell


-- FUNCTIONS ------------------------------

on createNeutralFade(theCue)
	tell application id "com.figure53.Qlab.4" to tell front workspace
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to theCue
		set audio fade mode of newCue to relative
		newCue setLevel row 0 column 0 db 0
		set q name of newCue to "Fade: " & q display name of theCue
	end tell
end createNeutralFade

on createGroup(theCue)
	tell application id "com.figure53.Qlab.4" to tell front workspace
		set theCueName to q name of theCue
		set cuesToFade to (cues in theCue)
		make type "Group"
		set fadeGroup to last item of (selected as list)
		set fadeGroupID to uniqueID of fadeGroup
		-- Remove previous "fade" in cue name, if present
		if theCueName starts with "Fade in: " or theCueName starts with "Fade up: " or theCueName starts with "Fade down: " then
			set theCueNameList to my splitString(theCueName, ": ")
			set theCueName to item 2 thru item -1 of theCueNameList
		end if
		set q name of fadeGroup to "Fade: " & theCueName
		repeat with eachCue in cuesToFade
			if q type of eachCue is in {"Audio", "Video"} then
				my createNeutralFade(eachCue)
				set newCue to last item of (selected as list)
				set newCueID to uniqueID of newCue
				move cue id newCueID of parent of newCue to end of fadeGroup
			else if q type of eachCue is in {"Fade"} then
				try
					if q display name of eachCue does not start with "Fade in: " then
						set eachCueTarget to cue target of eachCue
						my createNeutralFade(eachCueTarget)
						set newCue to last item of (selected as list)
						set newCueID to uniqueID of newCue
						move cue id newCueID of parent of newCue to end of fadeGroup
					end if
				end try
			end if
		end repeat
	end tell
end createGroup

on splitString(theString, theDelimiter)
	-- save delimiters to restore old settings
	set oldDelimiters to AppleScript's text item delimiters
	-- set delimiters to delimiter to be used
	set AppleScript's text item delimiters to theDelimiter
	-- create the array
	set theArray to every text item of theString
	-- restore old setting
	set AppleScript's text item delimiters to oldDelimiters
	-- return the array
	return theArray
end splitString