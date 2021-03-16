-- @description Route audio to ADDITIONAL outputs
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Routes the cue output faders to additional sets of outputs, e.g. Foldback, Delays, Reverbs
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

set numberOfOutputs to 10 -- total number of cue outputs in use

set outputsToAdd to {5, 6} -- list all output numbers that this script to affect routing to

set userLevel to -12

set thisCueNumber to "FB"
set otherCueNumbers to {"LR", "PA", "US", "Sur"} -- list of the cue numbers of other instances of these scripts

set cueListToRoute to "Soundcheck" -- the name of the soundcheck cue list. If this is blank, it will use selected cues

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

tell application "QLab 4"
	tell front workspace
		
		-- A button to set routing of soundcheck tracks to additional places, or not.
		-- Only adjust the faders that need to change, e.g. foldback, leave the rest as they are.
		-- use row 0 (fader) and columns 1 onwards
		-- Set names for the cue, and q colors in each step of the script, whether it is on or off.
		
		-- Define variable
		
		set oldLevel to {}
		
		-- Run script
		
		if cueListToRoute is not "" then
			set selectedCues to (cues in (first cue list whose q name is cueListToRoute) as list)
		else
			set selectedCues to (selected as list)
		end if
		
		repeat with eachCue in selectedCues
			set cueType to q type of eachCue
			if cueType is "Audio" then
				
				-- Determine whether this button is already active or inactive. Set correct column/s.		
				
				set currentOutput to 1
				repeat with eachOutput in outputsToAdd
					set oldOutputLevel to getLevel eachCue row 0 column eachOutput as number
					set end of oldLevel to oldOutputLevel
					set currentOutput to currentOutput + 1
				end repeat
				
				repeat with eachLevel in oldLevel
					if eachLevel is greater than -60 then
						set isActive to true
					else
						set isActive to false
					end if
				end repeat
				
				if isActive is true then
					
					-- DEACTIVATE send. Set correct column/s. Turns off send.
					repeat with eachOutput in outputsToAdd
						setLevel eachCue row 0 column eachOutput db "-inf"
					end repeat
					set q color of cue thisCueNumber to "none"
					
				else if isActive is false then
					
					-- ACTIVATE send. Set correct column/s. Turns on send.
					repeat with eachOutput in outputsToAdd
						setLevel eachCue row 0 column eachOutput db userLevel
					end repeat
					set q color of cue thisCueNumber to "cerulean"
					
				end if
				
			end if
			
		end repeat
		
	end tell
end tell