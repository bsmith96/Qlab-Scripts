##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: TRUE

### Offset midi triggers of selected cues


tell application "QLab 4"
	tell front workspace
		set selectedCues to (selected as list)
		
		
		display dialog "By how much would you like to offset the midi trigger value of the selected cues?" default answer "" buttons {"Offset", "Cancel"} cancel button "Cancel" default button "Offset"
		set offsetAmount to text returned of result as integer
		
		--if select (cue in cue list "Main Cue List" whose cue number is userOffset) then
		--set firstOffsetCue to q number in cue list "MCL" is userOffset
		--set cuesToOffset to (cues in cue list "Main Cue List" does not come before firstOffsetCue)
		--else
		--	error number 512
		--end if
		
		repeat with eachCue in selectedCues
			set oldMidiTrigger to midi trigger of eachCue
			set oldMidiCommand to midi command of eachCue
			set oldByteOne to midi byte one of eachCue
			set oldByteTwo to midi byte two of eachCue
			
			if oldMidiCommand is program_change then
				if (oldByteOne + offsetAmount) is less than or equal to 127 then
					set midi trigger of eachCue to oldMidiTrigger
					--set midi command of eachCue to program_change
					set midi byte one of eachCue to oldByteOne + offsetAmount
					--set midi byte two of eachCue to oldByteTwo + offsetAmount
				else
					set midi trigger of eachCue to oldMidiTrigger
					set midi byte one of eachCue to (oldByteOne + offsetAmount - 128)
					display dialog "ALERT: Cue number " & q number of eachCue & " requires a change of midi channel"
				end if
			end if
			
		end repeat
		
		(*if ((count items in itemList) is not equal to Â
		(count integers in itemList)) then
		-- If all items arenÕt integers, signal an error.
		error number 750
	end if*)
		
		
	end tell
end tell