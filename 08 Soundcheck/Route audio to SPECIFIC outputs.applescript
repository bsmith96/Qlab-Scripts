-- @description Route audio to SPECIFIC outputs
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Routes the cue output faders to a specific set of outputs, e.g. only Main PA, only Foldback
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

set numberOfOutputs to 10 -- total number of cue outputs in use

set outputsToUse to {1, 2} -- list all output numbers that this script should route to

set userLevel to -12

set thisCueNumber to "LR" -- the cue number of this script
set otherCueNumbers to {"PA", "FB", "US", "Sur"} -- list of the cue numbers of others instances of these scripts

set cueListToRoute to "Soundcheck" -- the name of the soundcheck cue list. If this is blank, it will use selected cues

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4"
	tell front workspace
		
		-- A button to set routing of soundcheck tracks to a specific setup
		-- Set all active channels that need to be off to "-inf", all that need to be on to 0
		-- use row 0 (fader) and columns 1 onwards
		-- Set names for the cues, and q colors at the end of this script: change this button to red and any others to none.
		
		if cueListToRoute is not "" then
			set selectedCues to (cues in (first cue list whose q name is cueListToRoute) as list)
		else
			set selectedCues to (selected as list)
		end if
		
		repeat with eachCue in selectedCues
			set cueType to q type of eachCue
			if cueType is "Audio" then
				
				set currentOutput to 1
				repeat numberOfOutputs times
					if currentOutput is in outputsToUse then
						setLevel eachCue row 0 column currentOutput db userLevel
					else
						setLevel eachCue row 0 column currentOutput db "-inf"
					end if
					set currentOutput to currentOutput + 1
				end repeat
				
			end if
		end repeat
		
		set q color of cue thisCueNumber to "Red"
		
		repeat with eachCue in otherCueNumbers
			set q color of cue eachCue to "none"
		end repeat
		
	end tell
end tell