-- User defined variables

set theChannels to {"Proz Left", "Proz Right", "Sub", "Left Foldback", "Right Foldback", "Reverb"} -- sadly currently you have to type them all manually. Proz not pros due to pronunciation
set saveLocation to "/Users/Ben/Desktop/Line Checks/"
set fileType to ".wav"

set userLevel to -12
set howManyOutputs to 10

set userDelay to 0.5 -- delay between each file in seconds

-- Speak output names 
set outputNumber to count of theChannels

set chanNum to 0

repeat with eachOutput from 1 to outputNumber
	set chanNum to chanNum + 1
	say (item eachOutput of theChannels) using "Daniel" saving to (POSIX file saveLocation & chanNum & " " & (item eachOutput of theChannels) as string) & fileType
end repeat



-- Import into Qlab

-- WRITE THIS BIT HERE




-- Set levels of line check audio files sequentially.

-- NB currently written requiring you to select them!


tell application "QLab 4" to tell front workspace
	
	set selectedCues to (selected as list)
	
	set howManyCues to count of selectedCues
	
	set whichCue to 0
	
	repeat with eachCue in selectedCues
		
		set whichCue to whichCue + 1
		
		setLevel eachCue row 0 column whichCue db userLevel
		
		repeat with eachOutput from 1 to howManyOutputs
			
			setLevel eachCue row 1 column eachOutput db 0
			
		end repeat
		
	end repeat
	
end tell



-- Set predelays of line check files in a fire-all-at-once group cue. Select all except the first one and run.


tell application "QLab 4" to tell front workspace
	
	
	set listOfCues to (selected as list)
	
	repeat with currentCue in listOfCues
		--set currentCue to last item of (selected as list)
		
		set previousCue to cue before currentCue
		
		--start (previousCue)
		
		set previousDuration to duration of previousCue
		
		set previousPreWait to pre wait of previousCue
		
		--display dialog previousDuration
		
		set pre wait of currentCue to (previousDuration + previousPreWait + userDelay)
		
	end repeat
	
	
	
end tell