-- @description Add new section heading
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Adds a memo marker, and a "go-to" cue in the group above to skip it in the cue stack
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

try -- if global variables are given when this script is called by another, use those variables
	userColor
on error
	set userColor to "coral"
end try

---------- END OF USER DEFINED VARIABLES --


-- VARIABLES FROM QLAB NOTES --------------

------------------ END OF QLAB VARIABLES --


property util : script "Applescript Utilities"


---- RUN SCRIPT ---------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	try
		-- save current selection
		set currentCue to last item of (selected as list)
		
		-- check if the current selection is top level, or within a group
		set currentTopLevel to my getTopLevel(currentCue)
		set lastCueBeforeMarker to my getTopLevel(cue before currentTopLevel)
	end try
	
	-- ask for section name
	set sectionName to text returned of (display dialog "What title would you like to use for this section?" with title "Section Name" default answer "")
	
	-- make memo cue
	try
		set selected to lastCueBeforeMarker
	end try
	make type "memo"
	set newCue to last item of (selected as list)
	set q color of newCue to userColor
	set q name of newCue to (do shell script "echo " & sectionName & " | tr [:lower:] [:upper:]")
	
	
	
	try
		-- make goTo cue, to skip the section heading
		set selected to lastCueBeforeMarker
		make type "goTo"
		set goToCue to last item of (selected as list)
		move cue id (uniqueID of goToCue) of parent of goToCue to end of lastCueBeforeMarker
		set cue target of goToCue to currentTopLevel
		
		-- return to original selection
		set selected to currentCue
	end try
	
	
end tell


-- FUNCTIONS ------------------------------

on getTopLevel(theCue)
	tell application id "com.figure53.Qlab.4" to tell front workspace
		if q type of (parent of theCue) is "cue list" then
			return theCue
		else
			my getTopLevel(parent of theCue)
		end if
	end tell
end getTopLevel
