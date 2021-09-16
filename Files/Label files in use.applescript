-- @description Label files in use
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 1.1
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Labels files referenced by the current qlab file in finder, in a colour of the user's choice
-- @separateprocess TRUE

-- @changelog
--   v1.1  + runs as separate process


-- USER DEFINED VARIABLES -----------------

property defaultColor : "Red"

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

set theColors to {"No color", "Orange", "Red", "Yellow", "Blue", "Purple", "Green", "Gray"}

set userColor to choose from list theColors with title "Which color?" with prompt "Label files with this color:" default items {defaultColor}
repeat with n from 1 to (count theColors)
	if ((item n of theColors) as string) is equal to (userColor as string) then
		set labelColor to n - 1
	end if
end repeat

tell application id "com.figure53.Qlab.4" to tell front workspace
	set mySel to cues
	repeat with myCue in mySel
		if q type of myCue is "Audio" or q type of myCue is "Video" then
			set theFile to file target of myCue
			tell application "Finder"
				set the label index of item theFile to labelColor
			end tell
		end if
	end repeat
end tell