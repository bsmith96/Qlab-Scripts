-- @description Create CL/QL scene recall
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.1
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Creates a midi cue to recall a scene on Yamaha CL/QL mixing desks
-- @separateprocess TRUE

-- @changelog
--   v1.1  + can now colour parent groups
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

set userColor to "green"

set colorParentGroups to TRUE -- set colour of any groups containing the recall group as well?

set cueListName to "Main Cue List" -- Name of main cue list

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	-- set scene number to recall
	display dialog "Please select a scene number to recall" default answer "" buttons {"Set", "Cancel"} cancel button "Cancel" default button "Set" with title "SCENE NUMBER"
	set sceneNumber to text returned of result as integer
	
	-- Calculate variables to use in the midi cue
	set chanNum to my calculateChan(sceneNumber)
	set sceneNum to my calculateScene(sceneNumber)
	
	set sceneGroupName to "Scene " & sceneNumber
	
	-- Make overall group
	make type "Group"
	set sceneGroup to last item of (selected as list)
	set sceneGroupID to uniqueID of sceneGroup
	set mode of sceneGroup to timeline
	set q name of sceneGroup to sceneGroupName
	
	-- Make the midi program cue
	make type "Midi"
	set midiBank to last item of (selected as list)
	set midiBankID to uniqueID of midiBank
	set message type of midiBank to voice
	set command of midiBank to program_change
	set channel of midiBank to chanNum
	set byte one of midiBank to sceneNum
	move cue id midiBankID of parent of midiBank to end of sceneGroup
	set q name of midiBank to "Scene " & sceneNumber & ": Program Change"
	
	-- Color the group and any groups containing the group
	set q color of sceneGroup to userColor

	if colorParentGroups is TRUE
		set groupParent to parent of sceneGroup
		repeat
			if q name of groupParent is cueListName then
				exit repeat
			else
				set q color of groupParent to userColor
				set groupParent to parent of groupParent
			end if
		end repeat
	end if

	collapse sceneGroup
	
end tell


-- FUNCTIONS ------------------------------

-- Function to calculate the midi channel (used as a bank)
on calculateChan(num)
	set chan to integer
	if num is less than 129 then
		set chan to 1
	else if num is greater than 128 and num is less than 256 then
		set chan to 2
	else if num is greater than 255 and num is less than 383 then
		set chan to 3
	else if num is greater than 382 and num is less than 508 then
		set chan to 4
	end if
	return chan
end calculateChan

on calculateScene(num)
	set scene to integer
	if num is less than 129 then
		set scene to num - 1
	else if num is greater than 128 and num is less than 256 then
		set scene to num - 129
	else if num is greater than 255 and num is less than 383 then
		set scene to num - 256
	else if num is greater than 382 and num is less than 508 then
		set scene to num - 383
	end if
	
	return scene
end calculateScene