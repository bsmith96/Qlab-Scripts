-- @description Create fade in
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 1.2
-- @testedmacos 10.13.6
-- @testedqlab 4.6.10
-- @about Create a fade in for the selected audio/group cue
-- @separateprocess TRUE

-- @changelog
--   v1.2  + implemented q display name in renaming
--         + runs script in separate process
--   v1.1  + if no cue name, script uses file name
--   v1.0  + init


tell application id "com.figure53.Qlab.4" to tell front workspace
	set originalCue to last item of (selected as list)

	-- Create fade in for an audio cue

	if q type of originalCue is "Audio" then
		set originalCueLevel to originalCue getLevel row 0 column 0
		originalCue setLevel row 0 column 0 db -120
		set originalPreWait to pre wait of originalCue
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCue
		set pre wait of newCue to originalPreWait
		newCue setLevel row 0 column 0 db originalCueLevel
		set q name of newCue to "Fade in: " & q display name of originalCue

	-- Create fade in for each audio cue in a selected group

	else if q type of originalCue is "Group" then
		set originalCueName to q name of originalCue
		set cuesToFade to (cues in originalCue)
		make type "Group"
		set fadeGroup to last item of (selected as list)
		set fadeGroupID to uniqueID of fadeGroup
		set q name of fadeGroup to "Fade in: " & originalCueName
		repeat with eachCue in cuesToFade
			if q type of eachCue is "Audio" then
				set eachCueLevel to eachCue getLevel row 0 column 0
				eachCue setLevel row 0 column 0 db -120
				set eachPreWait to pre wait of eachCue
				make type "Fade"
				set newCue to last item of (selected as list)
				set cue target of newCue to eachCue
				set pre wait of newCue to eachPreWait
				newCue setLevel row 0 column 0 db eachCueLevel
				set q name of newCue to "Fade in: " & q display name of eachCue
				set newCueID to uniqueID of newCue
				move cue id newCueID of parent of newCue to end of fadeGroup
			end if
		end repeat
	end if
end tell