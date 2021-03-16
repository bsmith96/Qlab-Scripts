-- @description Preset to before next cue
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 2.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Starts all looping audio that has not been stopped before the currently selected cue
-- @separateprocess TRUE

-- @changelog
--   v2.0  + changed approach to avoid starting every single cue
--         + works with stopped and fade-and-stopped audio cues and groups
--   v1.0  + init


-- RUN SCRIPT -----------------------------

-- Define lists to add cues to
set loopCues to {} -- adds cues that infinite loop, and removes them as they stop
set fadeCues to {} -- adds cues that fade levels of loopCues, but do not stop them
set groupLoops to {} -- adds group cues that contain loopCues (used within handler)

tell application "QLab 4" to tell front workspace
	set theCue to playback position of (first cue list whose q name is "Main Cue List")
	set theCueID to uniqueID of theCue
	set allCues to every cue of (first cue list whose q name is "Main Cue List")
	
	-- Get a list of all infinite looped audio files that haven't stopped by the current position
	set {loopCues, fadeCues} to my checkForCues(allCues, loopCues, fadeCues, groupLoops, theCueID)
	
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
	repeat with eachCue in reverse of fadeCues
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

on checkForCues(theCues, loopCues, fadeCues, groupLoops, theCueID)
	tell application "QLab 4" to tell front workspace
		repeat with eachCue in theCues
			set eachCueID to uniqueID of eachCue
			
			-- Stop the script once you reach the playhead
			
			if eachCueID is theCueID then exit repeat
			set eachCueType to q type of eachCue
			
			-- If the current cue is an audio cue, check it for infinite loop and add it to the list
			
			if eachCueType is "Audio" then
				if my checkForLoop(eachCue) is true then
					my insertItemInList(uniqueID of eachCue, loopCues, 1)
					set parentCue to parent of eachCue
					repeat while parent of parentCue is not (first cue list whose q name is "Main Cue List")
						my insertItemInList((uniqueID of parent of eachCue), groupLoops, 1)
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
							my insertItemInList(uniqueID of eachCue, fadeCues, 1)
						end if
					end repeat
				end if
				
				-- If the current cue is a group cue, do this handler again (recursive) to look for looping audio cues.
				
			else if eachCueType is "Group" then
				my checkForCues((every cue of eachCue), loopCues, fadeCues, groupLoops, theCueID)
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


on insertItemInList(theItem, theList, thePosition)
	set theListCount to length of theList
	if thePosition is 0 then
		return false
	else if thePosition is less than 0 then
		if (thePosition * -1) is greater than theListCount + 1 then return false
	else
		if thePosition is greater than theListCount + 1 then return false
	end if
	if thePosition is less than 0 then
		if (thePosition * -1) is theListCount + 1 then
			set beginning of theList to theItem
		else
			set theList to reverse of theList
			set thePosition to (thePosition * -1)
			if thePosition is 1 then
				set beginning of theList to theItem
			else if thePosition is (theListCount + 1) then
				set end of theList to theItem
			else
				set theList to (items 1 thru (thePosition - 1) of theList) & theItem & (items thePosition thru -1 of theList)
			end if
			set theList to reverse of theList
		end if
	else
		if thePosition is 1 then
			set beginning of theList to theItem
		else if thePosition is (theListCount + 1) then
			set end of theList to theItem
		else
			set theList to (items 1 thru (thePosition - 1) of theList) & theItem & (items thePosition thru -1 of theList)
		end if
	end if
	return theList
end insertItemInList
