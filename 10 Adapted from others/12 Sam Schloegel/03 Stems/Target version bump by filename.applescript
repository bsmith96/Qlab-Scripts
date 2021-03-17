-- @description Target version bump by filename
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Sam Schloegel
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Retargets selected cues (intended for use with click track stems) from version xx to version xx+1 in the same folder
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

set versionLength to 2 -- How many digits for versioning? v1 / v01, 2 digits recommended

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	set theSelection to (selected as list)
	repeat with eachCue in theSelection
		if q type of eachCue is "Audio" then
			set theName to q name of eachCue
			-- Get POSIX path of current target		
			set theTarget to (file target of eachCue)
			set theTarget to the POSIX path of theTarget
			
			set lastChars to text -6 thru -1 of theTarget
			set thePos to ((6 - ((offset of "." in lastChars) - 2)) * -1)
			set theExt to text (offset of "." in lastChars) thru -1 of lastChars
			set theTrunk to text 1 thru thePos of theTarget
			set oldVersion to (text (versionLength * -1) thru -1 of theTrunk) as integer
			set newVersion to (oldVersion + 1) as string
			if (count newVersion) < versionLength then
				set leadingNeeded to versionLength - (count newVersion)
				repeat leadingNeeded times
					set newVersion to ("0" & newVersion)
				end repeat
			end if
			set newTarget to ((text 1 thru (-1 - versionLength) of theTrunk) & newVersion & theExt)
			
			set file target of eachCue to (POSIX file newTarget)
		end if
	end repeat
end tell
