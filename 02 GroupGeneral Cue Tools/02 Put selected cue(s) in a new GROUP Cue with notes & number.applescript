-- @description Put selected cues in a new group cue with notes and number
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Adds a group cue above the current selection with the name, notes and number of the first selected cue, and puts the selected cues into the group
-- @separateprocess FALSE

-- @changelog
--   v1.0  + init


tell front workspace

	try -- This will stop the script if we're in a cart, as it doesn't make sense to continue!
		set inACart to mode of current cue list -- ###FIXME### As of 4.1.3, this throws an error for carts; if this is fixed this section won't work
	on error
		return
	end try

	set selectedCues to selected as list
	if (count selectedCues) is not 0 then
		
		set selected to last item of selectedCues
		make type "Group"
		set groupCue to last item of (selected as list)
		set groupCueIsIn to parent of groupCue
		
		set cueNumber to q number of first item of selectedCues
		set q number of first item of selectedCues to ""
		set q number of groupCue to cueNumber
		repeat with i from 1 to (count selectedCues)
			set eachName to q name of item i of selectedCues
			if i = 1 then
				set cueName to eachName
			else
				if eachName ­ "" then
					set cueName to cueName & " & " & eachName
				end if
			end if
		end repeat
		set q name of groupCue to cueName
		set cueNotes to notes of first item of selectedCues
		if cueNotes is not missing value then
			set notes of first item of selectedCues to ""
			set notes of groupCue to cueNotes
		end if
		
		repeat with eachCue in selectedCues
			if contents of eachCue is not groupCueIsIn then -- Skip a Group Cue that contains the new Group Cue
				set eachCueID to uniqueID of eachCue
				move cue id eachCueID of parent of eachCue to end of groupCue
			end if
		end repeat
		
	end if
end tell