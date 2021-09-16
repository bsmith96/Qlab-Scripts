-- @description Create PM scene recall
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 2.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Creates a midi cue to recall a scene on Yamaha Rivage PM mixing desks
-- @separateprocess TRUE

-- @changelog
--   v2.0  + moved common functions to external script


-- USER DEFINED VARIABLES -----------------

set userColor to "green"

set colorParentGroups to true -- set colour of any groups containing the recall group as well?

set cueListName to "Main Cue List" -- Name of main cue list

---------- END OF USER DEFINED VARIABLES --


property util : script "Applescript Utilities"


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	-- set scene number to recall
	display dialog "Please select a scene number to recall" default answer "" buttons {"Set", "Cancel"} cancel button "Cancel" default button "Set" with title "SCENE NUMBER"
	set sceneNumber to text returned of result as string
	
	-- set midi command to recall
	display dialog "Please select the midi program change to recall, in the format \"Channel Value\"" default answer "" buttons {"Set", "Cancel"} cancel button "Cancel" default button "Set" with title "MIDI PROGRAM CHANGE"
	set midiCommandString to text returned of result as string
	
	-- calculate the channel and value
	set midiCommandList to util's splitString(midiCommandString, " ")
	set chanNum to item 1 of midiCommandList
	set valueNum to item 2 of midiCommandList
	set valueNum to valueNum - 1
	
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
	set byte one of midiBank to valueNum
	move cue id midiBankID of parent of midiBank to end of sceneGroup
	set q name of midiBank to "Scene " & sceneNumber & ": Program Change"
	
	-- Color the group and any groups containing the group
	set q color of sceneGroup to userColor
	
	if colorParentGroups is true then
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