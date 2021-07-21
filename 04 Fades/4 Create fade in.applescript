-- @description Create fade in
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 2.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Create a fade in for the selected audio/group cue
-- @separateprocess TRUE

-- @changelog
--   v2.0  + subroutines
--         + doesn't daisychain "Fade xxx: " in group names


tell application id "com.figure53.Qlab.4" to tell front workspace
	set originalCue to last item of (selected as list)

	-- Create fade in for an audio cue

	if q type of originalCue is "Audio" then
		my createFadein(originalCue)

	-- Create fade in for each audio cue in a selected group

	else if q type of originalCue is "Group" then
		my createGroup(originalCue)
	end if
end tell


-- FUNCTIONS ------------------------------

on createFadeIn(theCue)
	tell application id "com.figure53.Qlab.4" to tell front workspace
		set theCueLevel to theCue getLevel row 0 column 0
		theCue setLevel row 0 column 0 db -120
		set thePreWait to pre wait of theCue
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to theCue
		set pre wait of newCue to thePreWait
		newCue setLevel row 0 column 0 db theCueLevel
		set q name of newCue to "Fade in: " & q display name of theCue
	end tell
end createFadeIn

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
		set q name of fadeGroup to "Fade in: " & theCueName
		repeat with eachCue in cuesToFade
			if q type of eachCue is "Audio" then
				my createFadeIn(eachCue)
				set newCue to last item of (selected as list)
				set newCueID to uniqueID of newCue
				move cue id newCueID of parent of newCue to end of fadeGroup
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