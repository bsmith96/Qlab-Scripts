##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: TRUE

### Route audio to ADDITIONAL outputs
# Requires a cue number for other similar cues to reference

tell application "QLab 4"
	tell front workspace
		
		-- A button to set routing of soundcheck tracks to additional places, or not.
		-- Only adjust the faders that need to change, e.g. foldback, leave the rest as they are.
		-- use row 0 (fader) and columns 1 onwards
		-- Set names for the cue, and q colors in each step of the script, whether it is on or off.
		
		set selectedCues to (cues in (first cue list whose q name is "Soundcheck") as list)
		
		repeat with eachCue in selectedCues
			
			set cueType to q type of eachCue
			if cueType is "Audio" then
				-- Determine whether this button is already active or inactive. Set correct column/s.
				set oldFBLevel to getLevel eachCue row 0 column 4
				
				if oldFBLevel is 0 then
					-- DEACTIVATE send. Set correct column/s. Turns off send.
					setLevel eachCue row 0 column 4 db "-inf"
					set q color of cue "FB" to "none" -- this cue // additional outputs
				else
					-- ACTIVATE send. Set correct column/s. Turns on send.
					setLevel eachCue row 0 column 4 db 0
					set q color of cue "FB" to "cerulean" -- this cue // additional outputs
				end if
				
			end if
			
		end repeat
		
		
		
	end tell
end tell