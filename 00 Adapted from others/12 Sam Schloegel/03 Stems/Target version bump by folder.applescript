-- @description Target version bump by folder
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Sam Schloegel
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Retargets selected cues (intended for use with click track stems) to files with the same names in a different, user defined folder
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

set versionLength to 2 -- How many digits for versioning? v1 / v01

-- Do not use slashes in your filenames

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	set theSelection to (selected as list)
	
	set theFolder to the POSIX path of (choose folder with prompt "lead me to your files")
	
	repeat with eachCue in theSelection
		if q type of eachCue is "Audio" then
			set theName to q name of eachCue
			-- Get POSIX path of current target		
			set theTarget to (file target of eachCue)
			set theTarget to the POSIX path of theTarget
			set reversed to reverse of characters of theTarget as string
			set fileName to text (1 - (offset of "/" in reversed)) thru -1 of theTarget
			set newTarget to theFolder & fileName
			set file target of eachCue to (POSIX file newTarget)
		end if
	end repeat
	
end tell
