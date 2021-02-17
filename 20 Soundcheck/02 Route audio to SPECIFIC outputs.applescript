##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
####ÊRun in separate process: TRUE

### Route audio to SPECIFIC outputs
# Requires a cue number for other similar cues to reference


tell application "QLab 4"
	tell front workspace
		
		-- A button to set routing of soundcheck tracks to a specific setup
		-- Set all active channels that need to be off to "-inf", all that need to be on to 0
		-- use row 0 (fader) and columns 1 onwards
		-- Set names for the cues, and q colors at the end of this script: change this button to red and any others to none.
		
		set selectedCues to (cues in (first cue list whose q name is "Soundcheck") as list)
		
		repeat with eachCue in selectedCues
			
			set cueType to q type of eachCue
			if cueType is "Audio" then
				
				setLevel eachCue row 0 column 1 db "-inf"
				setLevel eachCue row 0 column 2 db "-inf"
				setLevel eachCue row 0 column 3 db "-inf"
				setLevel eachCue row 0 column 4 db "-inf"
				setLevel eachCue row 0 column 5 db "-inf"
				
				setLevel eachCue row 0 column 6 db 0
				
			end if
			
		end repeat
		
		set q color of cue "SC" to "red" -- this cue // specific outputs
		set q color of cue "PA" to "none" -- // specific outputs
		set q color of cue "FB" to "none" -- // additional outputs
		set q color of cue "Rv" to "none" -- // additional outputs
		
	end tell
end tell