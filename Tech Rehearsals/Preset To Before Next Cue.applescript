-- @description Preset to before next cue
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 2.2
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Starts all looping audio that has not been stopped before the currently selected cue
-- @separateprocess TRUE

-- @changelog
--   v2.2  + allows assignment of UDVs from the script calling this one
--   v2.1  + cue list name is a variable
--         + removed unnecessary function
--   v2.0  + changed approach to avoid starting every single cue
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

try -- if global variables are given when this script is called by another, use those variables
	cueListName
on error
	set cueListName to "Main Cue List"
end try

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

-- Define lists to add cues to
set loopCues to {} -- adds cues that infinite loop, and removes them as they stop
set fadeCues to {} -- adds cues that fade levels of loopCues, but do not stop them
set groupLoops to {} -- adds group cues that contain loopCues (used within handler)

tell application id "com.figure53.Qlab.4" to tell front workspace
	set theCue to playback position of (first cue list whose q name is cueListName)
	set theCueID to uniqueID of theCue
	set allCues to every cue of (first cue list whose q name is cueListName)
	
	-- Get a list of all infinite looped audio files that haven't stopped by the current position
	set {loopCues, fadeCues} to my checkForCues(allCues, loopCues, fadeCues, groupLoops, theCueID, cueListName)
	
	-- Start all infinite loop cues at their loop
	repeat with eachCue in loopCues
		try
			set eachCue to cue id eachCue
			set cuePreWait to pre wait of eachCue
			set cueDuration to duration of eachCue
			set cuePostWait to post wait of eachCue
			load eachCue time (cuePreWait + cueDuration + cuePostWait)
			start eachCue
		end try
	end repeat
	
	-- Start all fades of of infinite loop cues at the end of their duration, setting the final level of fade ins or builds/dips
	repeat with eachCue in fadeCues
		try
			set eachCue to cue id eachCue
			set cuePreWait to pre wait of eachCue
			set cueDuration to duration of eachCue
			set cuePostWait to post wait of eachCue
			load eachCue time (cuePreWait + cueDuration + cuePostWait)
			start eachCue
		end try
	end repeat
end tell


-- FUNCTIONS ------------------------------

on checkForCues(theCues, loopCues, fadeCues, groupLoops, theCueID, cueListName)
	tell application id "com.figure53.Qlab.4" to tell front workspace
		repeat with eachCue in theCues
			set eachCueID to uniqueID of eachCue
			
			-- Stop the script once you reach the playhead
			
			if eachCueID is theCueID then exit repeat
			set eachCueType to q type of eachCue
			
			-- If the current cue is an audio cue, check it for infinite loop and add it to the list
			
			if eachCueType is "Audio" then
				if my checkForLoop(eachCue) is true then
					--my insertItemInList(uniqueID of eachCue, loopCues, 1)
					set end of loopCues to (uniqueID of eachCue)
					set parentCue to parent of eachCue
					repeat while parent of parentCue is not (first cue list whose q name is cueListName)
						--my insertItemInList((uniqueID of parent of eachCue), groupLoops, 1)
						set end of groupLoops to (uniqueID of parent of eachCue)
						set parentCue to parent of parentCue
					end repeat
				end if
				
				-- If the current cue is a stop cue, check if it targets any looping cues. If it does, remove the looping cue from the list.
				
			else if eachCueType is "Stop" then
				set eachCueTarget to (uniqueID of cue target of eachCue)
				set eachLoopPosition to 1
				repeat with eachLoop in loopCues
					if eachCueTarget is in eachLoop then
						set item eachLoopPosition of loopCues to ""
					end if
					repeat with eachGroup in groupLoops
						if eachCueTarget is in groupLoops then
							set item eachLoopPosition of loopCues to ""
						end if
					end repeat
					set eachLoopPosition to eachLoopPosition + 1
				end repeat
				
				-- If the current cue is a fade cue, check if it targets any looping cues.
				
			else if eachCueType is "Fade" then
				
				-- If the current cue stops a looping cue, remove that looping cue from the list.
				
				if stop target when done of eachCue is true then
					set eachCueTarget to (uniqueID of cue target of eachCue)
					set eachLoopPosition to 1
					repeat with eachLoop in loopCues
						if eachCueTarget is in eachLoop then
							set item eachLoopPosition of loopCues to ""
						end if
						repeat with eachGroup in groupLoops
							if eachCueTarget is in groupLoops then
								set item eachLoopPosition of loopCues to ""
							end if
						end repeat
						set eachLoopPosition to eachLoopPosition + 1
					end repeat
					
					-- If the current cue targets a looping cue but does not stop it, add it to the fadeCues list.
					
				else if stop target when done of eachCue is false then
					set eachCueTarget to (uniqueID of cue target of eachCue)
					repeat with eachLoop in loopCues
						if eachCueTarget is in eachLoop then
							--my insertItemInList(uniqueID of eachCue, fadeCues, 1)
							set end of fadeCues to (uniqueID of eachCue)
						end if
					end repeat
				end if
				
				-- If the current cue is a group cue, do this handler again (recursive) to look for looping audio cues.
				
			else if eachCueType is "Group" then
				my checkForCues((every cue of eachCue), loopCues, fadeCues, groupLoops, theCueID, cueListName)
			end if
		end repeat
	end tell
	return {loopCues, fadeCues}
end checkForCues


on checkForLoop(theCue) -- returns true or false
	tell application id "com.figure53.Qlab.4" to tell front workspace
		set theCueType to q type of theCue
		if theCueType is "Audio" then
			set theCueLoop to (infinite loop of theCue)
			log q name of theCue & "  -  " & theCueLoop
			return theCueLoop
		end if
	end tell
end checkForLoop