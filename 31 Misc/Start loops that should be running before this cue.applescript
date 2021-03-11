tell application id "com.figure53.Qlab.4" to tell front workspace
	set theCue to last item of (selected as list)
	set theCueID to uniqueID of theCue
	set allGroups to every cue of (first cue list whose q name is "Main Cue List")
	repeat with eachCue in allGroups
		set eachCueID to uniqueID of eachCue
		if q type of eachCue is "Group" and q number of eachCue is not "" then
			if eachCueID is theCueID then
				exit repeat
			end if
			set groupPreWait to pre wait of eachCue
			set groupDuration to duration of eachCue
			set groupPostWait to post wait of eachCue
			load eachCue time (groupPreWait + groupDuration + groupPostWait)
			start eachCue
		end if
	end repeat
	
end tell


-- IMPROVEMENTS

-- Check contents of groups to see if there's a loop and only load those, plus checking for stops
-- Currently plays some of every looped sfx and v quickly stops them later if they need to.