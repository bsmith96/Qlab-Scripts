-- @description Create fade
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 3.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Create a fade down cue for the selected audio/video/fade/group cue
-- @separateprocess TRUE

-- @changelog
--   v3.0  + moved common functions to external script
--   v2.1  + allows assignment of UDVs from the script calling this one
--   v2.0  + subroutines
--         + doesn't daisychain "Fade xxx: " in group names


-- USER DEFINED VARIABLES -----------------

try -- if global variables are given when this script is called by another, use those variables
	userLevel
on error
	set userLevel to -3
end try

try
	userPrefix
on error
	set userPrefix to "Fade down: "
end try

---------- END OF USER DEFINED VARIABLES --


property util : script "Applescript Utilities"


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	set originalCue to last item of (selected as list)
	set originalCueType to q type of originalCue
	
	-- Make a fade for each an audio or video file
	
	if originalCueType is in {"Audio", "Video"} then
		my createFadeDown(originalCue, userLevel, userPrefix)
		
		-- Make a fade for an audio or video cue, from a fade cue which targets the original cue
		
	else if originalCueType is "Fade" then
		set originalCueTarget to cue target of originalCue
		if q type of originalCueTarget is not "Group" then
			my createFadeDown(originalCueTarget, userLevel, userPrefix)
		end if
		
		-- Make a fade for each audio file in a selected group
		
	else if originalCueType is "Group" then
		my createGroup(originalCue, userLevel, userPrefix)
	end if
end tell


-- FUNCTIONS ------------------------------

on createFadeDown(theCue, userLevel, userPrefix)
	tell application id "com.figure53.Qlab.4" to tell front workspace
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to theCue
		set audio fade mode of newCue to relative
		newCue setLevel row 0 column 0 db userLevel
		set q name of newCue to userPrefix & q display name of theCue
	end tell
end createFadeDown

on createGroup(theCue, userLevel, userPrefix)
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
		set q name of fadeGroup to userPrefix & theCueName
		repeat with eachCue in cuesToFade
			if q type of eachCue is in {"Audio", "Video"} then
				my createFadeDown(eachCue, userLevel, userPrefix)
				set newCue to last item of (selected as list)
				set newCueID to uniqueID of newCue
				move cue id newCueID of parent of newCue to end of fadeGroup
			else if q type of eachCue is in {"Fade"} then
				try
					if q display name of eachCue does not start with "Fade in: " then
						set eachCueTarget to cue target of eachCue
						my createFadeDown(eachCueTarget, userLevel, userPrefix)
						set newCue to last item of (selected as list)
						set newCueID to uniqueID of newCue
						move cue id newCueID of parent of newCue to end of fadeGroup
					end if
				end try
			end if
		end repeat
	end tell
end createGroup