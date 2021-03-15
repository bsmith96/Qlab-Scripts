-- @description Dynamic load to time
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 2.0
-- @about Starts all looping audio that has not been stopped before the currently selected cue

-- @changelog
--   v2.0  + changed approach to avoid starting every single cue
--   v1.0  + init


-- RUN SCRIPT -----------------------------

-- Make list for all cues that have infinite loop
set loopCues to {}
set fadeCues to {}

---- Find all cues before the current selection that loop infinitely
tell application "QLab 4" to tell front workspace
	set theCue to last item of (selected as list)
	set theCueID to uniqueID of theCue
	set allCues to every cue of (first cue list whose q name is "Main Cue List")
	repeat with eachCue in allCues
		
		-- Folder level 0
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
		else if eachCueType is "Fade" and stop target when done of eachCue is true then
			set eachCueTarget to (uniqueID of cue target of eachCue)
			set eachLoopPosition to 1
			repeat with eachLoop in loopCues
				if eachCueTarget is in eachLoop then
					set item eachLoopPosition of loopCues to ""
				end if
				set eachLoopPosition to eachLoopPosition + 1
			end repeat
		else if eachCueType is "Fade" and stop target when done of eachCue is false then
			set eachCueTarget to (uniqueID of cue target of eachCue)
			repeat with eachLoop in loopCues
				if eachCueTarget is in eachLoop then
					insertItemInList(uniqueID of eachCue, fadeCues, 1)
				end if
			end repeat
		else if eachCueType is "Group" then
			
			-- Folder level 1
			set allCues1 to every cue of eachCue
			repeat with eachCue1 in allCues1
				set eachCue1Type to q type of eachCue1
				if eachCue1Type is "Audio" then
					if my checkForLoop(eachCue1) is true then my insertItemInList(uniqueID of eachCue1, loopCues, 1)
				else if eachCue1Type is "Stop" then
					set eachCue1Target to (uniqueID of cue target of eachCue1)
					set eachLoopPosition to 1
					repeat with eachLoop in loopCues
						if eachCue1Target is in eachLoop then
							set item eachLoopPosition of loopCues to ""
						end if
						set eachLoopPosition to eachLoopPosition + 1
					end repeat
				else if eachCue1Type is "Fade" and stop target when done of eachCue1 is true then
					log q name of eachCue1 & stop target when done of eachCue1
					set eachCue1Target to (uniqueID of cue target of eachCue1)
					set eachLoopPosition to 1
					repeat with eachLoop in loopCues
						if eachCue1Target is in eachLoop then
							set item eachLoopPosition of loopCues to ""
						end if
						set eachLoopPosition to eachLoopPosition + 1
					end repeat
				else if eachCue1Type is "Group" then
					
					-- Folder level 2
					set allCues2 to every cue of eachCue1
					repeat with eachCue2 in allCues2
						set eachCue2Type to q type of eachCue2
						if eachCue2Type is "Audio" then
							if my checkForLoop(eachCue2) is true then my insertItemInList(uniqueID of eachCue2, loopCues, 1)
						else if eachCue2Type is "Stop" then
							set eachCue2Target to (uniqueID of cue target of eachCue2)
							set eachLoopPosition to 1
							repeat with eachLoop in loopCues
								if eachCue2Target is in eachLoop then
									set item eachLoopPosition of loopCues to ""
								end if
								set eachLoopPosition to eachLoopPosition + 1
							end repeat
						else if eachCue2Type is "Fade" and stop target when done of eachCue2 is true then
							log q name of eachCue2 & stop target when done of eachCue2
							set eachCue2Target to (uniqueID of cue target of eachCue2)
							set eachLoopPosition to 1
							repeat with eachLoop in loopCues
								if eachCue2Target is in eachLoop then
									set item eachLoopPosition of loopCues to ""
								end if
								set eachLoopPosition to eachLoopPosition + 1
							end repeat
						else if eachCue2Type is "Group" then
							
							-- Folder level 3
							set allCues3 to every cue of eachCue2
							repeat with eachCue3 in allCues3
								set eachCue3Type to q type of eachCue3
								if eachCue3Type is "Audio" then
									if my checkForLoop(eachCue3) is true then my insertItemInList(uniqueID of eachCue3, loopCues, 1)
								else if eachCue3Type is "Stop" then
									set eachCue3Target to (uniqueID of cue target of eachCue3)
									set eachLoopPosition to 1
									repeat with eachLoop in loopCues
										if eachCue3Target is in eachLoop then
											set item eachLoopPosition of loopCues to ""
										end if
										set eachLoopPosition to eachLoopPosition + 1
									end repeat
								else if eachCue3Type is "Fade" and stop target when done of eachCue3 is true then
									log q name of eachCue3 & stop target when done of eachCue3
									set eachCue3Target to (uniqueID of cue target of eachCue3)
									set eachLoopPosition to 1
									repeat with eachLoop in loopCues
										if eachCue3Target is in eachLoop then
											set item eachLoopPosition of loopCues to ""
										end if
										set eachLoopPosition to eachLoopPosition + 1
									end repeat
								else if eachCue3Type is "Group" then
									
									-- Folder level 4
									set allCues4 to every cue of eachCue3
									repeat with eachCue4 in allCues4
										set eachCue4Type to q type of eachCue4
										if eachCue4Type is "Audio" then
											if my checkForLoop(eachCue4) is true then my insertItemInList(uniqueID of eachCue4, loopCues, 1)
										else if eachCue4Type is "Stop" then
											set eachCue4Target to (uniqueID of cue target of eachCue4)
											set eachLoopPosition to 1
											repeat with eachLoop in loopCues
												if eachCue4Target is in eachLoop then
													set item eachLoopPosition of loopCues to ""
												end if
												set eachLoopPosition to eachLoopPosition + 1
											end repeat
										else if eachCue4Type is "Fade" and stop target when done of eachCue4 is true then
											set eachCue4Target to (uniqueID of cue target of eachCue4)
											set eachLoopPosition to 1
											repeat with eachLoop in loopCues
												if eachCue4Target is in eachLoop then
													set item eachLoopPosition of loopCues to ""
												end if
												set eachLoopPosition to eachLoopPosition + 1
											end repeat
										end if
									end repeat
								end if
							end repeat
						end if
					end repeat
				end if
			end repeat
		end if
	end repeat
	log loopCues
	
	-- Start all loop cues that haven't been stopped at the end of their loops
	repeat with eachCue in loopCues
		try
			set eachCue to cue id eachCue
			set groupPreWait to pre wait of eachCue
			set groupDuration to duration of eachCue
			set groupPostWait to post wait of eachCue
			load eachCue time (groupPreWait + groupDuration + groupPostWait)
			start eachCue
		end try
	end repeat
end tell


(*repeat with eachCue in loopCues
	tell application "QLab 4" to tell front workspace
		start cue id eachCue
	end tell
end repeat*)

-- TESTS -----------------------------
(*set theList to {}

tell application "QLab 4" to tell front workspace
	set theCues to (selected as list)
	repeat with eachCue in theCues
		if my checkForLoop(eachCue) is true then my insertItemInList(eachCue, theList, 1)
	end repeat
	log theList
	
	
	
end tell*)

-- FUNCTIONS ------------------------------

-- Check cue for infinite loop

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