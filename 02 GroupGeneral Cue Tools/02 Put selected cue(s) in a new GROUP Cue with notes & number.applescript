##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

### Put selected cue(s) in a new GROUP Cue with notes & number


tell front workspace
	set selectedCues to selected as list
	if (count selectedCues) is not 0 then
		
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