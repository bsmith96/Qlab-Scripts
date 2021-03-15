-- @description Dynamic load to time
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 2.0
-- @about Starts all looping audio that has not been stopped before the currently selected cue

-- @changelog
--   v2.0  + changed approach to avoid starting every single cue
--   v1.0  + init


-- RUN SCRIPT -----------------------------

set loopCues to {}
set fadeCues to {}

tell application "QLab 4" to tell front workspace
	set theCue to last item of (selected as list)
	set theCueID to uniqueID of theCue
	set allCues to every cue of (first cue list whose q name is "Main Cue List")
	
	set {loopCues, fadeCues} to my checkForCues(allCues, loopCues, fadeCues, theCueID)
	log loopCues
	log fadeCues
	
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

on checkForCues(theCues, loopCues, fadeCues, theCueID)
	tell application "QLab 4" to tell front workspace
		repeat with eachCue in theCues
			set eachCueID to uniqueID of eachCue
			if eachCueID is theCueID then exit repeat
			set eachCueType to q type of eachCue
			if eachCueType is "Audio" then
				if my checkForLoop(eachCue) is true then my insertItemInList(uniqueID of eachCue, loopCues, 1)
			else if eachCueType is "Stop" then
				set eachCueTarget to (uniqueID of cue target of eachCue)
				set eachLoopPosition to 1
				repeat with eachLoop in loopCues
					if eachCueTarget is in eachLoop then
						set item eachLoopPosition of loopCues to ""
					end if
					set eachLoopPosition to eachLoopPosition + 1
				end repeat
			else if eachCueType is "Fade" then
				if stop target when done of eachCue is true then
					set eachCueTarget to (uniqueID of cue target of eachCue)
					set eachLoopPosition to 1
					repeat with eachLoop in loopCues
						if eachCueTarget is in eachLoop then
							set item eachLoopPosition of loopCues to ""
						end if
						set eachLoopPosition to eachLoopPosition + 1
					end repeat
				else if stop target when done of eachCue is false then
					set eachCueTarget to (uniqueID of cue target of eachCue)
					repeat with eachLoop in loopCues
						if eachCueTarget is in eachLoop then
							my insertItemInList(uniqueID of eachCue, fadeCues, 1)
						end if
					end repeat
				end if
			else if eachCueType is "Group" then
				my checkForCues((every cue of eachCue), loopCues, fadeCues, theCueID)
			end if
		end repeat
	end tell
	return {loopCues, fadeCues}
end checkForCues

on checkForLoop(theCue)
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