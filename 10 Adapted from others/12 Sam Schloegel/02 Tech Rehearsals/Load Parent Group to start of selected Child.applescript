-- @description Load parent group to start of selected child
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Sam Schloegel
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about When cues are programmed in timeline groups, this script loads the group to the time of the start of the selected cue within the group
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

set userPreRoll to 0.0

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	set theCue to last item of (selected as list)
	set thePre to pre wait of theCue
	set theParent to parent of theCue
	load theParent time (thePre - userPreRoll)
	set playback position of parent list of theParent to cue id (uniqueID of theParent)
end tell