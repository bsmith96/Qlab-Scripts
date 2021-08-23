-- @description Create fade out
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 3.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Create a fade out for the selected audio/video/group cue
-- @separateprocess TRUE

-- @changelog
--   v3.0  + moved common functions to external script
--   v2.0  + subroutines
--         + doesn't daisychain "Fade xxx: " in group names


property util : script "Applescript Utilities"


---- RUN SCRIPT ---------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	set originalCue to last item of (selected as list)
	set originalCueType to q type of originalCue
	
	-- Create fade out for audio or video cues
	
	if originalCueType is in {"Audio", "Video"} then
		my createFadeOut(originalCue)
		
		-- Create fade out for audio or video cues, from a fade cue which targets the original cue
		
	else if originalCueType is "Fade" then
		set originalCueTarget to cue target of originalCue
		my createFadeOut(originalCueTarget)
		
		-- Create a fade out for every audio or video cue in a group
		
	else if originalCueType is "Group" then
		my createGroup(originalCue)
	end if
end tell


-- FUNCTIONS ------------------------------

on createFadeOut(theCue)
	tell application id "com.figure53.Qlab.4" to tell front workspace
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to theCue
		set audio fade mode of newCue to relative
		newCue setLevel row 0 column 0 db -120
		if (q type of theCue) is not "Video" then
			set stop target when done of newCue to true
		end if
		set q name of newCue to "Fade out: " & q display name of theCue
	end tell
end createFadeOut

on createGroup(theCue)
	tell application id "com.figure53.Qlab.4" to tell front workspace
		set theCueName to q name of theCue
		set cuesToFade to (cues in theCue)
		make type "Group"
		set fadeGroup to last item of (selected as list)
		set fadeGroupID to uniqueID of fadeGroup
		-- Remove previous "fade" in cue name, if present
		if theCueName starts with "Fade in: " or theCueName starts with "Fade up: " or theCueName starts with "Fade down: " then
			set theCueNameList to util's splitString(theCueName, ": ")
			set theCueName to items 2 thru -1 of theCueNameList
		end if
		set q name of fadeGroup to "Fade out: " & theCueName
		repeat with eachCue in cuesToFade
			if q type of eachCue is in {"Audio", "Video"} then
				my createFadeOut(eachCue)
				set newCue to last item of (selected as list)
				set newCueID to uniqueID of newCue
				move cue id newCueID of parent of newCue to end of fadeGroup
			else if q type of eachCue is in {"Fade"} then
				try
					if q display name of eachCue does not start with "Fade in: " then
						set eachCueTarget to cue target of eachCue
						my createFadeOut(eachCueTarget)
						set newCue to last item of (selected as list)
						set newCueID to uniqueID of newCue
						move cue id newCueID of parent of newCue to end of fadeGroup
					end if
				end try
			end if
		end repeat
	end tell
end createGroup