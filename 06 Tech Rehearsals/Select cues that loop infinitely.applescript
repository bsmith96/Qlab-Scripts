-- @description Select cues that loop infinitely
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Of the selection, leaves only cues selected which have infinite loop set to true
-- separateprocess TRUE

-- @changelog
--   v1.0  + init


tell application id "com.figure53.Qlab.4" to tell front workspace
	set theSelection to (selected as list)
	set theList to {}
	
	repeat with eachCue in theSelection
		if q type of eachCue is "Audio" and infinite loop of eachCue is true then
			set end of theList to eachCue
		end if
		set selected to theList
	end repeat
	
	display notification ((length of theList as string) & " of " & (length of theSelection as string) & " cues were found and selected") with title "Infinite loop"
end tell