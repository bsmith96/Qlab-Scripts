-- @description Preset desk to before next cue
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.2
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Recalls the most recently recalled scene, if scene recalls have been generated with these scripts
-- @separateprocess TRUE

-- @changelog
--   v1.2  + allows assignment of UDVs from the script calling this one
--   v1.1  + now works correctly when the playhead does not contain a desk cue


-- USER DEFINED VARIABLES -----------------

try -- if global variables are given when this script is called by another, use those variables
	cueListName
on error
	set cueListName to "Main Cue List"
end try

try
	howManyToRecall
on error
	set howManyToRecall to 1 -- To load several scenes quickly, e.g. if you are using recall filters and want to load the last 5 to ensure you have the correct settings running into the next scene.
end try

try
	recallDelay
on error
	set recallDelay to 0.5 -- Delay in seconds between recalls, when howManyToRecall is greater than 1
end try

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

-- Define lists to add cues to
set allCuesBeforePlayhead to {}
set sceneRecallCues to {}
set allSceneRecallCues to {}
set cueListMidiCues to {}
set howManyToRecallList to {}

tell application id "com.figure53.Qlab.4" to tell front workspace
	set theCue to playback position of (first cue list whose q name is cueListName)
	set theCueID to uniqueID of theCue
	set allCues to every cue of (first cue list whose q name is cueListName)
	
	-- Get a list of all top-level cues before the playhead
	repeat with eachCue in allCues
		if uniqueID of eachCue is theCueID then
			exit repeat
		end if
		set end of allCuesBeforePlayhead to uniqueID of eachCue
	end repeat
	
	-- Get all midi cues in main cue list
	set allMidiCues to every cue whose q type is "Midi"
	repeat with eachCue in allMidiCues
		if parent list of eachCue is (first cue list whose q name is cueListName) then set end of cueListMidiCues to eachCue
	end repeat
	
	-- Get all scene recall cues (based on current naming scheme of desk midi cues)
	repeat with eachCue in cueListMidiCues
		if q name of eachCue starts with "Scene " and q name of eachCue ends with "change" then set end of allSceneRecallCues to eachCue
	end repeat
	
	-- Get main group containing all scene recall cues
	repeat with eachCue in allSceneRecallCues
		set eachParent to parent of eachCue
		
		-- Find the main group
		repeat
			if parent of eachCue is (first cue list whose q name is cueListName) then
				set eachParentID to uniqueID of eachCue
				exit repeat
			else if parent of eachParent is (first cue list whose q name is cueListName) then
				set eachParentID to uniqueID of eachParent
				exit repeat
			else
				set eachParent to parent of eachParent
			end if
		end repeat
		
		-- Put cues into new group until you reach the current selection
		
		if eachParentID is in allCuesBeforePlayhead then
			set end of sceneRecallCues to eachCue
		end if
	end repeat
	
	-- Recall most recent scene recall cue
	
	if howManyToRecall is 1 then
		set cueToGo to q name of (item -1 of sceneRecallCues)
		log cueToGo
		start (item -1 of sceneRecallCues)
		
		-- Recall as many cues before the most recent as specified, with the specified delay between recalls
	else if howManyToRecall is greater than 1 then
		repeat with i from 1 to howManyToRecall
			set end of howManyToRecallList to i
		end repeat
		repeat with i in reverse of howManyToRecallList -- Reverse to recall cues in the correct order
			try
				set allCuesCount to count of sceneRecallCues
				set cueToGo to q name of (item -i of sceneRecallCues)
				log cueToGo
				start (item -i of sceneRecallCues)
				delay recallDelay
			end try
		end repeat
	end if
	
end tell