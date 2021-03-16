-- @description Select cues which use output x
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Sam Schloegel
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Of the selection, leaves only cues selected which are routed to a particular output
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

set userThresh to -60

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.qlab.4" to tell front workspace
	set theSelection to (selected as list)
	set theList to {}
	set theOut to (display dialog "Which cue output?" default answer "1" buttons {"Cancel", "Go"} default button "Go")
	
	if button returned of theOut is "Go" and text returned of theOut is not "" then
		set theOut to (text returned of theOut as integer)
		repeat with eachCue in theSelection
			if q type of eachCue is in {"Audio", "Fade", "Mic"} and ((getLevel eachCue row 0 column theOut) > userThresh) then
				set end of theList to eachCue
			end if
		end repeat
		set selected to theList
		display alert ((length of theList as string) & " of " & (length of theSelection as string) & " cues were found and selected")
		
	end if
end tell