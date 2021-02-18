##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

### Create GLD/SQ scene recall with name


tell front workspace
	-- Set scene number to recall
	display dialog "Please select a scene number to recall" default answer "" buttons {"Set", "Cancel"} cancel button "Cancel" default button "Set" with title "SCENE NUMBER"
	set sceneNumber to text returned of result as integer
	display dialog "What would you like to name this scene" default answer "" buttons {"Set", "Cancel"} cancel button "Cancel" default button "Set" with title "SCENE NAME"
	set sceneName to text returned of result
	
end tell

set bankNumHex to calculateBank(sceneNumber)
set sceneNumHex to calculateScene(sceneNumber)

set bankMessage to "B0 00 " & bankNumHex
set sceneMessage to " C0 " & sceneNumHex

set sceneGroupName to "Scene " & sceneNumber & ": " & sceneName
tell front workspace
	
	-- Make overall group
	make type "Group"
	set sceneGroup to first item of (selected as list)
	set sceneGroupIsIn to parent of sceneGroup
	set mode of sceneGroup to timeline
	set q name of sceneGroup to sceneGroupName
	
	-- Make the Bank + Program Select midi cue
	make type "Midi"
	set midiBank to first item of (selected as list)
	set midiBankID to uniqueID of midiBank
	set message type of midiBank to sysex
	set sysex message of midiBank to bankMessage & sceneMessage
	move cue id midiBankID of parent of midiBank to end of sceneGroup
	set pre wait of midiBank to 0
	set q name of midiBank to "Scene " & sceneNumber & ": bank + program change"
	
	-- Make the Scene Select midi cue
	(*make type "Midi"
	set midiScene to first item of (selected as list)
	set midiSceneID to uniqueID of midiScene
	set message type of midiScene to sysex
	set sysex message of midiScene to sceneMessage
	move cue id midiSceneID of parent of midiScene to end of sceneGroup
	set pre wait of midiScene to 0.02
	set q name of midiScene to "Scene " & sceneNumber & ": scene select"*)
	
	set q color of sceneGroup to "green"
	collapse sceneGroup
	
end tell

on calculateBank(num)
	set bank to integer
	if num is less than 129 then
		set bank to "00"
	end if
	if num is greater than 128 and num is less than 257 then
		set bank to "01"
	end if
	if num is greater than 256 and num is less than 385 then
		set bank to "02"
	end if
	if num is greater than 384 and num is less than 501 then
		set bank to "03"
	end if
	
	
	set bankNumHex to bank
end calculateBank

on calculateScene(num)
	set scene to integer
	if num is less than 129 then
		set scene to num - 1
	end if
	if num is greater than 128 and num is less than 257 then
		set scene to (num - 129)
	end if
	if num is greater than 256 and num is less than 385 then
		set scene to (num - 257)
	end if
	if num is greater than 384 and num is less than 501 then
		set scene to (num - 385)
	end if
	
	set sceneHex to do shell script "perl -e 'printf(\"%02X\", " & scene & ")'"
	
	set sceneNumHex to sceneHex
end calculateScene